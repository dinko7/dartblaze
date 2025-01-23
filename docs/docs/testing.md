# Testing Cloud Functions

Currently, cloud functions can only be tested locally as HTTP functions.

If you want to test on a real case scenario, the best approach should be creating a test Firebase project which has the same setup as your production Firebase project.

::: tip
Integration with Firebase emulator is in the works.
:::


## Running the Server

```bash
PROJECT_ID=<project_id> dart run bin/server.dart --target=<function_name> --signature-type=<function_type>
```

| Option | Description |
|--------|-------------|
| `--target` | Your function name |
| `--signature-type` | Can be one of the values: `http`, `cloudevent` |

::: tip
You can find the project id in the `.firebaserc` file or by running `firebase projects:list` command.
:::

## Example
 Let's say you have an HTTP function that looks like this:

```dart
class Todo with _$Todo {
  factory Todo({
    required String id,
    required String name,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

@Http()
Future<Response> updateTodo(Todo todo) async {
  firestore.collection('todos').doc(todo.id).update(todo.toJson());
  return Response.ok('Todo updated: ${todo.id}');
}
```

To run this, you would execute:
```bash
PROJECT_ID=fb_test dart run bin/server.dart --target=updateTodo --signature-type=http
```

And then in a second terminal:
```bash
curl -X POST http://localhost:8080/todos \
  -H "Content-Type: application/json" \
  -d '{"id": "123", "name": "Buy groceries"}'
```

As a result, you should see this in your terminal:
```bash
Todo updated: 123
```