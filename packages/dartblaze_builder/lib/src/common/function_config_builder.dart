import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_shared/config/function_config.dart';

abstract class FunctionConfigBuilder {
  FunctionConfig buildConfig(FunctionData data);
}
