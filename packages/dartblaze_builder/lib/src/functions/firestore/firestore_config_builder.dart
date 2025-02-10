import 'package:dartblaze_builder/src/common/function_config_builder.dart';
import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_builder/src/functions/firestore/firestore_strategy.dart';
import 'package:dartblaze_shared/dartblaze_shared.dart';

class FirestoreEventConfigBuilder implements FunctionConfigBuilder {
  @override
  FunctionConfig buildConfig(FunctionData data) {
    if (data is! FirestoreEventFunctionData) {
      throw ArgumentError(
          'Expected FirestoreEventFunctionData but got ${data.runtimeType}');
    }

    return FunctionConfig(
      name: data.functionName,
      signatureType: SignatureType.cloudEvent,
      trigger: TriggerConfig(
        type: data.firestoreDocumentEventType.type,
        documentPath: data.pathPattern,
      ),
    );
  }
}
