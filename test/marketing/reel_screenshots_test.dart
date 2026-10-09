// Marketing screenshot generator for the "Sky & Niko" reel.
//
// This renders the REAL screens — ActionsFeedScreen and ActionDetailScreen —
// through the same ProviderScope / theme / localization stack as the app, with
// demo data injected via provider overrides. Nothing in lib/ is touched.
//
// It is opt-in: without --dart-define=REEL_OUT=<dir> every test here is
// skipped, so a plain `flutter test` (and CI) is unaffected. Run it with:
//
//   tool/generate_reel_screenshots.sh          (macOS / Linux / Git Bash)
//   tool\generate_reel_screenshots.ps1         (Windows PowerShell)
//
// Output is 360x640 logical captured at pixelRatio 3 => 1080x1920 PNG (9:16),
// which is what Instagram wants.
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/brand_mark.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';

import '../helpers/action_fixtures.dart';
import '../helpers/pump_app.dart';
import 'marketing_support.dart';

/// Where the PNGs are written. Empty means "not requested", and everything
/// here is skipped — a bare `flutter test` must stay green.
const String _outDir = String.fromEnvironment('REEL_OUT');

/// Reel canvas: 360x640 logical at pixelRatio 3 is exactly 1080x1920.
const Size _reelSize = Size(360, 640);
const double _reelPixelRatio = 3;

/// Square canvas for the brand mark.
const Size _logoSize = Size(360, 360);

// ---------------------------------------------------------------------------
// The lock-screen push banner (screenshot 01 only — not an app widget)
// ---------------------------------------------------------------------------

/// A lock-screen-style notification over a soft blurred backdrop.
///
/// This one composition does not exist in the app — a real push notification is
/// drawn by the OS — so it is built here from the same theme tokens rather than
/// pretending to be an app screen.
class _LockScreenNotification extends StatelessWidget {
  const _LockScreenNotification();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final text = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.accentWash, colors.paper, colors.accentWash],
        ),
      ),
      child: Stack(
        children: [
          // Soft out-of-focus blobs, so the banner reads as "on a wallpaper".
          Positioned(
            top: -60,
            left: -40,
            child: _Blob(color: colors.accent.withValues(alpha: 0.35), size: 240),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: _Blob(color: colors.go.withValues(alpha: 0.22), size: 280),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: const SizedBox.expand(),
          ),
          // Positioned with left/right/top and no bottom: the card hugs its
          // content instead of stretching down the screen.
          Positioned(
            top: 120,
            left: spacing.md,
            right: spacing.md,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(spacing.radiusCard),
                border: Border.all(color: colors.line),
                boxShadow: [
                  BoxShadow(
                    color: colors.ink.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BrandMark(size: spacing.brandMarkSmall),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'AI Cockpit',
                                  style: text.labelLarge
                                      ?.copyWith(color: colors.ink),
                                ),
                              ),
                              Text(
                                'now',
                                style: text.labelSmall
                                    ?.copyWith(color: colors.muted),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing.xxs),
                          Text(
                            'Niko wants to: Send invoice to Sharma Traders',
                            style:
                                text.bodyMedium?.copyWith(color: colors.inkSoft),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ---------------------------------------------------------------------------

void main() {
  // Everything below writes files, so it only runs when explicitly asked.
  final skip = _outDir.isEmpty
      ? 'Pass --dart-define=REEL_OUT=<dir> (see tool/generate_reel_screenshots).'
      : null;

  group('reel screenshots', skip: skip, () {
    setUpAll(loadBrandFonts);

    testWidgets('01_notification', (tester) async {
      await pumpApp(
        tester,
        framed(const _LockScreenNotification()),
        size: _reelSize,
      );
      await capture(tester, _outDir, '01_notification.png', pixelRatio: _reelPixelRatio);
    });

    testWidgets('02_action_detail_pending', (tester) async {
      await pumpApp(
        tester,
        framed(ActionDetailScreen(actionId: invoiceAction.id)),
        size: _reelSize,
        overrides: [detailOverride(invoiceAction)],
      );
      await capture(tester, _outDir, '02_action_detail_pending.png', pixelRatio: _reelPixelRatio);
    });

    testWidgets('03_action_detail_approved', (tester) async {
      await pumpApp(
        tester,
        framed(ActionDetailScreen(actionId: invoiceApproved.id)),
        size: _reelSize,
        overrides: [detailOverride(invoiceApproved)],
      );
      await capture(tester, _outDir, '03_action_detail_approved.png', pixelRatio: _reelPixelRatio);
    });

    testWidgets('04_feed', (tester) async {
      await pumpApp(
        tester,
        framed(const ActionsFeedScreen()),
        size: _reelSize,
        overrides: [feedOverride(demoFeed)],
      );
      await capture(tester, _outDir, '04_feed.png', pixelRatio: _reelPixelRatio);
    });

    testWidgets('02_action_detail_pending_dark', (tester) async {
      await pumpApp(
        tester,
        framed(ActionDetailScreen(actionId: invoiceAction.id)),
        size: _reelSize,
        themeMode: ThemeMode.dark,
        overrides: [detailOverride(invoiceAction)],
      );
      await capture(tester, _outDir, '02_action_detail_pending_dark.png', pixelRatio: _reelPixelRatio);
    });

    testWidgets('04_feed_dark', (tester) async {
      await pumpApp(
        tester,
        framed(const ActionsFeedScreen()),
        size: _reelSize,
        themeMode: ThemeMode.dark,
        overrides: [feedOverride(demoFeed)],
      );
      await capture(tester, _outDir, '04_feed_dark.png', pixelRatio: _reelPixelRatio);
    });

    testWidgets('logo_1080', (tester) async {
      await pumpApp(
        tester,
        framed(
          // Transparent canvas: the PNG carries only the mark.
          Center(
            child: Builder(
              builder: (context) => BrandMark(size: _logoSize.width * 0.62),
            ),
          ),
        ),
        size: _logoSize,
      );

      // The scaffold background would otherwise be baked in.
      final boundaryContext = marketingBoundaryKey.currentContext!;
      expect(boundaryContext.findRenderObject(), isA<RenderRepaintBoundary>());

      await capture(tester, _outDir, 'logo_1080.png', pixelRatio: _reelPixelRatio);
    });
  });
}
