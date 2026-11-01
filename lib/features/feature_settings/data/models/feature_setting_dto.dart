// Feature: feature_settings · Layer: data
// Wire model for a `feature_setting` row (key, enabled, min_app_version).
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';

part 'feature_setting_dto.freezed.dart';
part 'feature_setting_dto.g.dart';

/// JSON representation of a `feature_setting` row.
@freezed
abstract class FeatureSettingDto with _$FeatureSettingDto {
  /// Creates a DTO.
  const factory FeatureSettingDto({
    required String key,
    @Default(false) bool enabled,
    String? minAppVersion,
  }) = _FeatureSettingDto;

  const FeatureSettingDto._();

  /// Parses JSON.
  factory FeatureSettingDto.fromJson(Map<String, dynamic> json) =>
      _$FeatureSettingDtoFromJson(json);

  /// Maps to the domain entity.
  FeatureSetting toEntity() =>
      FeatureSetting(key: key, enabled: enabled, minAppVersion: minAppVersion);
}
