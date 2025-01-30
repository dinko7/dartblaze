# Dartblaze

Dartblaze allows you write Firebase Cloud Functions in pure Dart, bringing type safety, language, ecosystem and packages you already know and love from Flutter to the backend.

### Installation

See [docs](https://docs.dartblaze.com/introduction/getting-started) to install the CLI and get started.

### Usage

Write your cloud functions using the same syntax as in Node:

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

Then, run the generator `dart run build_runner build --delete-conflicting-output` to generate the neccesary code.

Finally, deploy using the CLI: 
```bash
dartblaze deploy -f <function_name>
```

See [docs](https://docs.dartblaze.com/) for more info.