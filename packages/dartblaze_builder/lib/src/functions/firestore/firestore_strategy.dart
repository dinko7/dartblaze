import 'package:analyzer/dart/element/element.dart';
import 'package:dartblaze/dartblaze.dart';
import 'package:dartblaze_builder/src/common/function_strategy.dart';
import 'package:dartblaze_builder/src/utils/type_check_utils.dart';
import 'package:source_gen/source_gen.dart';

class FirestoreEventFunctionData extends FunctionData {
  const FirestoreEventFunctionData(
    super.functionName, {
    required ElementAnnotation annotation,
    required this.hasRequestContextParameter,
  }) : _annotation = annotation;

  final ElementAnnotation _annotation;

  final bool hasRequestContextParameter;

  FirestoreEventType get firestoreDocumentEventType {
    final dartType = _annotation.computeConstantValue()!.type!;
    if (dartType.isType(OnDocumentCreated)) {
      return FirestoreEventType.v1Created;
    } else if (dartType.isType(OnDocumentUpdated)) {
      return FirestoreEventType.v1Updated;
    } else if (dartType.isType(OnDocumentDeleted)) {
      return FirestoreEventType.v1Deleted;
    } else if (dartType.isType(OnDocumentWritten)) {
      return FirestoreEventType.v1Written;
    } else {
      throw InvalidGenerationSourceError(
        'Annotation format is not valid.',
        element: _annotation.element,
      );
    }
  }

  String get pathPattern {
    final source = _annotation.toSource();
    final regex = RegExp("'(.*?)'");
    final match = regex.firstMatch(source);
    if (match == null) {
      throw Exception('Annotation format is not valid.');
    }
    return match.group(1)!;
  }

  List<String> get documentIds {
    final regex = RegExp(r'\{(\w+)\}');
    final matches = regex.allMatches(pathPattern);
    return matches.map((match) => match.group(1) ?? '').toList();
  }
}

class FirestoreStrategy extends FunctionStrategy<FirestoreEventFunctionData> {
  const FirestoreStrategy(super.importPrefix);

  @override
  String generate(FirestoreEventFunctionData data) {
    return """
'${data.functionName}' => FunctionTarget.cloudEvent${data.hasRequestContextParameter ? 'WithContext' : ''}(
  (event${data.hasRequestContextParameter ? ', context' : ''}) {
    const pathPattern = '${data.pathPattern}';
    final documentIds = FirestorePathParser(pathPattern).parse(event.subject!);
    final data = FirestoreEventDataFactory(event).build() as ${_dataClass(data.firestoreDocumentEventType)};
    return $importPrefix.${data.functionName}(
      data.snapshotOrChange,
      ${data.hasRequestContextParameter ? 'context,' : ''}
      ${data.documentIds.map((documentId) => "$documentId: documentIds['$documentId']!").join(',')},
    );
  }),
""";
  }

  String _dataClass(FirestoreEventType firestoreDocumentEventType) =>
      switch (firestoreDocumentEventType) {
        FirestoreEventType.v1Created => 'DocumentCreatedData',
        FirestoreEventType.v1Updated => 'DocumentUpdatedData',
        FirestoreEventType.v1Deleted => 'DocumentDeletedData',
        FirestoreEventType.v1Written => 'DocumentWrittenData',
      };
}
