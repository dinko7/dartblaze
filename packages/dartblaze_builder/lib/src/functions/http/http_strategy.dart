import 'package:analyzer/dart/element/element.dart';
import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_builder/src/common/import_registry.dart';
import 'package:dartblaze_builder/src/utils/json_utils.dart';
import 'package:dartblaze_builder/src/utils/type_check_utils.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';
import 'package:source_gen/source_gen.dart';

//TODO: move validation to a method
class HttpFunctionData extends FunctionData {
  const HttpFunctionData(
    super.functionName, {
    required this.hasRequestLoggerParameter,
    required this.bodyParameter,
    required this.hasRequestParameter,
  });

  final bool hasRequestLoggerParameter;
  final BodyParameter? bodyParameter;
  final bool hasRequestParameter;

  factory HttpFunctionData.fromFunctionElement(
    FunctionElement element, {
    required bool hasRequestLoggerParameter,
  }) {
    _validate(element);

    bool hasRequestParam = false;
    BodyParameter? bodyParam;

    final firstParam = element.parameters.first;
    if (firstParam.type.isType(Request)) {
      hasRequestParam = true;
    } else if (!firstParam.type.isType(RequestLogger)) {
      // If not Request or RequestLogger, treat as body parameter
      if (!firstParam.type.hasFromJson) {
        throw InvalidGenerationSourceError(
          'Type ${firstParam.type.getDisplayString()} must have a '
          'fromJson factory constructor or method',
          element: firstParam,
        );
      }

      // Register the import for the parameter type
      final typeElement = firstParam.type.element;
      if (typeElement != null) {
        final libraryElement = typeElement.library;
        if (libraryElement != null && !libraryElement.isDartCore) {
          ImportRegistry.instance.addImport(libraryElement.source.uri.import);
        }
      }

      bodyParam = BodyParameter(
        parameterName: firstParam.name,
        type: firstParam.type,
      );
    }

    return HttpFunctionData(
      element.name,
      hasRequestLoggerParameter: hasRequestLoggerParameter,
      bodyParameter: bodyParam,
      hasRequestParameter: hasRequestParam,
    );
  }

  /// Validates the function signature.
  /// Allowed signatures:
  /// - `Future<Response> Function(Request request)`
  /// - `Future<Response> Function(Request request, RequestLogger logger)`
  /// - `Future<Response> Function(T body)`
  /// - `Future<Response> Function(T body, RequestLogger logger)`
  static void _validate(FunctionElement element) {
    // Validate return type
    final returnType = element.returnType;
    final responseType = returnType.alias?.typeArguments.first ?? returnType;
    if (!returnType.isDartAsyncFuture ||
        (responseType.getDisplayString() != 'Response' &&
            responseType.getDisplayString() != 'Future<Response>')) {
      throw InvalidGenerationSourceError(
        'HTTP Function must return Future<Response>',
        element: element,
      );
    }

    // Validate parameters
    final params = element.parameters;
    if (params.isEmpty || params.length > 2) {
      throw InvalidGenerationSourceError(
        'Function must have either 1 required parameter or 1 required and 1 optional parameter',
        element: element,
      );
    }

    // Check first parameter
    final firstParam = params.first;
    if (!firstParam.isRequiredPositional) {
      throw InvalidGenerationSourceError(
        'First parameter must be required',
        element: firstParam,
      );
    }
  }
}

class HttpStrategy extends FunctionStrategy<HttpFunctionData> {
  const HttpStrategy(super.importPrefix);

  @override
  String generate(HttpFunctionData data) {
    final buffer = StringBuffer();

    buffer.write("'${data.functionName}' => FunctionTarget.http");
    if (data.hasRequestLoggerParameter) {
      buffer.write('WithLogger');
    }
    buffer.write('(');

    // If it's a Request parameter and no body, pass the function directly
    if (data.hasRequestParameter && data.bodyParameter == null) {
      buffer.write('$importPrefix.${data.functionName}');
    }
    // If there's a body parameter, we need to wrap it
    else if (data.bodyParameter != null) {
      if (data.hasRequestLoggerParameter) {
        buffer.write('(request, logger) async {\n');
      } else {
        buffer.write('(request) async {\n');
      }
      buffer.write(
        '    final ${data.bodyParameter!.parameterName} = '
        'await request.body.as<${data.bodyParameter!.type.getDisplayString()}>'
        '((json) => ${data.bodyParameter!.type.getDisplayString()}.fromJson(json));\n',
      );
      buffer.write('    return await $importPrefix.${data.functionName}(');
      buffer.write('${data.bodyParameter!.parameterName}');
      if (data.hasRequestLoggerParameter) {
        buffer.write(', logger');
      }
      buffer.write(');\n  }');
    }

    buffer.write('),\n');
    return buffer.toString();
  }
}
