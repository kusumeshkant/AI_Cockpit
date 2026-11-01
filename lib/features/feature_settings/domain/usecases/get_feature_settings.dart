// Feature: feature_settings · Layer: domain
// Use case: read the server's feature flags.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';
import 'package:cockpit/features/feature_settings/domain/repositories/feature_settings_repository.dart';

/// Reads every feature flag.
@lazySingleton
class GetFeatureSettings {
  /// Creates the use case.
  const GetFeatureSettings(this._repository);

  final FeatureSettingsRepository _repository;

  /// Returns the server's flags.
  Result<List<FeatureSetting>> call() => _repository.fetchFeatureSettings();
}
