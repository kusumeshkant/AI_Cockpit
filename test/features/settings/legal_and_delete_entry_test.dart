// F03 Terms / Privacy links (sign-in + Settings → Legal) and the F02
// Settings → Delete account entry.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/config/config_providers.dart';
import 'package:cockpit/core/config/flavor.dart';
import 'package:cockpit/core/di/providers.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cockpit/features/settings/presentation/screens/delete_account_screen.dart';
import 'package:cockpit/features/settings/presentation/screens/settings_screen.dart';
import 'package:cockpit/l10n/app_localizations.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

AppConfig _config({String terms = '', String privacy = ''}) => AppConfig(
      flavor: Flavor.dev,
      supabaseUrl: '',
      supabaseAnonKey: '',
      sentryDsn: '',
      posthogKey: '',
      firebaseEnabled: false,
      termsUrl: terms,
      privacyUrl: privacy,
    );

final _withLinks = _config(
  terms: 'https://cockpit.example/terms',
  privacy: 'https://cockpit.example/privacy',
);

void main() {
  late List<Uri> opened;
  late bool openSucceeds;

  setUp(() {
    opened = [];
    openSucceeds = true;
  });

  List<Override> overrides(AppConfig config, {FakeAuthController? auth}) => [
        appConfigProvider.overrideWithValue(config),
        externalUrlOpenerProvider.overrideWithValue((uri) async {
          opened.add(uri);
          return openSucceeds;
        }),
        authControllerProvider.overrideWith(() => auth ?? FakeAuthController()),
      ];

  group('sign-in legal links', () {
    testWidgets('open the configured Terms and Privacy pages', (tester) async {
      await pumpApp(tester, const SignInScreen(), overrides: overrides(_withLinks));

      await tester.tap(find.text('Terms of Service'));
      await tester.pump();
      await tester.tap(find.text('Privacy Policy'));
      await tester.pump();

      expect(opened, [
        Uri.parse('https://cockpit.example/terms'),
        Uri.parse('https://cockpit.example/privacy'),
      ]);
    });

    testWidgets('are hidden when no URL is configured (the notice stays)', (tester) async {
      await pumpApp(tester, const SignInScreen(), overrides: overrides(_config()));

      expect(find.text('Terms of Service'), findsNothing);
      expect(find.text('Privacy Policy'), findsNothing);
      expect(find.textContaining('By continuing you agree'), findsOneWidget);
    });

    testWidgets('only a configured link is shown', (tester) async {
      await pumpApp(
        tester,
        const SignInScreen(),
        overrides: overrides(_config(privacy: 'https://cockpit.example/privacy')),
      );

      expect(find.text('Terms of Service'), findsNothing);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('a page that cannot be opened shows a message', (tester) async {
      openSucceeds = false;
      await pumpApp(tester, const SignInScreen(), overrides: overrides(_withLinks));

      await tester.tap(find.text('Privacy Policy'));
      await tester.pump();

      expect(find.text("Couldn't open the page. Try again later."), findsOneWidget);
    });

    testWidgets('fit 320dp (hi)', (tester) async {
      await pumpApp(
        tester,
        const SignInScreen(),
        size: narrowPhoneSize,
        locale: const Locale('hi'),
        overrides: overrides(_withLinks),
      );

      expect(find.text('सेवा की शर्तें'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Settings', () {
    testWidgets('Legal section opens the pages', (tester) async {
      await pumpApp(tester, const SettingsScreen(), overrides: overrides(_withLinks));

      await tester.scrollUntilVisible(find.text('Privacy Policy'), 200);
      expect(find.text('LEGAL'), findsOneWidget);
      await tester.tap(find.text('Privacy Policy'));
      await tester.pump();

      expect(opened, [Uri.parse('https://cockpit.example/privacy')]);
    });

    testWidgets('no Legal section without URLs', (tester) async {
      await pumpApp(tester, const SettingsScreen(), overrides: overrides(_config()));

      expect(find.text('LEGAL'), findsNothing);
      expect(find.text('Terms of Service'), findsNothing);
    });

    testWidgets('Delete account opens the confirm screen', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final router = GoRouter(
        initialLocation: RoutePaths.settings,
        routes: [
          GoRoute(
            name: RouteNames.settings,
            path: RoutePaths.settings,
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                name: RouteNames.deleteAccount,
                path: RoutePaths.deleteAccount,
                builder: (context, state) => const DeleteAccountScreen(),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      tester.view
        ..physicalSize = phoneSize
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            ...overrides(_config()),
          ],
          child: MaterialApp.router(
            theme: AppTheme.buildLight(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final entry = find.byKey(const ValueKey('settings_delete_account'));
      await tester.scrollUntilVisible(entry, 200);
      await tester.tap(entry);
      await tester.pumpAndSettle();

      expect(find.byType(DeleteAccountScreen), findsOneWidget);
      expect(find.text("This can't be undone"), findsOneWidget);
    });

    for (final (label, locale) in const [('en', Locale('en')), ('hi', Locale('hi'))]) {
      testWidgets('Account + Legal fit 320dp ($label)', (tester) async {
        await pumpApp(
          tester,
          const SettingsScreen(),
          size: narrowPhoneSize,
          locale: locale,
          overrides: overrides(_withLinks),
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
