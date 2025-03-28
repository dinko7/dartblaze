import 'package:dartblaze/dartblaze.dart';
import 'package:example/models/todo.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';

@Http()
Future<Response> updateTodo(Todo todo) async {
  firestore.collection('todos').doc(todo.id).update(todo.toJson());
  return Response.ok('Todo updated: ${todo.id}');
}

@Http(auth: false)
Future<Response> updateTodoNoAuth(Todo todo) async {
  firestore.collection('todos').doc(todo.id).update(todo.toJson());
  return Response.ok('Todo updated: ${todo.id}');
}

@Http()
Future<Response> updateTodoRequest(
  Request request, {
  required IdToken authToken,
}) async {
  final todo = await request.body.as(Todo.fromJson);
  firestore.collection('todos').doc(todo.id).update(todo.toJson());
  return Response.ok('Todo updated: ${todo.id}');
}

@Http()
Future<Response> updateTodoLogger(Todo todo, RequestLogger logger) async {
  firestore.collection('todos').doc(todo.id).update(todo.toJson());
  return Response.ok('Todo updated: ${todo.id}');
}

@Http()
Future<Response> updateTodoRequestLogger(
    Request request, RequestLogger logger) async {
  final todo = await request.body.as(Todo.fromJson);
  firestore.collection('todos').doc(todo.id).update(todo.toJson());
  logger.info('Todo updated: ${todo.id}');
  return Response.ok('Todo updated: ${todo.id}');
}
