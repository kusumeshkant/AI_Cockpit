import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cockpit/core/di/providers.dart';
import 'package:cockpit/core/localization/locale_controller.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/theme/localized_typography.dart';
import 'package:cockpit/core/theme/theme_controller.dart';
import 'package:cockpit/l10n/app_localizations.dart';

/// Phone width used by the design mockups.
const Size phoneSize = Size(390, 844);

/// Smallest supported phone width.
const Size narrowPhoneSize = Size(320, 640);

/// Tablet landscape size used by the tablet mockups.
const Size tabletSize = Size(1024, 768);

/// Pumps [child] inside ProviderScope + MaterialApp wired to the real theme
/// and locale controllers, at a logical [size].
///
/// Returns the SharedPreferences instance so tests can assert persistence.
Future<SharedPreferences> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  Size size = phoneSize,
  ThemeMode themeMode = ThemeMode.light,
  Locale locale = const Locale('en'),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(<String, Object>{
    ThemeController.storageKey: themeMode.name,
    LocaleController.storageKey: locale.languageCode,
  });
  final prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        ...overrides,
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.buildLight(),
          darkTheme: AppTheme.buildDark(),
          themeMode: ref.watch(themeControllerProvider),
          locale: ref.watch(localeControllerProvider) ?? locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // Same script-aware label styles as the app (CockpitApp.builder).
          builder: (context, app) => LocalizedTypography(child: app!),
          home: child,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return prefs;
}
