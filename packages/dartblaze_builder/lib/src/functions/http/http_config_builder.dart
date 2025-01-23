import 'package:dartblaze_builder/src/common/function_config_builder.dart';
import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_builder/src/functions/http/http_strategy.dart';
import 'package:dartblaze_core/blaze_core.dart';

class HttpFunctionConfigBuilder implements FunctionConfigBuilder {
  @override
  FunctionConfig buildConfig(FunctionData data) {
    if (data is! HttpFunctionData) {
      throw ArgumentError(
          'Expected HttpFunctionData but got ${data.runtimeType}');
    }

    return FunctionConfig(
      name: data.functionName,
      signatureType: SignatureType.http,
    );
  }
}
