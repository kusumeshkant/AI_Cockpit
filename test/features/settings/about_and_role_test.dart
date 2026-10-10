// F12: Settings → About (version, support email) and the role on the
// account card.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/config/config_providers.dart';
import 'package:cockpit/core/config/flavor.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/settings/presentation/screens/settings_screen.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

AppConfig _config({String support = ''}) => AppConfig(
      flavor: Flavor.dev,
      supabaseUrl: '',
      supabaseAnonKey: '',
      sentryDsn: '',
      posthogKey: '',
      firebaseEnabled: false,
      supportEmail: support,
    );

Widget _textScale(double scale, Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
        child: child,
      ),
    );

void main() {
  late List<Uri> opened;

  setUp(() => opened = []);

  List<Override> overrides({String support = '', bool? owner}) => [
        appConfigProvider.overrideWithValue(_config(support: support)),
        externalUrlOpenerProvider.overrideWithValue((uri) async {
          opened.add(uri);
          return true;
        }),
        authControllerProvider.overrideWith(FakeAuthController.new),
        workspaceOwnerRoleProvider.overrideWithValue(owner),
      ];

  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);

  testWidgets('About shows the app version', (tester) async {
    await pumpApp(tester, const SettingsScreen(), overrides: overrides());

    final version = find.byKey(const ValueKey('settings_about_version'));
    await scrollTo(tester, version);
    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('Version ${AppConfig.appVersion}'), findsOneWidget);
  });

  testWidgets('no support row without SUPPORT_EMAIL', (tester) async {
    await pumpApp(tester, const SettingsScreen(), overrides: overrides());

    await scrollTo(tester, find.byKey(const ValueKey('settings_about_version')));
    expect(find.text('Email support'), findsNothing);
  });

  testWidgets('the support row opens a mail to SUPPORT_EMAIL', (tester) async {
    await pumpApp(tester, const SettingsScreen(), overrides: overrides(support: 'help@cockpit.example'));

    final row = find.byKey(const ValueKey('settings_about_support'));
    await scrollTo(tester, row);
    await tester.tap(row);
    await tester.pump();

    expect(opened, [Uri(scheme: 'mailto', path: 'help@cockpit.example')]);
  });

  testWidgets('the account card names the role once it is known', (tester) async {
    await pumpApp(tester, const SettingsScreen(), overrides: overrides(owner: true));
    expect(find.text('1 workspace · Pro plan · Owner'), findsOneWidget);
  });

  testWidgets('approver role', (tester) async {
    await pumpApp(tester, const SettingsScreen(), overrides: overrides(owner: false));
    expect(find.text('1 workspace · Pro plan · Approver'), findsOneWidget);
  });

  testWidgets('unknown role: nothing is guessed', (tester) async {
    await pumpApp(tester, const SettingsScreen(), overrides: overrides());
    expect(find.text('1 workspace · Pro plan'), findsOneWidget);
  });

  for (final (label, locale) in const [('en', Locale('en')), ('hi', Locale('hi'))]) {
    testWidgets('fits 320dp at 1.5x text ($label)', (tester) async {
      await pumpApp(
        tester,
        _textScale(1.5, const SettingsScreen()),
        size: narrowPhoneSize,
        locale: locale,
        overrides: overrides(support: 'help@cockpit.example', owner: true),
      );
      await scrollTo(tester, find.byKey(const ValueKey('settings_about_support')));
      expect(tester.takeException(), isNull);
    });
  }
}
