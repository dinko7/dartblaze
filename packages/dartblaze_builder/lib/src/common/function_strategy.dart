import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dartblaze/dartblaze.dart';
import 'package:dartblaze_builder/src/functions/firestore/firestore_strategy.dart';
import 'package:dartblaze_builder/src/functions/http/http_strategy.dart';
import 'package:dartblaze_builder/src/utils/type_check_utils.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:source_gen/source_gen.dart';

abstract class FunctionData {
  const FunctionData(this.functionName);

  final String functionName;

  factory FunctionData.fromFunctionElement(FunctionElement functionElement) {
    final elementAnnotation = functionElement.metadata.single;
    final annotationType = elementAnnotation.computeConstantValue()!.type!;

    final isHTTPFunction = annotationType.isType(Http);
    final isFirestoreEventFunction = annotationType.isSubtypeOf(FirestoreEvent);

    bool hasRequestLoggerParameter = false;
    bool hasRequestContextParameter = false;

    for (var parameter in functionElement.parameters) {
      if (parameter.type.isType(RequestLogger)) {
        hasRequestLoggerParameter = true;
      } else if (parameter.type.isType(RequestContext)) {
        hasRequestContextParameter = true;
      }
    }

    if (isHTTPFunction) {
      if (hasRequestContextParameter) {
        throw InvalidGenerationSourceError(
          'RequestContext parameter is not allowed for HTTPFunction.',
          element: functionElement,
        );
      }
      return HttpFunctionData.fromFunctionElement(
        functionElement,
        hasRequestLoggerParameter: hasRequestLoggerParameter,
      );
    } else if (isFirestoreEventFunction) {
      if (hasRequestLoggerParameter) {
        throw InvalidGenerationSourceError(
          'RequestLogger parameter is not allowed for FirestoreTriggeredFunction.',
          element: functionElement,
        );
      }

      return FirestoreEventFunctionData(
        functionElement.name,
        annotation: elementAnnotation,
        hasRequestContextParameter: hasRequestContextParameter,
      );
    }

    throw InvalidGenerationSourceError(
      'Annotation format is not valid.',
      element: functionElement,
    );
  }
}

abstract class FunctionStrategy<T extends FunctionData> {
  final String importPrefix;
  const FunctionStrategy(this.importPrefix);

  String generate(T data);
}

class BodyParameter {
  final String parameterName;
  final DartType type;

  const BodyParameter({
    required this.parameterName,
    required this.type,
  });
}
