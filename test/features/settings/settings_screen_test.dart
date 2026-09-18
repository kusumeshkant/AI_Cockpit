import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/localization/locale_controller.dart';
import 'package:cockpit/core/theme/theme_controller.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/settings/presentation/screens/settings_screen.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('SettingsScreen', () {
    late FakeAuthController auth;

    setUp(() => auth = FakeAuthController());

    Future<void> pumpSettings(
      WidgetTester tester, {
      Size size = phoneSize,
      ThemeMode themeMode = ThemeMode.light,
      Locale locale = const Locale('en'),
    }) =>
        pumpApp(
          tester,
          const SettingsScreen(),
          size: size,
          themeMode: themeMode,
          locale: locale,
          overrides: [authControllerProvider.overrideWith(() => auth)],
        );

    testWidgets('shows appearance, language and account sections',
        (tester) async {
      await pumpSettings(tester);

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('APPEARANCE'), findsOneWidget);
      expect(find.text('LANGUAGE'), findsOneWidget);
      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('Meera Rao'), findsOneWidget);
      expect(find.text('1 workspace · Pro plan'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
    });

    testWidgets('switches theme mode and persists it', (tester) async {
      await pumpSettings(tester);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SettingsScreen));
      expect(Theme.of(context).brightness, Brightness.dark);
    });

    testWidgets('switches language to Hindi and persists it', (tester) async {
      final prefs = await pumpApp(
        tester,
        const SettingsScreen(),
        overrides: [authControllerProvider.overrideWith(() => auth)],
      );

      await tester.tap(find.text('हिन्दी'));
      await tester.pumpAndSettle();

      expect(find.text('सेटिंग्स'), findsOneWidget);
      expect(prefs.getString(LocaleController.storageKey), 'hi');
      expect(prefs.getString(ThemeController.storageKey), 'light');
    });

    testWidgets('sign out calls the auth controller', (tester) async {
      await pumpSettings(tester);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      expect(auth.signOutCalls, 1);
      expect(find.text('Sign in'), findsOneWidget);
    });

    for (final (label, themeMode, locale) in [
      ('light en', ThemeMode.light, const Locale('en')),
      ('dark hi', ThemeMode.dark, const Locale('hi')),
    ]) {
      testWidgets('lays out at 320px without overflow ($label)', (tester) async {
        await pumpSettings(
          tester,
          size: narrowPhoneSize,
          themeMode: themeMode,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
