// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_trigger_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentTriggerDto _$AgentTriggerDtoFromJson(Map<String, dynamic> json) =>
    _AgentTriggerDto(
      agentId: json['agent_id'] as String,
      triggerUrl: json['trigger_url'] as String,
      secretHint: json['secret_hint'] as String,
      enabled: json['enabled'] as bool? ?? true,
      minIntervalSecs: (json['min_interval_secs'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$AgentTriggerDtoToJson(_AgentTriggerDto instance) =>
    <String, dynamic>{
      'agent_id': instance.agentId,
      'trigger_url': instance.triggerUrl,
      'secret_hint': instance.secretHint,
      'enabled': instance.enabled,
      'min_interval_secs': instance.minIntervalSecs,
    };

_TriggerRunDto _$TriggerRunDtoFromJson(Map<String, dynamic> json) =>
    _TriggerRunDto(
      runId: json['run_id'] as String,
      delivered: json['delivered'] as bool,
      detail: json['detail'] as String? ?? '',
    );

Map<String, dynamic> _$TriggerRunDtoToJson(_TriggerRunDto instance) =>
    <String, dynamic>{
      'run_id': instance.runId,
      'delivered': instance.delivered,
      'detail': instance.detail,
    };

_TriggerCredentialsDto _$TriggerCredentialsDtoFromJson(
  Map<String, dynamic> json,
) => _TriggerCredentialsDto(
  trigger: AgentTriggerDto.fromJson(json['trigger'] as Map<String, dynamic>),
  triggerSecret: json['trigger_secret'] as String,
);

Map<String, dynamic> _$TriggerCredentialsDtoToJson(
  _TriggerCredentialsDto instance,
) => <String, dynamic>{
  'trigger': instance.trigger.toJson(),
  'trigger_secret': instance.triggerSecret,
};
