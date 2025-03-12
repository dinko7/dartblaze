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
    required this.authRequired,
    required this.idTokenParameterName,
  });

  final bool hasRequestLoggerParameter;
  final BodyParameter? bodyParameter;
  final bool hasRequestParameter;
  final bool authRequired;
  final String? idTokenParameterName;

  factory HttpFunctionData.fromFunctionElement(
    FunctionElement element, {
    required bool hasRequestLoggerParameter,
    required bool authRequired,
  }) {
    _validate(element);

    bool hasRequestParam = false;
    BodyParameter? bodyParam;
    String? idTokenParamName;

    // Check for IdToken named parameter
    for (final param in element.parameters) {
      if (param.isNamed && param.type.getDisplayString() == 'IdToken') {
        idTokenParamName = param.name;
        break;
      }
    }

    final positionalParams =
        element.parameters.where((p) => !p.isNamed).toList();
    final firstParam = positionalParams.first;

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
      authRequired: authRequired,
      idTokenParameterName: idTokenParamName,
    );
  }

  /// Validates the function signature.
  /// Allowed signatures:
  /// - `Future<Response> Function(Request request, {IdToken? idToken})`
  /// - `Future<Response> Function(Request request, RequestLogger logger, {IdToken? idToken})`
  /// - `Future<Response> Function(T body, {IdToken? idToken})`
  /// - `Future<Response> Function(T body, RequestLogger logger, {IdToken? idToken})`
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

    // Count positional parameters (should be 1 or 2)
    final positionalParams = params.where((p) => !p.isNamed).toList();
    if (positionalParams.isEmpty || positionalParams.length > 2) {
      throw InvalidGenerationSourceError(
        'Function must have either 1 or 2 positional parameters',
        element: element,
      );
    }

    // Check first parameter
    final firstParam = positionalParams.first;
    if (!firstParam.isRequiredPositional) {
      throw InvalidGenerationSourceError(
        'First parameter must be required',
        element: firstParam,
      );
    }

    // Check second positional parameter if exists
    if (positionalParams.length > 1) {
      final secondParam = positionalParams[1];
      if (secondParam.type.getDisplayString() != 'RequestLogger') {
        throw InvalidGenerationSourceError(
          'Second positional parameter must be of type RequestLogger',
          element: secondParam,
        );
      }
    }

    // Check named parameters - only IdToken is allowed
    final namedParams = params.where((p) => p.isNamed).toList();
    for (final param in namedParams) {
      if (param.type.getDisplayString() != 'IdToken') {
        throw InvalidGenerationSourceError(
          'Named parameters must be of type IdToken',
          element: param,
        );
      }
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

    // If authentication is required, wrap the function with Firebase auth
    if (data.authRequired) {
      if (data.hasRequestLoggerParameter) {
        buffer.write('(request, logger) async {\n');
      } else {
        buffer.write('(request) async {\n');
      }

      buffer.write('    return await request.withFirebaseAuth(\n');
      buffer.write('      projectId: Env.projectId,\n');
      buffer.write('      onAuthSuccess: (idToken) async {\n');

      // Handle the different function signatures
      if (data.hasRequestParameter) {
        // Pass the request directly
        buffer
            .write('        return await $importPrefix.${data.functionName}(');
        buffer.write('request');
        if (data.hasRequestLoggerParameter) {
          buffer.write(', logger');
        }
        if (data.idTokenParameterName != null) {
          buffer.write(', ${data.idTokenParameterName}: idToken');
        }
        buffer.write(');\n');
      } else if (data.bodyParameter != null) {
        // Parse the body and pass it
        buffer.write(
          '        final ${data.bodyParameter!.parameterName} = '
          'await request.body.as<${data.bodyParameter!.type.getDisplayString()}>'
          '((json) => ${data.bodyParameter!.type.getDisplayString()}.fromJson(json));\n',
        );
        buffer
            .write('        return await $importPrefix.${data.functionName}(');
        buffer.write('${data.bodyParameter!.parameterName}');
        if (data.hasRequestLoggerParameter) {
          buffer.write(', logger');
        }
        if (data.idTokenParameterName != null) {
          buffer.write(', ${data.idTokenParameterName}: idToken');
        }
        buffer.write(');\n');
      }

      buffer.write('      },\n');
      buffer.write('    );\n');
      buffer.write('  }');
    }
    // No authentication required - use existing logic
    else {
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
    }

    buffer.write('),\n');
    return buffer.toString();
  }
}
