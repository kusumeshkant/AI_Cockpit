// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentDto _$AgentDtoFromJson(Map<String, dynamic> json) => _AgentDto(
  id: json['id'] as String,
  name: json['name'] as String,
  callbackUrl: json['callback_url'] as String,
  platform: json['platform'] as String? ?? 'custom',
  status: json['status'] as String? ?? 'active',
  secretHint: json['secret_hint'] as String?,
  lastActionAt: json['last_action_at'] == null
      ? null
      : DateTime.parse(json['last_action_at'] as String),
);

Map<String, dynamic> _$AgentDtoToJson(_AgentDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'callback_url': instance.callbackUrl,
  'platform': instance.platform,
  'status': instance.status,
  'secret_hint': instance.secretHint,
  'last_action_at': instance.lastActionAt?.toIso8601String(),
};

_AgentCredentialsDto _$AgentCredentialsDtoFromJson(Map<String, dynamic> json) =>
    _AgentCredentialsDto(
      agent: AgentDto.fromJson(json['agent'] as Map<String, dynamic>),
      inboundUrl: json['inbound_url'] as String,
      inboundSecret: json['inbound_secret'] as String,
    );

Map<String, dynamic> _$AgentCredentialsDtoToJson(
  _AgentCredentialsDto instance,
) => <String, dynamic>{
  'agent': instance.agent.toJson(),
  'inbound_url': instance.inboundUrl,
  'inbound_secret': instance.inboundSecret,
};
