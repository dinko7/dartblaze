import 'package:dartblaze/blaze.dart';
import 'package:functions_framework/functions_framework.dart';

@OnDocumentCreated('todos/{todoId}/logs/{logId}')
Future<void> oncreatelog(
  DocumentSnapshot snapshot,
  RequestContext context, {
  required String todoId,
  required String logId,
}) async {
  context.logger.debug('todoId: $todoId');
  context.logger.debug('logId: $logId');
  context.logger.debug('data: ${snapshot.data()}');
}
