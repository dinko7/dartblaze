---
title: HTTP Functions
description: Learn how to create HTTP endpoints with Dartblaze
---

# HTTP Functions

The `@Http` annotation simplifies the creation of HTTP endpoint handlers in Dart by providing flexible function signatures and automatic request body deserialization.

Http functions are meant to be used as a replacement for callable Firebase functions and as standalone endpoints.

## Function Signatures

The `@Http` annotation supports four different function signatures, each catering to different use cases:

### 1. Request-Only Handler
```dart
Future<Response> Function(Request request)
```
This signature provides full access to the raw request object, allowing manual handling of all request aspects including headers, query parameters, and body parsing.

```dart
@Http()
Future<Response> updateTodoRequest(Request request) async {
  final todo = await request.body.as(Todo.fromJson);
  // Process the todo...
  return Response.ok('Todo updated: ${todo.id}');
}
```

### 2. Request with Logger Handler
```dart
Future<Response> Function(Request request, RequestLogger logger)
```
Similar to the request-only handler but includes a logger parameter for request-specific logging capabilities.

```dart
@Http()
Future<Response> updateTodoRequestLogger(
    Request request, RequestLogger logger) async {
  final todo = await request.body.as(Todo.fromJson);
  logger.info('Todo updated: ${todo.id}');
  return Response.ok('Todo updated: ${todo.id}');
}
```

### 3. Typed Body Handler
```dart
Future<Response> Function(T body)
```
This signature automatically deserializes the request body into the specified type `T`, simplifying request handling when only the body is needed.

::: warning
Models must have `static` or a `factory` method `fromJson(Map<String, dynamic>)` available.

You can use libraries like `freezed`, `json_serializable` or `dart_mappable` as long as the method singature is as specified.
:::

```dart
@Http()
Future<Response> updateTodo(Todo todo) async {
  // Body is automatically deserialized to Todo
  return Response.ok('Todo updated: ${todo.id}');
}
```

### 4. Typed Body with Logger Handler
```dart
Future<Response> Function(T body, RequestLogger logger)
```
Combines automatic body deserialization with logging capabilities.

```dart
@Http()
Future<Response> updateTodoLogger(Todo todo, RequestLogger logger) async {
  logger.info('Processing todo update: ${todo.id}');
  return Response.ok('Todo updated: ${todo.id}');
}
```

## Authentication

All `@Http` functions have Firebase Auth integration enabled by default. This means that the function expects `Authorization: Bearer <token>` header when being called from client.

Token is Firebase id token, which you can get on the client by calling `await FirebaseAuth.instance.currentUser.getIdToken()`.

You can disable auth for a function in the header: `@Http(auth: false)`.



## :warning: Current Limitations

1. **No Body Validation**: The annotation does not currently support automatic request body validation. Validation must be implemented manually within the handler.

2. **No Middleware Support**: Middleware functionality is not yet available. All request processing must occur within the handler function.

## Response Object

All handler functions must return a `Future<Response>` object. The `Response` class provides various static methods for common HTTP responses:

```dart
// Success responses
Response.ok(body)          // 200 OK
Response.created(body)     // 201 Created

// Error responses
Response.badRequest()      // 400 Bad Request
Response.notFound()        // 404 Not Found
Response.serverError()     // 500 Internal Server Error
```
