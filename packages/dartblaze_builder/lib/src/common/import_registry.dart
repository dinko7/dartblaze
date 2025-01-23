import 'package:collection/collection.dart';

const _defaultImports = [
  "'package:dartblaze/blaze.dart'",
  "'package:functions_framework/serve.dart'",
];

class ImportRegistry {
  static final ImportRegistry instance = ImportRegistry._();

  ImportRegistry._() {
    addImports(_defaultImports);
  }

  final Set<String> _imports = {};

  void addImport(String import) {
    if (!import.startsWith('dart:') && !import.contains('package:shelf/')) {
      _imports.add(import);
    }
  }

  void addImports(Iterable<String> imports) {
    imports.forEach(addImport);
  }

  List<String> get imports => _imports.sorted((a, b) {
        // dart: imports first, then package: imports, then relative imports
        if (a.startsWith('dart:') && !b.startsWith('dart:')) return -1;
        if (!a.startsWith('dart:') && b.startsWith('dart:')) return 1;
        if (a.startsWith('package:') && !b.startsWith('package:')) return -1;
        if (!a.startsWith('package:') && b.startsWith('package:')) return 1;
        return a.compareTo(b);
      });
}

extension ImportUri on Uri {
  String get import => "'$this'";
}
