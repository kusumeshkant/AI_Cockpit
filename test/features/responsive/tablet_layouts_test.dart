import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_navigation.dart';
import 'package:cockpit/core/widgets/app_shell.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_review.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/settings/presentation/screens/settings_screen.dart';
import 'package:cockpit/features/settings/presentation/widgets/language_tile.dart';
import 'package:cockpit/features/settings/presentation/widgets/theme_mode_tile.dart';

import '../../helpers/action_fixtures.dart';
import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

class _StaticDetailController extends ActionDetailController {
  _StaticDetailController(this.item) : super(item.id);

  final ActionItem item;

  @override
  Future<ActionItem> build() async => item;

  @override
  Future<Failure?> decide(
    DecisionType type, {
    Map<String, dynamic>? editedPayload,
    String? reason,
  }) async =>
      null;
}

const List<AppNavItem> _items = [
  AppNavItem(icon: AppIcons.tray, label: 'Actions', railLabel: 'Actions', badgeCount: 3),
  AppNavItem(icon: AppIcons.link, label: 'Connect', railLabel: 'Connections'),
  AppNavItem(icon: AppIcons.list, label: 'Audit', railLabel: 'Audit log'),
  AppNavItem(icon: AppIcons.gear, label: 'Settings', railLabel: 'Settings'),
];

Widget _shell() => AppShell(
      items: _items,
      currentIndex: 0,
      onSelected: (_) {},
      brandName: 'Cockpit',
      child: const SizedBox.expand(),
    );

void main() {
  group('AppShell', () {
    testWidgets('uses the bottom nav on phones', (tester) async {
      await pumpApp(tester, _shell());
      expect(find.byType(AppBottomNav), findsOneWidget);
      expect(find.byType(AppNavRail), findsNothing);
    });

    testWidgets('uses the left rail with badge on tablets', (tester) async {
      await pumpApp(tester, _shell(), size: tabletSize);
      expect(find.byType(AppNavRail), findsOneWidget);
      expect(find.byType(AppBottomNav), findsNothing);
      expect(find.text('Connections'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });

  group('Tablet feed', () {
    testWidgets('shows master–detail with the first pending action selected',
        (tester) async {
      await pumpApp(
        tester,
        const ActionsFeedScreen(),
        size: tabletSize,
        overrides: [
          feedOverride(fixtureFeed),
          for (final item in fixtureFeed)
            actionDetailControllerProvider(item.id)
                .overrideWith(() => _StaticDetailController(item)),
        ],
      );

      expect(find.byType(ActionReview), findsOneWidget);
      expect(find.text('priya.k@example.com'), findsOneWidget);

      await tester.tap(find.text('Post invoice ₹48,900 to Xero'));
      await tester.pumpAndSettle();

      expect(find.text('Acme Cloud'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('stays single-column on phones', (tester) async {
      await pumpApp(
        tester,
        const ActionsFeedScreen(),
        overrides: [feedOverride(fixtureFeed)],
      );
      expect(find.byType(ActionReview), findsNothing);
    });
  });

  group('Tablet settings', () {
    testWidgets('lays out a two-column grid with inline sign out',
        (tester) async {
      await pumpApp(
        tester,
        const SettingsScreen(),
        size: tabletSize,
        themeMode: ThemeMode.dark,
        locale: const Locale('hi'),
        overrides: [
          authControllerProvider.overrideWith(FakeAuthController.new),
        ],
      );

      final theme = tester.getTopLeft(find.byType(ThemeModeTile));
      final language = tester.getTopLeft(find.byType(LanguageTile));
      expect(theme.dy, language.dy);
      expect(language.dx, greaterThan(theme.dx));
      expect(find.text('ऐप की भाषा'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
