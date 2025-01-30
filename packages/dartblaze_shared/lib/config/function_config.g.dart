// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeploymentConfig _$DeploymentConfigFromJson(Map<String, dynamic> json) =>
    DeploymentConfig(
      region: json['region'] as String,
      maxInstances: json['maxInstances'] as String,
      memoryLimit: json['memoryLimit'] as String,
    );

Map<String, dynamic> _$DeploymentConfigToJson(DeploymentConfig instance) =>
    <String, dynamic>{
      'region': instance.region,
      'maxInstances': instance.maxInstances,
      'memoryLimit': instance.memoryLimit,
    };

FunctionsConfig _$FunctionsConfigFromJson(Map<String, dynamic> json) =>
    FunctionsConfig(
      defaults:
          DeploymentConfig.fromJson(json['defaults'] as Map<String, dynamic>),
      functions: (json['functions'] as List<dynamic>)
          .map((e) => FunctionConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FunctionsConfigToJson(FunctionsConfig instance) =>
    <String, dynamic>{
      'defaults': instance.defaults,
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
      'trigger': instance.trigger,
    };

const _$SignatureTypeEnumMap = {
  SignatureType.http: 'http',
  SignatureType.cloudEvent: 'cloudevent',
};

TriggerConfig _$TriggerConfigFromJson(Map<String, dynamic> json) =>
    TriggerConfig(
      type: json['type'] as String,
      database: json['database'] as String,
      namespace: json['namespace'] as String,
      documentPath: json['documentPath'] as String,
      eventDataContentType: json['eventDataContentType'] as String,
    );

Map<String, dynamic> _$TriggerConfigToJson(TriggerConfig instance) =>
    <String, dynamic>{
      'type': instance.type,
      'database': instance.database,
      'namespace': instance.namespace,
      'documentPath': instance.documentPath,
      'eventDataContentType': instance.eventDataContentType,
    };
