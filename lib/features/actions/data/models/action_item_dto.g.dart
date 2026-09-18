// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionItemDto _$ActionItemDtoFromJson(Map<String, dynamic> json) =>
    _ActionItemDto(
      id: json['id'] as String,
      agentId: json['agent_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      agentName: json['agent_name'] as String?,
      agentPlatform: json['agent_platform'] as String?,
      summary: json['summary'] as String?,
      editableFields:
          (json['editable_fields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      decision: json['decision'] as String?,
      decidedAt: json['decided_at'] == null
          ? null
          : DateTime.parse(json['decided_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$ActionItemDtoToJson(_ActionItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agent_id': instance.agentId,
      'type': instance.type,
      'title': instance.title,
      'payload': instance.payload,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'agent_name': instance.agentName,
      'agent_platform': instance.agentPlatform,
      'summary': instance.summary,
      'editable_fields': instance.editableFields,
      'decision': instance.decision,
      'decided_at': instance.decidedAt?.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
    };
