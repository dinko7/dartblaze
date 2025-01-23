import 'package:json_annotation/json_annotation.dart';

part 'function_config.g.dart';

enum SignatureType {
  @JsonValue('http')
  http,
  @JsonValue('cloudevent')
  cloudEvent;

  String get value => _$SignatureTypeEnumMap[this]!;
}

@JsonSerializable()
class DeploymentConfig {
  final String region;
  final String maxInstances;
  final String memoryLimit;

  DeploymentConfig({
    required this.region,
    required this.maxInstances,
    required this.memoryLimit,
  });

  factory DeploymentConfig.fromJson(Map<String, dynamic> json) =>
      _$DeploymentConfigFromJson(json);
  Map<String, dynamic> toJson() => _$DeploymentConfigToJson(this);
}

@JsonSerializable()
class FunctionsConfig {
  final DeploymentConfig defaults;
  final List<FunctionConfig> functions;

  FunctionsConfig({
    required this.defaults,
    required this.functions,
  });

  factory FunctionsConfig.fromJson(Map<String, dynamic> json) =>
      _$FunctionsConfigFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionsConfigToJson(this);
}

@JsonSerializable()
class FunctionConfig {
  final String name;
  final SignatureType signatureType;
  final TriggerConfig? trigger;

  FunctionConfig({
    required this.name,
    required this.signatureType,
    this.trigger,
  });

  factory FunctionConfig.fromJson(Map<String, dynamic> json) =>
      _$FunctionConfigFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionConfigToJson(this);
}

@JsonSerializable()
class TriggerConfig {
  final String type;
  final String database;
  final String namespace;
  final String documentPath;
  final String eventDataContentType;

  TriggerConfig({
    required this.type,
    required this.database,
    required this.namespace,
    required this.documentPath,
    required this.eventDataContentType,
  });

  factory TriggerConfig.fromJson(Map<String, dynamic> json) =>
      _$TriggerConfigFromJson(json);
  Map<String, dynamic> toJson() => _$TriggerConfigToJson(this);
}
