// Feature: feature_settings · Layer: data
// FeatureSettingsRepository implementation. Errors map to Failures via `guard`.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/feature_settings/data/datasources/feature_settings_ds.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';
import 'package:cockpit/features/feature_settings/domain/repositories/feature_settings_repository.dart';

/// Default [FeatureSettingsRepository].
@LazySingleton(as: FeatureSettingsRepository)
class FeatureSettingsRepositoryImpl implements FeatureSettingsRepository {
  /// Creates the repository.
  const FeatureSettingsRepositoryImpl(this._source);

  final FeatureSettingsDataSource _source;

  @override
  Result<List<FeatureSetting>> fetchFeatureSettings() => guard(
        () async => [for (final dto in await _source.fetchAll()) dto.toEntity()],
      );
}
