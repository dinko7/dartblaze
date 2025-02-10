//
//  Generated code. Do not modify.
//  source: google/events/cloudevent.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Description of an extension attribute.
class ExtensionAttribute extends $pb.GeneratedMessage {
  factory ExtensionAttribute({
    $core.String? name,
    $core.String? description,
    $core.String? camelCaseName,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (camelCaseName != null) {
      $result.camelCaseName = camelCaseName;
    }
    return $result;
  }
  ExtensionAttribute._() : super();
  factory ExtensionAttribute.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ExtensionAttribute.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionAttribute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.events'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'camelCaseName')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ExtensionAttribute clone() => ExtensionAttribute()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ExtensionAttribute copyWith(void Function(ExtensionAttribute) updates) =>
      super.copyWith((message) => updates(message as ExtensionAttribute))
          as ExtensionAttribute;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionAttribute create() => ExtensionAttribute._();
  ExtensionAttribute createEmptyInstance() => create();
  static $pb.PbList<ExtensionAttribute> createRepeated() =>
      $pb.PbList<ExtensionAttribute>();
  @$core.pragma('dart2js:noInline')
  static ExtensionAttribute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionAttribute>(create);
  static ExtensionAttribute? _defaultInstance;

  /// Name of the CloudEvents attribute, e.g. "topic".
  /// This must be all lower-case, to satisfy CloudEvent requirements.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  /// Description of the attribute.
  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => clearField(2);

  /// The name of the CloudEvents attribute in lower Camel case, e.g. "firebaseDatabaseHost".
  /// This only needs to be populated if the name would otherwise be mis-represented.
  @$pb.TagNumber(3)
  $core.String get camelCaseName => $_getSZ(2);
  @$pb.TagNumber(3)
  set camelCaseName($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCamelCaseName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCamelCaseName() => clearField(3);
}

class Cloudevent {
  static final cloudEventType = $pb.Extension<$core.String>(
      _omitMessageNames ? '' : 'google.protobuf.MessageOptions',
      _omitFieldNames ? '' : 'cloudEventType',
      11716486,
      $pb.PbFieldType.OS);
  static final cloudEventProduct = $pb.Extension<$core.String>(
      _omitMessageNames ? '' : 'google.protobuf.FileOptions',
      _omitFieldNames ? '' : 'cloudEventProduct',
      11716487,
      $pb.PbFieldType.OS);
  static final cloudEventExtensionAttribute =
      $pb.Extension<ExtensionAttribute>.repeated(
          _omitMessageNames ? '' : 'google.protobuf.FileOptions',
          _omitFieldNames ? '' : 'cloudEventExtensionAttribute',
          11716488,
          $pb.PbFieldType.PM,
          check: $pb.getCheckFunction($pb.PbFieldType.PM),
          subBuilder: ExtensionAttribute.create);
  static final cloudEventExtensionName = $pb.Extension<$core.String>.repeated(
      _omitMessageNames ? '' : 'google.protobuf.MessageOptions',
      _omitFieldNames ? '' : 'cloudEventExtensionName',
      11716489,
      $pb.PbFieldType.PS,
      check: $pb.getCheckFunction($pb.PbFieldType.PS));
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(cloudEventType);
    registry.add(cloudEventProduct);
    registry.add(cloudEventExtensionAttribute);
    registry.add(cloudEventExtensionName);
  }
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
