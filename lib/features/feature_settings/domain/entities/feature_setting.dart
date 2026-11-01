// Feature: feature_settings · Layer: domain
// A server-side feature flag (backend `feature_setting`, migration 0010): the
// database decides whether a feature is on, so it can be switched without a
// release. Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_setting.freezed.dart';

/// Server feature keys (rows seeded by backend migration 0010).
abstract final class FeatureKeys {
  /// Agent Triggers (start an agent from the app).
  static const String agentTriggers = 'agent_triggers';

  /// Agent services gateway.
  static const String agentServices = 'agent_services';
}

/// One feature flag as the server reports it.
@freezed
abstract class FeatureSetting with _$FeatureSetting {
  /// Creates a [FeatureSetting].
  const factory FeatureSetting({
    required String key,
    required bool enabled,

    /// Lowest app version (`x.y.z`) allowed to show the feature; `null` = any.
    String? minAppVersion,
  }) = _FeatureSetting;

  const FeatureSetting._();

  /// Whether the feature is on for an app at [appVersion]: enabled, and
  /// [appVersion] ≥ [minAppVersion]. An unparseable version fails closed.
  bool isOnFor(String appVersion) {
    if (!enabled) return false;
    final min = minAppVersion;
    if (min == null) return true;
    final have = _parse(appVersion);
    final need = _parse(min);
    if (have == null || need == null) return false;
    for (var i = 0; i < 3; i++) {
      if (have[i] != need[i]) return have[i] > need[i];
    }
    return true;
  }

  /// `x.y.z` (an optional `+build` / `-pre` suffix is ignored) → [x, y, z].
  static List<int>? _parse(String version) {
    final match = RegExp(r'^(\d+)\.(\d+)\.(\d+)(?:[+-].*)?$').firstMatch(version.trim());
    if (match == null) return null;
    return [for (var i = 1; i <= 3; i++) int.parse(match.group(i)!)];
  }
}
