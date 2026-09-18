// Feature: settings · Layer: presentation
// Facade over the app-wide theme, locale and auth controllers so settings
// widgets depend on one command surface (and analytics can hook in here).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/locale_controller.dart';
import 'package:cockpit/core/theme/theme_controller.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';

/// Commands for the settings screen.
class SettingsController {
  /// Creates the controller.
  const SettingsController(this._ref);

  final Ref _ref;

  /// Changes the theme mode.
  Future<void> setThemeMode(ThemeMode mode) {
    // TODO(analytics): capture `theme_changed` with {mode}.
    return _ref.read(themeControllerProvider.notifier).setThemeMode(mode);
  }

  /// Changes the locale; `null` follows the device.
  Future<void> setLocale(Locale? locale) {
    // TODO(analytics): capture `language_changed` with {locale}.
    return _ref.read(localeControllerProvider.notifier).setLocale(locale);
  }

  /// Signs the current user out.
  Future<void> signOut() =>
      _ref.read(authControllerProvider.notifier).signOut();
}

/// Settings commands.
final settingsControllerProvider =
    Provider<SettingsController>(SettingsController.new);
