// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_setting_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeatureSettingDto _$FeatureSettingDtoFromJson(Map<String, dynamic> json) =>
    _FeatureSettingDto(
      key: json['key'] as String,
      enabled: json['enabled'] as bool? ?? false,
      minAppVersion: json['min_app_version'] as String?,
    );

Map<String, dynamic> _$FeatureSettingDtoToJson(_FeatureSettingDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'enabled': instance.enabled,
      'min_app_version': instance.minAppVersion,
    };
