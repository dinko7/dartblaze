// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunctionsConfig _$FunctionsConfigFromJson(Map<String, dynamic> json) =>
    FunctionsConfig(
      functions: (json['functions'] as List<dynamic>)
          .map((e) => FunctionConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FunctionsConfigToJson(FunctionsConfig instance) =>
    <String, dynamic>{
      'functions': instance.functions,
    };

FunctionConfig _$FunctionConfigFromJson(Map<String, dynamic> json) =>
    FunctionConfig(
      name: json['name'] as String,
      signatureType: $enumDecode(_$SignatureTypeEnumMap, json['signatureType']),
      trigger: json['trigger'] == null
          ? null
          : TriggerConfig.fromJson(json['trigger'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FunctionConfigToJson(FunctionConfig instance) =>
    <String, dynamic>{
      'name': instance.name,
      'signatureType': _$SignatureTypeEnumMap[instance.signatureType]!,
      if (instance.trigger case final value?) 'trigger': value,
    };

const _$SignatureTypeEnumMap = {
  SignatureType.http: 'http',
  SignatureType.cloudEvent: 'cloudevent',
};

TriggerConfig _$TriggerConfigFromJson(Map<String, dynamic> json) =>
    TriggerConfig(
      type: json['type'] as String,
      documentPath: json['documentPath'] as String,
    );

Map<String, dynamic> _$TriggerConfigToJson(TriggerConfig instance) =>
    <String, dynamic>{
      'type': instance.type,
      'documentPath': instance.documentPath,
    };
