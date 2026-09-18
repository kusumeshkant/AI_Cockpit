// Persisted theme mode (light / dark / system).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/di/providers.dart';

/// Holds and persists the user's [ThemeMode].
class ThemeController extends Notifier<ThemeMode> {
  /// SharedPreferences key.
  static const String storageKey = 'theme_mode';

  @override
  ThemeMode build() {
    final stored = ref.watch(sharedPreferencesProvider).getString(storageKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  /// Applies and persists [mode].
  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state) return;
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(storageKey, mode.name);
  }
}

/// The active [ThemeMode].
final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
