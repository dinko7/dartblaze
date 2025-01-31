// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:dartblaze/dartblaze.dart';
import 'package:example/functions/firestore_triggers_todo.dart' as f0;
import 'package:example/functions/http.dart' as f1;
import 'package:example/models/todo.dart';
import 'package:functions_framework/serve.dart';

Future<void> main(List<String> args) async {
  initializeAdminApp();
  await serve(args, _nameToFunctionTarget);
}

FunctionTarget? _nameToFunctionTarget(String name) => switch (name) {
      'oncreatetodo' => FunctionTarget.cloudEventWithContext((event, context) {
          const pathPattern = 'todos/{todoId}';
          final documentIds =
              FirestorePathParser(pathPattern).parse(event.subject!);
          final data =
              FirestoreEventDataFactory(event).build() as DocumentCreatedData;
          return f0.oncreatetodo(
            data.snapshotOrChange,
            context,
            todoId: documentIds['todoId']!,
          );
        }),
      'onupdatetodo' => FunctionTarget.cloudEventWithContext((event, context) {
          const pathPattern = 'todos/{todoId}';
          final documentIds =
              FirestorePathParser(pathPattern).parse(event.subject!);
          final data =
              FirestoreEventDataFactory(event).build() as DocumentUpdatedData;
          return f0.onupdatetodo(
            data.snapshotOrChange,
            context,
            todoId: documentIds['todoId']!,
          );
        }),
      'ondeletetodo' => FunctionTarget.cloudEventWithContext((event, context) {
          const pathPattern = 'todos/{todoId}';
          final documentIds =
              FirestorePathParser(pathPattern).parse(event.subject!);
          final data =
              FirestoreEventDataFactory(event).build() as DocumentDeletedData;
          return f0.ondeletetodo(
            data.snapshotOrChange,
            context,
            todoId: documentIds['todoId']!,
          );
        }),
      'onwritetodo' => FunctionTarget.cloudEventWithContext((event, context) {
          const pathPattern = 'todos/{todoId}';
          final documentIds =
              FirestorePathParser(pathPattern).parse(event.subject!);
          final data =
              FirestoreEventDataFactory(event).build() as DocumentWrittenData;
          return f0.onwritetodo(
            data.snapshotOrChange,
            context,
            todoId: documentIds['todoId']!,
          );
        }),
      'oncreatelog' => FunctionTarget.cloudEventWithContext((event, context) {
          const pathPattern = 'todos/{todoId}/logs/{logId}';
          final documentIds =
              FirestorePathParser(pathPattern).parse(event.subject!);
          final data =
              FirestoreEventDataFactory(event).build() as DocumentCreatedData;
          return f0.oncreatelog(
            data.snapshotOrChange,
            context,
            todoId: documentIds['todoId']!,
            logId: documentIds['logId']!,
          );
        }),
      'updateTodo' => FunctionTarget.http((request) async {
          final todo =
              await request.body.as<Todo>((json) => Todo.fromJson(json));
          return await f1.updateTodo(todo);
        }),
      'updateTodoRequest' => FunctionTarget.http(f1.updateTodoRequest),
      'updateTodoLogger' =>
        FunctionTarget.httpWithLogger((request, logger) async {
          final todo =
              await request.body.as<Todo>((json) => Todo.fromJson(json));
          return await f1.updateTodoLogger(todo, logger);
        }),
      'updateTodoRequestLogger' =>
        FunctionTarget.httpWithLogger(f1.updateTodoRequestLogger),
      _ => null
    };
