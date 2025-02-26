# Dartblaze

Dartblaze allows you to write Firebase Cloud Functions in pure Dart, bringing type safety, language, ecosystem, and packages you already know and love from Flutter to the backend.

> [!WARNING]
> Dartblaze is not production ready yet. Please use this with caution and don't deploy on production environments.

## Packages

- [dartblaze](https://pub.dev/packages/dartblaze) - Core parts fo the framework
- [dartblaze_builder](https://pub.dev/packages/dartblaze_builder) - Code generator for the framework
- [dartblaze_shared](https://pub.dev/packages/dartblaze_shared) - Shared parts of the framework


## Installation

See [docs](https://docs.dartblaze.com/introduction/getting-started) to install the CLI and get started.

## Usage

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

Then, run the generator `dart run build_runner build --delete-conflicting-output` to generate the necessary code.

Finally, deploy using the CLI: 
```bash
dartblaze deploy <function_name> --region=<region>
```

See [docs](https://docs.dartblaze.com/) for more info.
