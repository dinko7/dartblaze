import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_builder/src/common/import_registry.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;

import 'firestore/firestore_strategy.dart';
import 'http/http_strategy.dart';

String useFunctionStrategy(String importPrefix, FunctionData data) {
  switch (data.runtimeType) {
    case HttpFunctionData:
      return HttpStrategy(importPrefix).generate(data as HttpFunctionData);
    case FirestoreEventFunctionData:
      return FirestoreStrategy(importPrefix)
          .generate(data as FirestoreEventFunctionData);
    default:
      log.warning('Unsupported function type: ${data.runtimeType}');
      return '';
  }
}

Future<void> generateServer(
  Map<String, (int, FunctionData)> entries,
  BuildStep buildStep,
  List<String> functionFiles,
) async {
  final cases = entries.entries.toList().map((entry) {
    final value = entry.value;
    final index = value.$1;
    final functionData = value.$2;
    return useFunctionStrategy('f$index', functionData);
  });

  final packageName = buildStep.inputId.package;
  final importDirectives = [
    ...ImportRegistry.instance.imports,
    ...functionFiles.asMap().entries.map((entry) {
      final filePath = entry.value;
      final functionName = path.basenameWithoutExtension(filePath);
      return "'package:$packageName/functions/$functionName.dart' as f${entry.key}";
    }),
  ]..sort();

  var output = '''
    // GENERATED CODE - DO NOT MODIFY BY HAND
    
    ${importDirectives.map((e) => 'import $e;').join('\n')}
    
    Future<void> main(List<String> args) async {
      initializeAdminApp();
      await serve(args, _nameToFunctionTarget);
    }
    
    FunctionTarget? _nameToFunctionTarget(String name) =>
      switch (name) {
    ${cases.join('\n')}
      _ => null
      };
    ''';

  try {
    output = DartFormatter().format(output);
  } on FormatterException catch (e, stack) {
    log.warning('Could not format output.', e, stack);
  }

  await buildStep.writeAsString(
    AssetId(buildStep.inputId.package, 'bin/server.dart'),
    output,
  );
}
