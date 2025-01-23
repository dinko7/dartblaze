import 'package:meta/meta_meta.dart';

sealed class FirestoreEvent {
  const FirestoreEvent();
}

@Target({TargetKind.function})
class OnDocumentCreated extends FirestoreEvent {
  final String document;

  const OnDocumentCreated(this.document);
}

@Target({TargetKind.function})
class OnDocumentUpdated extends FirestoreEvent {
  final String document;

  const OnDocumentUpdated(this.document);
}

@Target({TargetKind.function})
class OnDocumentDeleted extends FirestoreEvent {
  final String document;

  const OnDocumentDeleted(this.document);
}

@Target({TargetKind.function})
class OnDocumentWritten extends FirestoreEvent {
  final String document;

  const OnDocumentWritten(this.document);
}
