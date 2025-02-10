import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

extension TypeCheckUtils on DartType {
  bool isType(Type type) => TypeChecker.fromRuntime(type).isExactlyType(this);

  bool isSubtypeOf(Type type) =>
      TypeChecker.fromRuntime(type).isAssignableFromType(this);
}
