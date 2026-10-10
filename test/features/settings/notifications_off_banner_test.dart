// F11: Settings says so when the notification permission was denied.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/notifications/presentation/notification_service.dart';
import 'package:cockpit/features/settings/presentation/screens/settings_screen.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

final Finder _banner = find.byKey(const ValueKey('settings_notifications_off'));

Widget _textScale(double scale, Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
        child: child,
      ),
    );

void main() {
  Future<void> pumpSettings(
    WidgetTester tester,
    bool? granted, {
    Size size = phoneSize,
    Locale locale = const Locale('en'),
    double textScale = 1,
  }) =>
      pumpApp(
        tester,
        _textScale(textScale, const SettingsScreen()),
        size: size,
        locale: locale,
        overrides: [
          authControllerProvider.overrideWith(FakeAuthController.new),
          pushPermissionGrantedProvider.overrideWithValue(granted),
        ],
      );

  testWidgets('denied: the banner explains where to turn them on', (tester) async {
    await pumpSettings(tester, false);

    expect(_banner, findsOneWidget);
    expect(find.text('NOTIFICATIONS ARE OFF'), findsOneWidget);
    expect(find.textContaining("in your phone's settings"), findsOneWidget);
  });

  testWidgets('granted or not asked: no banner', (tester) async {
    await pumpSettings(tester, true);
    expect(_banner, findsNothing);

    await pumpSettings(tester, null);
    expect(_banner, findsNothing);
  });

  for (final (label, locale) in const [('en', Locale('en')), ('hi', Locale('hi'))]) {
    testWidgets('fits 320dp at 1.5x text ($label)', (tester) async {
      await pumpSettings(tester, false, size: narrowPhoneSize, locale: locale, textScale: 1.5);
      expect(_banner, findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
