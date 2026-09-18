// Persisted app locale. `null` means "follow the device language".
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/di/providers.dart';
import 'package:cockpit/l10n/app_localizations.dart';

/// Holds and persists the user's chosen [Locale].
class LocaleController extends Notifier<Locale?> {
  /// SharedPreferences key.
  static const String storageKey = 'locale';

  @override
  Locale? build() {
    final code = ref.watch(sharedPreferencesProvider).getString(storageKey);
    if (code == null) return null;
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == code) return locale;
    }
    return null;
  }

  /// Applies and persists [locale]; `null` follows the system language.
  Future<void> setLocale(Locale? locale) async {
    if (locale == state) return;
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(storageKey);
    } else {
      await prefs.setString(storageKey, locale.languageCode);
    }
  }
}

/// The user-selected locale, or `null` for system.
final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);
