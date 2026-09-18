// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) => _AuthUserDto(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String?,
  workspaceId: json['workspace_id'] as String?,
  plan: json['plan'] as String? ?? 'solo',
);

Map<String, dynamic> _$AuthUserDtoToJson(_AuthUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
      'workspace_id': instance.workspaceId,
      'plan': instance.plan,
    };
