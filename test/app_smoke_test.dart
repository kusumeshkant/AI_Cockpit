import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cockpit/app.dart';
import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/di/providers.dart';
import 'package:cockpit/core/theme/theme_controller.dart';

import 'helpers/pump_app.dart';

/// Boots the real app (router, shell, controllers, use cases, repositories)
/// on the in-memory demo data sources and walks the main flows.
void main() {
  setUp(() => configureDependencies(demo: true));
  tearDown(getIt.reset);

  Future<void> pumpCockpit(WidgetTester tester, {Size size = phoneSize}) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(<String, Object>{
      ThemeController.storageKey: ThemeMode.light.name,
      'locale': 'en',
    });
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const CockpitApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('feed → detail → approve updates the feed', (tester) async {
    await pumpCockpit(tester);

    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('3 need your review'), findsOneWidget);

    await tester.tap(find.text('Reply to Priya — refund request'));
    await tester.pumpAndSettle();
    expect(find.text('Review action'), findsOneWidget);
    expect(find.text('priya.k@example.com'), findsOneWidget);

    await tester.tap(find.text('Approve'));
    await tester.pumpAndSettle();

    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('2 need your review'), findsOneWidget);
    expect(find.text('Decision recorded'), findsOneWidget);
  });

  testWidgets('bottom nav reaches connections, audit and settings',
      (tester) async {
    await pumpCockpit(tester);

    await tester.tap(find.text('Connect'));
    await tester.pumpAndSettle();
    expect(find.text('Connections'), findsOneWidget);
    expect(find.text('Email agent'), findsOneWidget);

    await tester.tap(find.text('Audit'));
    await tester.pumpAndSettle();
    expect(find.text('Audit log'), findsOneWidget);
    expect(find.text('Rejected · Delete 40 records'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Demo user'), findsOneWidget);
  });

  testWidgets('connect an agent from the connections tab', (tester) async {
    await pumpCockpit(tester);

    await tester.tap(find.text('Connect'));
    await tester.pumpAndSettle();
    // App-bar "Connect" button (the nav label is the other match).
    await tester.tap(find.text('Connect').first);
    await tester.pumpAndSettle();
    expect(find.text('Connect an agent'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Leads bot');
    await tester.enterText(
      find.byType(TextField).at(1),
      'https://hooks.example.com/leads',
    );
    await tester.tap(find.text('Create connection'));
    await tester.pumpAndSettle();

    expect(find.text('Shown once — copy it now'), findsOneWidget);
    expect(find.text('Send a test action'), findsOneWidget);
  });

  testWidgets('tablet shows rail and master–detail feed', (tester) async {
    await pumpCockpit(tester, size: tabletSize);

    expect(find.text('Connections'), findsOneWidget);
    expect(find.text('priya.k@example.com'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
