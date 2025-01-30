import 'package:dartblaze/dartblaze.dart';
import 'package:functions_framework/functions_framework.dart';

@OnDocumentCreated('todos/{todoId}')
Future<void> oncreatetodo(DocumentSnapshot snapshot, RequestContext context,
    {required String todoId}) async {
  context.logger.debug('todoId: ${todoId}');
  final data = snapshot.data();
  final title = data?['title'] as String?;
  await snapshot.ref.update({'title': '$title from server!'});
}

@OnDocumentUpdated('todos/{todoId}')
Future<void> onupdatetodo(UpdateDocumentChange change, RequestContext context,
    {required String todoId}) async {
  final before = change.before.data();
  final after = change.after.data();
  context.logger.debug('todoId: $todoId');
  context.logger.debug('before: $before');
  context.logger.debug('after: $after');
}

@OnDocumentDeleted('todos/{todoId}')
Future<void> ondeletetodo(DocumentSnapshot snapshot, RequestContext context,
    {required String todoId}) async {
  final data = snapshot.data();
  context.logger.debug('todoId: $todoId');
  context.logger.debug('data: $data');
}

@OnDocumentWritten('todos/{todoId}')
Future<void> onwritetodo(WriteDocumentChange change, RequestContext context,
    {required String todoId}) async {
  final before = change.before?.data();
  final after = change.after?.data();
  context.logger.debug('todoId: $todoId');
  context.logger.debug('before: $before');
  context.logger.debug('after: $after');
}
