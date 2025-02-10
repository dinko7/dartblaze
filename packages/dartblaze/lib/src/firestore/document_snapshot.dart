import 'package:dartblaze/dartblaze.dart';
import 'package:dartblaze/src/utils/proto_utils.dart';
import 'package:dart_firebase_admin/firestore.dart';

import '../internal/google/events/cloud/firestore/v1/data.pb.dart' as proto;

class DocumentSnapshot {
  DocumentSnapshot._({
    required this.ref,
    required this.createTime,
    required this.updateTime,
    required proto.Document document,
  }) : _document = document;

  final DocumentReference<Map<String, Object?>> ref;

  final Timestamp? createTime;

  final Timestamp? updateTime;

  final proto.Document _document;

  Map<String, Object?>? data() => {
        for (final field in _document.fields.entries)
          field.key: decodeValue(field.value),
      };
}

extension DocumentSnapshotExtension on proto.Document {
  DocumentSnapshot toDocumentSnapshot(String path) {
    return DocumentSnapshot._(
      ref: firestore.doc(path),
      createTime: Timestamp.fromDate(createTime.toDateTime()),
      updateTime: Timestamp.fromDate(updateTime.toDateTime()),
      document: this,
    );
  }
}
