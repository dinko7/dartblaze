import 'package:json_annotation/json_annotation.dart';

part 'project_config.g.dart';

@JsonSerializable()
class ProjectConfig {
  final String projectId;
  final String eventArcServiceAccount;

  ProjectConfig({
    required this.projectId,
    required this.eventArcServiceAccount,
  });

  factory ProjectConfig.fromJson(Map<String, dynamic> json) =>
      _$ProjectConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectConfigToJson(this);
}
