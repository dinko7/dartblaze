import 'package:functions_framework/functions_framework.dart';

extension CloudEventExtensions on CloudEvent {
  /// Returns document path: <collection_name>/<document_id>
  /// subject looks like: documents/<collection_name>/<document_id>
  String get subjectPath =>
      toJson()['subject'].toString().replaceFirst('documents/', '');
}
