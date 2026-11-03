// Feature: feature_settings · Layer: presentation
// The server's feature flags as last known by the app (backend 0010).
//  * Read on first use (warmed at app start by CockpitApp), whenever the
//    signed-in user changes, when the app resumes, and every
//    [FeatureSettingsController.refreshInterval] while it runs.
//  * A failed read keeps the last known flags. With nothing known yet every
//    server flag reads as off (fail closed).
//  * Nothing is persisted: a cold start begins closed until the first read.
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/config/app_version.dart';
import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/utils/logger.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';
import 'package:cockpit/features/feature_settings/domain/usecases/get_feature_settings.dart';

// The running app's version now lives in core (ADR-012, package_info_plus);
// re-exported here so existing imports / overrides keep working.
export 'package:cockpit/core/config/app_version.dart' show appVersionProvider;

/// [GetFeatureSettings] use case (overridable in tests).
final getFeatureSettingsProvider =
    Provider<GetFeatureSettings>((ref) => getIt<GetFeatureSettings>());

/// Last known server flags by key; `null` until the first successful read.
class FeatureSettingsController extends Notifier<Map<String, FeatureSetting>?> {
  /// How often the flags are re-read while the app runs.
  static const Duration refreshInterval = Duration(minutes: 5);

  Future<void>? _inFlight;

  @override
  Map<String, FeatureSetting>? build() {
    final timer = Timer.periodic(refreshInterval, (_) => unawaited(refresh()));
    final lifecycle = AppLifecycleListener(onResume: () => unawaited(refresh()));
    ref
      ..onDispose(timer.cancel)
      ..onDispose(lifecycle.dispose)
      // Signing in (or switching users) re-reads; flags are global, so the
      // last known values stay meanwhile.
      ..listen<String?>(
        authControllerProvider.select((auth) => auth.value?.id),
        (previous, next) {
          if (next != null && next != previous) unawaited(refresh());
        },
      );
    scheduleMicrotask(() => unawaited(refresh()));
    return null;
  }

  /// Re-reads the flags. Concurrent calls share one read; a failure keeps
  /// the last known flags.
  Future<void> refresh() => _inFlight ??= _load().whenComplete(() => _inFlight = null);

  Future<void> _load() async {
    try {
      final result = await ref.read(getFeatureSettingsProvider)();
      if (!ref.mounted) return;
      result.fold(
        (failure) => AppLogger.warning('Feature settings unavailable: ${failure.message}'),
        (settings) => state = {for (final setting in settings) setting.key: setting},
      );
    } on Object catch (error) {
      AppLogger.warning('Feature settings unavailable: $error');
    }
  }
}

/// The server's flags, as last known.
final featureSettingsControllerProvider =
    NotifierProvider<FeatureSettingsController, Map<String, FeatureSetting>?>(
  FeatureSettingsController.new,
);

/// Whether the server has [key] on for this app version. Off while nothing
/// is known, for an unknown key, and below `min_app_version`.
final serverFeatureProvider = Provider.family<bool, String>((ref, key) {
  final setting = ref.watch(featureSettingsControllerProvider.select((all) => all?[key]));
  return setting != null && setting.isOnFor(ref.watch(appVersionProvider));
});
