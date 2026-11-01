// Feature: feature_settings · Layer: data
// Reads `feature_setting` rows (backend migration 0010). Signed-in users may
// select key / enabled / min_app_version only; anon reads nothing, so a
// signed-out read fails (and the app keeps its last known flags).
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/feature_settings/data/models/feature_setting_dto.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';

/// Source of the server's feature flags.
abstract interface class FeatureSettingsDataSource {
  /// Every row; throws on failure.
  Future<List<FeatureSettingDto>> fetchAll();
}

/// Supabase implementation.
@LazySingleton(as: FeatureSettingsDataSource, env: [AppEnvironments.live])
class FeatureSettingsRemoteDataSource implements FeatureSettingsDataSource {
  /// Creates the datasource.
  const FeatureSettingsRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<FeatureSettingDto>> fetchAll() async {
    final rows = await _client.from(DbTables.featureSetting).select('key, enabled, min_app_version');
    return [for (final row in rows) FeatureSettingDto.fromJson(row)];
  }
}

/// Demo implementation (no backend). Agent Triggers is on, so a demo build
/// with `--dart-define=AGENT_TRIGGERS=true` behaves as before; agent services
/// stay off.
@LazySingleton(as: FeatureSettingsDataSource, env: [AppEnvironments.demo])
class FeatureSettingsDemoDataSource implements FeatureSettingsDataSource {
  /// Creates the datasource.
  const FeatureSettingsDemoDataSource();

  @override
  Future<List<FeatureSettingDto>> fetchAll() async => const [
        FeatureSettingDto(key: FeatureKeys.agentTriggers, enabled: true),
        FeatureSettingDto(key: FeatureKeys.agentServices, enabled: false),
      ];
}
