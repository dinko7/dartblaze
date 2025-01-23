---
title: Firestore Triggers
description: Learn how to use Firestore triggers in Dartblaze
---

# Firestore Triggers

Dartblaze makes it easy to respond to Firestore events. 

You can listen to document creation, updates, and deletions and writes.

[Auth Firestore triggers](https://firebase.google.com/docs/functions/firestore-events?gen=2nd#auth-context) (suffixed `WithAuthContext`) are not available at this time.

## Path Format and Parameters

The trigger annotations accept a path string that follows the Firestore document path format. Path segments that start with `{` and end with `}` are treated as parameters.

```dart
@OnDocumentCreated('collection/{docId}/subcollection/{subDocId}')
```

Each parameter in the path must have a corresponding named parameter in the function signature. The parameter name in your function signature must exactly match the name inside the curly braces in your path.

```dart
// ✅ Correct - parameter names match the path
@OnDocumentCreated('todos/{todoId}/logs/{logId}')
Future<void> oncreatelog(
  DocumentSnapshot snapshot,
  RequestContext context, {
  required String todoId,  // Matches {todoId}
  required String logId,   // Matches {logId}
}) async {}

// ❌ Incorrect - parameter names don't match
@OnDocumentCreated('todos/{todoId}')
Future<void> oncreatelog(
  DocumentSnapshot snapshot,
  RequestContext context, {
  required String id,  // Wrong! The parameter name 'id' doesn't match '{todoId}'
}) async {}
```

All path parameters are always provided as required named String parameters in the function signature. This ensures type safety and makes the relationship between the path and function parameters explicit.

## @OnDocumentCreated

Executes when a document is created in Firestore.

**Signature:**
```dart
Future<void> functionName(
  DocumentSnapshot snapshot,
  RequestContext context,
  {required String documentId}
)
```

**Parameters:**
- `snapshot`: Contains the data of the created document
- `context`: Provides access to logging and other contextual information
- `documentId`: Named parameter containing the ID of the created document

**Example:**
```dart
@OnDocumentCreated('todos/{todoId}')
Future<void> oncreatetodo(
  DocumentSnapshot snapshot,
  RequestContext context,
  {required String todoId}
) async {
  final data = snapshot.data();
  final title = data?['title'] as String?;
  await snapshot.ref.update({'title': '$title from server!'});
}
```

## @OnDocumentUpdated

Executes when a document is updated in Firestore.

**Signature:**
```dart
Future<void> functionName(
  UpdateDocumentChange change,
  RequestContext context,
  {required String documentId}
)
```

**Parameters:**
- `change`: Contains both the before and after states of the document
- `context`: Provides access to logging and other contextual information
- `documentId`: Named parameter containing the ID of the updated document

**Example:**
```dart
@OnDocumentUpdated('todos/{todoId}')
Future<void> onupdatetodo(
  UpdateDocumentChange change,
  RequestContext context,
  {required String todoId}
) async {
  final before = change.before.data();
  final after = change.after.data();
  // Process the changes
}
```

## @OnDocumentDeleted

Executes when a document is deleted from Firestore.

**Signature:**
```dart
Future<void> functionName(
  DocumentSnapshot snapshot,
  RequestContext context,
  {required String documentId}
)
```

**Parameters:**
- `snapshot`: Contains the data of the deleted document
- `context`: Provides access to logging and other contextual information
- `documentId`: Named parameter containing the ID of the deleted document

**Example:**
```dart
@OnDocumentDeleted('todos/{todoId}')
Future<void> ondeletetodo(
  DocumentSnapshot snapshot,
  RequestContext context,
  {required String todoId}
) async {
  final data = snapshot.data();
  // Process the deleted data
}
```

## @OnDocumentWritten

Executes on any write operation (create, update, or delete) to a document.

**Signature:**
```dart
Future<void> functionName(
  WriteDocumentChange change,
  RequestContext context,
  {required String documentId}
)
```

**Parameters:**
- `change`: Contains both the before and after states of the document
- `context`: Provides access to logging and other contextual information
- `documentId`: Named parameter containing the ID of the written document

**Example:**
```dart
@OnDocumentWritten('todos/{todoId}')
Future<void> onwritetodo(
  WriteDocumentChange change,
  RequestContext context,
  {required String todoId}
) async {
  final before = change.before?.data();
  final after = change.after?.data();
  // Process the changes
}
```

## Working with Subcollections

Firestore triggers support monitoring changes in subcollections. When working with subcollections, all parent and child document IDs are provided as named parameters.

**Example:**
```dart
@OnDocumentCreated('todos/{todoId}/logs/{logId}')
Future<void> oncreatelog(
  DocumentSnapshot snapshot,
  RequestContext context, {
  required String todoId,
  required String logId,
}) async {
  // Process the subcollection document
}
```