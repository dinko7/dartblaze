// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectConfig _$ProjectConfigFromJson(Map<String, dynamic> json) =>
    ProjectConfig(
      projectId: json['projectId'] as String,
      eventArcServiceAccount: json['eventArcServiceAccount'] as String,
    );

Map<String, dynamic> _$ProjectConfigToJson(ProjectConfig instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'eventArcServiceAccount': instance.eventArcServiceAccount,
    };
