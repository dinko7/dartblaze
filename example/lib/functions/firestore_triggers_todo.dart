import 'package:dartblaze/dartblaze.dart';
import 'package:functions_framework/functions_framework.dart';

@OnDocumentCreated('todos/{todoId}')
Future<void> onCreateTodo(DocumentSnapshot snapshot, RequestContext context,
    {required String todoId}) async {
  context.logger.debug('todoId: ${todoId}');
  final data = snapshot.data();
  final title = data?['title'] as String?;
  await snapshot.ref.update({'title': '$title from server!'});
}

@OnDocumentUpdated('todos/{todoId}')
Future<void> onUpdateTodo(UpdateDocumentChange change, RequestContext context,
    {required String todoId}) async {
  final before = change.before.data();
  final after = change.after.data();
  context.logger.debug('todoId: $todoId');
  context.logger.debug('before: $before');
  context.logger.debug('after: $after');
}

@OnDocumentDeleted('todos/{todoId}')
Future<void> onDeleteTodo(DocumentSnapshot snapshot, RequestContext context,
    {required String todoId}) async {
  final data = snapshot.data();
  context.logger.debug('todoId: $todoId');
  context.logger.debug('data: $data');
}

@OnDocumentWritten('todos/{todoId}')
Future<void> onWriteTodo(WriteDocumentChange change, RequestContext context,
    {required String todoId}) async {
  final before = change.before?.data();
  final after = change.after?.data();
  context.logger.debug('todoId: $todoId');
  context.logger.debug('before: $before');
  context.logger.debug('after: $after');
}

@OnDocumentCreated('todos/{todoId}/logs/{logId}')
Future<void> onCreateLog(
  DocumentSnapshot snapshot,
  RequestContext context, {
  required String todoId,
  required String logId,
}) async {
  context.logger.debug('todoId: $todoId');
  context.logger.debug('logId: $logId');
  context.logger.debug('data: ${snapshot.data()}');
}
