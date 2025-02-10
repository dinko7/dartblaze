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
class FunctionsConfig {
  final List<FunctionConfig> functions;

  FunctionsConfig({
    required this.functions,
  });

  factory FunctionsConfig.fromJson(Map<String, dynamic> json) =>
      _$FunctionsConfigFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionsConfigToJson(this);
}

@JsonSerializable(includeIfNull: false)
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
  final String documentPath;

  TriggerConfig({
    required this.type,
    required this.documentPath,
  });

  factory TriggerConfig.fromJson(Map<String, dynamic> json) =>
      _$TriggerConfigFromJson(json);
  Map<String, dynamic> toJson() => _$TriggerConfigToJson(this);
}
