import 'package:dartblaze/src/firebase.dart';
import 'package:dart_firebase_admin/firestore.dart';

import '../internal/google/events/cloud/firestore/v1/data.pb.dart' as proto;

Object? decodeValue(proto.Value value) {
  if (value.hasStringValue()) {
    return value.stringValue;
  } else if (value.hasBooleanValue()) {
    return value.booleanValue;
  } else if (value.hasIntegerValue()) {
    return value.integerValue.toInt();
  } else if (value.hasDoubleValue()) {
    return value.doubleValue;
  } else if (value.hasTimestampValue()) {
    return value.timestampValue;
  } else if (value.hasReferenceValue()) {
    return firestore.doc(
      RegExp(r'^projects\/([^/]*)\/databases\/([^/]*)(?:\/documents\/)?([\s\S]*)$')
          .firstMatch(value.referenceValue)!
          .group(3)!,
    );
  } else if (value.hasArrayValue()) {
    return [
      for (final value in value.arrayValue.values) decodeValue(value),
    ];
  } else if (value.hasMapValue()) {
    final fields = value.mapValue.fields;
    return <String, Object?>{
      for (final entry in fields.entries) entry.key: decodeValue(entry.value),
    };
  } else if (value.hasGeoPointValue()) {
    return GeoPoint(
      latitude: value.geoPointValue.latitude,
      longitude: value.geoPointValue.longitude,
    );
  } else if (value.hasNullValue()) {
    return null;
  }

  throw ArgumentError.value(
    value,
    'value',
    'Cannot decode type from Firestore Value: ${value.runtimeType}',
  );
}
