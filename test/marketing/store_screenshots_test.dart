// Play Store phone screenshot generator.
//
// Renders the REAL screens (sign-in, actions feed, action detail, connections)
// through the same ProviderScope / theme / localization stack as the app, with
// the "Niko" demo data from marketing_support.dart injected via provider
// overrides. Nothing in lib/ is touched.
//
// It is opt-in: without --dart-define=STORE_OUT=<dir> every test here is
// skipped, so a plain `flutter test` (and CI) is unaffected. Run it with:
//
//   tool/generate_store_screenshots.sh          (macOS / Linux / Git Bash)
//   tool\generate_store_screenshots.ps1         (Windows PowerShell)
//
// Output: 360x640 logical at pixelRatio 3 => 1080x1920 PNG, English, in light
// and dark theme.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';
import 'package:cockpit/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';

import '../helpers/action_fixtures.dart';
import '../helpers/pump_app.dart';
import 'marketing_support.dart';

/// Where the PNGs are written. Empty means "not requested", and everything
/// here is skipped — a bare `flutter test` must stay green.
const String _outDir = String.fromEnvironment('STORE_OUT');

/// 360x640 logical at pixelRatio 3 is exactly 1080x1920.
const Size _storeSize = Size(360, 640);
const double _storePixelRatio = 3;

/// Niko plus two more agents, so the connections list looks lived-in.
/// "Last action" is relative to the run, so it reads "2 min ago", not a
/// stale date.
final List<Agent> _demoAgents = [
  Agent(
    id: 'niko',
    name: 'Niko',
    platform: AgentPlatform.n8n,
    callbackUrl: 'https://n8n.example.in/webhook/niko',
    secretHint: '3a9f',
    lastActionAt: DateTime.now().subtract(const Duration(minutes: 2)),
  ),
  Agent(
    id: 'ledger',
    name: 'Ledger',
    platform: AgentPlatform.make,
    callbackUrl: 'https://hook.make.example/ledger',
    secretHint: '71c2',
    lastActionAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  const Agent(
    id: 'lead-desk',
    name: 'Lead desk',
    platform: AgentPlatform.zapier,
    callbackUrl: 'https://hooks.zapier.example/lead-desk',
    secretHint: 'b04e',
  ),
];

class _DemoConnections extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => _demoAgents;
}

void main() {
  // Everything below writes files, so it only runs when explicitly asked.
  final skip = _outDir.isEmpty
      ? 'Pass --dart-define=STORE_OUT=<dir> (see tool/generate_store_screenshots).'
      : null;

  group('store screenshots', skip: skip, () {
    setUpAll(loadBrandFonts);

    for (final (theme, mode) in const [('light', ThemeMode.light), ('dark', ThemeMode.dark)]) {
      Future<void> shoot(
        WidgetTester tester,
        String name,
        Widget screen, {
        List<Override> overrides = const [],
      }) async {
        await pumpApp(
          tester,
          framed(screen),
          size: _storeSize,
          themeMode: mode,
          overrides: overrides,
        );
        await capture(tester, _outDir, '${name}_$theme.png', pixelRatio: _storePixelRatio);
      }

      testWidgets('01_sign_in ($theme)', (tester) async {
        await shoot(tester, '01_sign_in', const SignInScreen());
      });

      testWidgets('02_feed ($theme)', (tester) async {
        await shoot(tester, '02_feed', const ActionsFeedScreen(), overrides: [feedOverride(demoFeed)]);
      });

      testWidgets('03_detail_pending ($theme)', (tester) async {
        await shoot(
          tester,
          '03_detail_pending',
          ActionDetailScreen(actionId: invoiceAction.id),
          overrides: [detailOverride(invoiceAction)],
        );
      });

      testWidgets('04_detail_approved ($theme)', (tester) async {
        await shoot(
          tester,
          '04_detail_approved',
          ActionDetailScreen(actionId: invoiceApproved.id),
          overrides: [detailOverride(invoiceApproved)],
        );
      });

      testWidgets('05_connections ($theme)', (tester) async {
        await shoot(
          tester,
          '05_connections',
          const ConnectionsScreen(),
          overrides: [connectionsControllerProvider.overrideWith(_DemoConnections.new)],
        );
      });
    }
  });
}
