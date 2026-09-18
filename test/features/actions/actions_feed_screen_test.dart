import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/widgets/action_card.dart';
import 'package:cockpit/core/widgets/app_empty_view.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';

import '../../helpers/action_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('ActionsFeedScreen', () {
    testWidgets('shows header count and a card per action', (tester) async {
      await pumpApp(
        tester,
        const ActionsFeedScreen(),
        overrides: [feedOverride(fixtureFeed)],
      );

      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('2 need your review'), findsOneWidget);
      expect(find.byType(ActionCard), findsNWidgets(3));
      expect(find.text('n8n · Email agent'), findsOneWidget);
      expect(find.text('Reply to Priya — refund request'), findsOneWidget);
      expect(find.text('PENDING'), findsNWidgets(2));
      expect(find.text('APPROVED'), findsOneWidget);
    });

    testWidgets('dims decided actions only', (tester) async {
      await pumpApp(
        tester,
        const ActionsFeedScreen(),
        overrides: [feedOverride(fixtureFeed)],
      );

      final cards = tester.widgetList<ActionCard>(find.byType(ActionCard));
      expect(cards.map((card) => card.dimmed), [false, false, true]);
    });

    testWidgets('shows the empty state when nothing is pending', (tester) async {
      await pumpApp(
        tester,
        const ActionsFeedScreen(),
        overrides: [feedOverride(const [])],
      );

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text('All clear'), findsOneWidget);
    });

    testWidgets('renders in dark theme with dark surface colors', (tester) async {
      await pumpApp(
        tester,
        const ActionsFeedScreen(),
        themeMode: ThemeMode.dark,
        overrides: [feedOverride(fixtureFeed)],
      );

      final context = tester.element(find.byType(ActionsFeedScreen));
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(tester.takeException(), isNull);
    });

    for (final (label, themeMode, locale) in [
      ('light en', ThemeMode.light, const Locale('en')),
      ('dark hi', ThemeMode.dark, const Locale('hi')),
    ]) {
      testWidgets('lays out at 320px without overflow ($label)', (tester) async {
        await pumpApp(
          tester,
          const ActionsFeedScreen(),
          size: narrowPhoneSize,
          themeMode: themeMode,
          locale: locale,
          overrides: [feedOverride(fixtureFeed)],
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
