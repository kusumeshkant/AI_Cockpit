// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditEntryDto _$AuditEntryDtoFromJson(Map<String, dynamic> json) =>
    _AuditEntryDto(
      id: json['id'] as String,
      event: json['event'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      actionId: json['action_id'] as String?,
      agentId: json['agent_id'] as String?,
      actionTitle: json['action_title'] as String?,
      agentName: json['agent_name'] as String?,
      agentPlatform: json['agent_platform'] as String?,
      actorEmail: json['actor_email'] as String?,
      decision: json['decision'] as String?,
      reason: json['reason'] as String?,
      originalPayload: json['original_payload'] as Map<String, dynamic>?,
      editedPayload: json['edited_payload'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AuditEntryDtoToJson(_AuditEntryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event': instance.event,
      'created_at': instance.createdAt.toIso8601String(),
      'action_id': instance.actionId,
      'agent_id': instance.agentId,
      'action_title': instance.actionTitle,
      'agent_name': instance.agentName,
      'agent_platform': instance.agentPlatform,
      'actor_email': instance.actorEmail,
      'decision': instance.decision,
      'reason': instance.reason,
      'original_payload': instance.originalPayload,
      'edited_payload': instance.editedPayload,
    };
