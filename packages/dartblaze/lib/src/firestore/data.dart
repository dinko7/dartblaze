import 'package:dartblaze/src/firestore/document_snapshot.dart';
import 'package:dartblaze/src/utils/cloud_event_utils.dart';
import 'package:functions_framework/functions_framework.dart';

import '../internal/google/events/cloud/firestore/v1/data.pb.dart' as proto;

const _firestoreEventCreated = 'google.cloud.firestore.document.v1.created';
const _firestoreEventUpdated = 'google.cloud.firestore.document.v1.updated';
const _firestoreEventDeleted = 'google.cloud.firestore.document.v1.deleted';
const _firestoreEventWritten = 'google.cloud.firestore.document.v1.written';

enum FirestoreEventType {
  v1Created,
  v1Updated,
  v1Deleted,
  v1Written;

  String get type => switch (this) {
        FirestoreEventType.v1Created => _firestoreEventCreated,
        FirestoreEventType.v1Updated => _firestoreEventUpdated,
        FirestoreEventType.v1Deleted => _firestoreEventDeleted,
        FirestoreEventType.v1Written => _firestoreEventWritten,
      };
}

sealed class FirestoreEventData<T> {
  const FirestoreEventData(
      {required this.eventType, required this.snapshotOrChange});

  final FirestoreEventType eventType;
  final T snapshotOrChange;
}

class DocumentCreatedData extends FirestoreEventData<DocumentSnapshot> {
  DocumentCreatedData(
      {required super.eventType, required super.snapshotOrChange});
}

class DocumentUpdatedData extends FirestoreEventData<UpdateDocumentChange> {
  DocumentUpdatedData(
      {required super.eventType, required super.snapshotOrChange});
}

class DocumentDeletedData extends FirestoreEventData<DocumentSnapshot> {
  DocumentDeletedData(
      {required super.eventType, required super.snapshotOrChange});
}

class DocumentWrittenData extends FirestoreEventData<WriteDocumentChange> {
  DocumentWrittenData(
      {required super.eventType, required super.snapshotOrChange});
}

class DocumentChange<T extends DocumentSnapshot?> {
  DocumentChange({required this.before, required this.after});

  final T before;

  final T after;
}

typedef UpdateDocumentChange = DocumentChange<DocumentSnapshot>;

typedef WriteDocumentChange = DocumentChange<DocumentSnapshot?>;

class FirestoreEventDataFactory {
  FirestoreEventDataFactory(this.event);

  final CloudEvent event;

  FirestoreEventData build() {
    final type = event.type;
    return switch (type) {
      _firestoreEventCreated => _onCreated(event),
      _firestoreEventUpdated => _onUpdated(event),
      _firestoreEventDeleted => _onDeleted(event),
      _firestoreEventWritten => _onWritten(event),
      _ => throw ArgumentError.value(
          type,
          'event',
          "Couldn't parse CloudEvent type: $type",
        ),
    };
  }

  DocumentCreatedData _onCreated(CloudEvent event) {
    final documentEventData =
        proto.DocumentEventData.fromBuffer(event.data! as List<int>);
    final path = event.subjectPath;
    final value = documentEventData.value;
    return DocumentCreatedData(
      eventType: FirestoreEventType.v1Created,
      snapshotOrChange: value.toDocumentSnapshot(path),
    );
  }

  DocumentUpdatedData _onUpdated(CloudEvent event) {
    final documentEventData =
        proto.DocumentEventData.fromBuffer(event.data! as List<int>);
    final path = event.subjectPath;
    final value = documentEventData.value;
    final oldValue = documentEventData.oldValue;
    return DocumentUpdatedData(
      eventType: FirestoreEventType.v1Updated,
      snapshotOrChange: UpdateDocumentChange(
        before: oldValue.toDocumentSnapshot(path),
        after: value.toDocumentSnapshot(path),
      ),
    );
  }

  DocumentDeletedData _onDeleted(CloudEvent event) {
    final documentEventData =
        proto.DocumentEventData.fromBuffer(event.data! as List<int>);
    final path = event.subjectPath;
    final oldValue = documentEventData.oldValue;
    return DocumentDeletedData(
      eventType: FirestoreEventType.v1Deleted,
      snapshotOrChange: oldValue.toDocumentSnapshot(path),
    );
  }

  DocumentWrittenData _onWritten(CloudEvent event) {
    final documentEventData =
        proto.DocumentEventData.fromBuffer(event.data! as List<int>);
    final path = event.subjectPath;
    final value = documentEventData.value;
    final hasValue = value.fields.isNotEmpty;
    final oldValue = documentEventData.oldValue;
    final hasOldValue = oldValue.fields.isNotEmpty;
    return DocumentWrittenData(
      eventType: FirestoreEventType.v1Written,
      snapshotOrChange: WriteDocumentChange(
        before: hasOldValue ? oldValue.toDocumentSnapshot(path) : null,
        after: hasValue ? value.toDocumentSnapshot(path) : null,
      ),
    );
  }
}
