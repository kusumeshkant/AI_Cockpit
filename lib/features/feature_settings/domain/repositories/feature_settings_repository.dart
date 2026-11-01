// Feature: feature_settings · Layer: domain
// Contract for reading the server's feature flags. Implementations never
// throw; a failure is returned as a Failure.
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';

/// Feature flag access.
abstract interface class FeatureSettingsRepository {
  /// Every feature flag the server knows.
  Result<List<FeatureSetting>> fetchFeatureSettings();
}
