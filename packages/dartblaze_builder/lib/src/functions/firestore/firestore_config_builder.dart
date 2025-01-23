import 'package:dartblaze_builder/src/common/function_config_builder.dart';
import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_builder/src/functions/firestore/firestore_strategy.dart';
import 'package:dartblaze_core/blaze_core.dart';

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
        database: '(default)',
        namespace: '(default)',
        documentPath: data.pathPattern,
        eventDataContentType: 'application/protobuf',
      ),
    );
  }
}
