import 'package:analyzer/dart/element/element.dart';
import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_builder/src/functions/generate_config.dart';
import 'package:dartblaze_builder/src/functions/generate_server.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

import 'src/utils/parser.dart';

Builder dartblazeBuilder(BuilderOptions options) => _DartblazeBuilder();

class _DartblazeBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': ['../bin/server.dart', '../functions.json'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final entries = <String, (int, FunctionData)>{};
    final functionsGlob = Glob('lib/functions/**.dart');
    final functionFiles = <String>[];

    await for (final input in buildStep.findAssets(functionsGlob)) {
      functionFiles.add(input.path);
      final libraryElement = await buildStep.resolver.libraryFor(input);
      final annotatedElements =
          extractAnnotatedElementFromLibrary(libraryElement);

      for (final annotatedElement in annotatedElements) {
        final element = annotatedElement.element;
        if (element is! FunctionElement || element.isPrivate) {
          throw InvalidGenerationSourceError(
            'Only top-level, public functions are supported.',
            element: element,
          );
        }

        final targetName = element.name;
        if (entries.containsKey(targetName)) {
          throw InvalidGenerationSourceError(
            'A function has already been annotated with target "$targetName".',
            element: element,
          );
        }

        entries[targetName] = (
          functionFiles.length - 1,
          FunctionData.fromFunctionElement(element)
        );
      }
    }

    await generateServer(entries, buildStep, functionFiles);
    await generateConfig(entries, buildStep);
  }
}
