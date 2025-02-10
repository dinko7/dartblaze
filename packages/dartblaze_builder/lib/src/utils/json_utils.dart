import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

extension JsonMethodChecker on DartType {
  bool get hasFromJson {
    if (this is! InterfaceType) return false;
    final element = (this as InterfaceType).element;

    final hasFactoryFromJson = element.constructors.any((constructor) =>
        constructor.isFactory &&
        constructor.name == 'fromJson' &&
        _hasMapStringDynamicParameter(constructor));

    final hasStaticFromJson = element.methods.any((method) =>
        method.name == 'fromJson' &&
        method.isStatic &&
        _hasMapStringDynamicParameter(method));

    return hasFactoryFromJson || hasStaticFromJson;
  }
}

bool _hasMapStringDynamicParameter(ExecutableElement element) {
  if (element.parameters.isEmpty) return false;

  final param = element.parameters.first;
  final paramType = param.type;

  if (paramType is InterfaceType) {
    return paramType.isDartCoreMap &&
        paramType.typeArguments.length == 2 &&
        paramType.typeArguments[0].isDartCoreString &&
        paramType.typeArguments[1] is DynamicType;
  }

  return false;
}
