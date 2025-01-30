// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:dartblaze/dartblaze.dart';
import 'package:example/functions/firestore_triggers_todo.dart' as f1;
import 'package:example/functions/http.dart' as f3;
import 'package:example/functions/on_create_log.dart' as f0;
import 'package:example/functions/on_create_submission.dart' as f2;
import 'package:example/models/todo.dart';
import 'package:functions_framework/serve.dart';

Future<void> main(List<String> args) async {
  initializeAdminApp();
  await serve(args, _nameToFunctionTarget);
}

FunctionTarget? _nameToFunctionTarget(String name) => switch (name) {
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
      'oncreatetodo' => FunctionTarget.cloudEventWithContext((event, context) {
          const pathPattern = 'todos/{todoId}';
          final documentIds =
              FirestorePathParser(pathPattern).parse(event.subject!);
          final data =
              FirestoreEventDataFactory(event).build() as DocumentCreatedData;
          return f1.oncreatetodo(
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
          return f1.onupdatetodo(
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
          return f1.ondeletetodo(
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
          return f1.onwritetodo(
            data.snapshotOrChange,
            context,
            todoId: documentIds['todoId']!,
          );
        }),
      'oncreatesubmission' =>
        FunctionTarget.cloudEventWithContext((event, context) {
          const pathPattern = 'submissions/{submissionId}';
          final documentIds =
              FirestorePathParser(pathPattern).parse(event.subject!);
          final data =
              FirestoreEventDataFactory(event).build() as DocumentCreatedData;
          return f2.oncreatesubmission(
            data.snapshotOrChange,
            context,
            submissionId: documentIds['submissionId']!,
          );
        }),
      'updateTodo' => FunctionTarget.http((request) async {
          final todo =
              await request.body.as<Todo>((json) => Todo.fromJson(json));
          return await f3.updateTodo(todo);
        }),
      'updateTodoRequest' => FunctionTarget.http(f3.updateTodoRequest),
      'updateTodoLogger' =>
        FunctionTarget.httpWithLogger((request, logger) async {
          final todo =
              await request.body.as<Todo>((json) => Todo.fromJson(json));
          return await f3.updateTodoLogger(todo, logger);
        }),
      'updateTodoRequestLogger' =>
        FunctionTarget.httpWithLogger(f3.updateTodoRequestLogger),
      _ => null
    };
