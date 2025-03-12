import 'package:dartblaze/dartblaze.dart';
import 'package:example/models/todo.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';

@Http()
Future<Response> updateTodo(Todo todo) async {
  firestore.collection('todos').doc(todo.id).update(todo.toJson());
  return Response.ok('Todo updated: ${todo.id}');
}

@Http()
Future<Response> updateTodoRequest(Request request) async {
  //
  final authValidator = FirebaseAuthValidator();
  await authValidator.init();
  final authHeader = request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.forbidden('Authorization header missing or invalid format');
  }

  // Extract the token from the authorization header
  final jwt = authHeader.substring(7); // Remove 'Bearer ' prefix

  // Validate the Firebase ID token
  final idToken = await authValidator.validate(jwt);

  // Check if token is verified
  if (idToken.isVerified != true) {
    return Response.forbidden('Firebase Id Token is not verified');
  }

  //
  // final todo = await request.body.as(Todo.fromJson);
  // firestore.collection('todos').doc(todo.id).update(todo.toJson());
  // return Response.ok('Todo updated: ${todo.id}');

  return Response.ok('Success.');
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
