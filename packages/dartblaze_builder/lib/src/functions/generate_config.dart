import 'dart:convert';

import 'package:dartblaze_builder/src/common/function_config_builder.dart';
import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_builder/src/functions/firestore/firestore_config_builder.dart';
import 'package:dartblaze_builder/src/functions/http/http_config_builder.dart';
import 'package:dartblaze_shared/config/function_config.dart';
import 'package:build/build.dart';

import 'firestore/firestore_strategy.dart';
import 'http/http_strategy.dart';

class FunctionsConfigGenerator {
  final Map<Type, FunctionConfigBuilder> _builders;

  FunctionsConfigGenerator()
      : _builders = {
          HttpFunctionData: HttpFunctionConfigBuilder(),
          FirestoreEventFunctionData: FirestoreEventConfigBuilder(),
        };

  String generate(List<FunctionData> functions) {
    final configs = functions.map((entry) {
      final builder = _builders[entry.runtimeType];
      if (builder == null) {
        throw StateError('No builder found for ${entry.runtimeType}');
      }
      return builder.buildConfig(entry);
    }).toList();

    final config = FunctionsConfig(functions: configs);

    return JsonEncoder.withIndent('  ').convert(config.toJson());
  }
}

Future<void> generateConfig(
  Map<String, (int, FunctionData)> entries,
  BuildStep buildStep,
) async {
  final generator = FunctionsConfigGenerator();

  final configJson =
      generator.generate(entries.values.map((e) => e.$2).toList());
  await buildStep.writeAsString(
    AssetId(buildStep.inputId.package, 'functions.json'),
    configJson,
  );
}
