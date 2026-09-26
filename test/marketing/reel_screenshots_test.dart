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
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/brand_mark.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';

import '../helpers/action_fixtures.dart';
import '../helpers/pump_app.dart';

/// Where the PNGs are written. Empty means "not requested", and everything
/// here is skipped — a bare `flutter test` must stay green.
const String _outDir = String.fromEnvironment('REEL_OUT');

/// Fonts the script downloads. Family names match the fallbacks in
/// [AppFonts] when `useGoogleFonts` is false (see test/flutter_test_config.dart).
const String _fontCacheDir = '.dart_tool/reel_fonts';

/// Reel canvas: 360x640 logical at pixelRatio 3 is exactly 1080x1920.
const Size _reelSize = Size(360, 640);
const double _reelPixelRatio = 3;

/// Square canvas for the brand mark.
const Size _logoSize = Size(360, 360);

// ---------------------------------------------------------------------------
// Demo data — "Niko", the dog that asks before it acts.
// ---------------------------------------------------------------------------

final DateTime _now = DateTime(2026, 9, 26, 10, 30);

final ActionItem _invoiceAction = ActionItem(
  id: 'niko-1',
  agentId: 'niko',
  agentName: 'Niko',
  agentPlatform: AgentPlatform.n8n,
  type: ActionTypes.email,
  title: 'Send invoice to Sharma Traders',
  summary: 'Niko wants to email invoice #INV-1042 (₹18,500) to '
      'accounts@sharmatraders.in',
  payload: const {
    'to': 'accounts@sharmatraders.in',
    'subject': 'Invoice #INV-1042 for September',
    'body': 'Hello Sharma Traders,\n\n'
        'Please find invoice #INV-1042 for ₹18,500 attached, covering '
        'September.\n'
        'Payment is due in 15 days — do tell us if anything looks off.\n\n'
        'Thank you,\n'
        'AI Cockpit Demo',
  },
  editableFields: const ['subject', 'body'],
  status: ActionStatus.pending,
  createdAt: _now,
);

/// The same action after the owner taps Approve.
final ActionItem _invoiceApproved = _invoiceAction.copyWith(
  status: ActionStatus.decided,
  decision: DecisionType.approved,
  decidedAt: _now.add(const Duration(minutes: 1)),
);

final ActionItem _leadAction = ActionItem(
  id: 'niko-2',
  agentId: 'niko',
  agentName: 'Niko',
  agentPlatform: AgentPlatform.n8n,
  type: ActionTypes.email,
  title: 'Reply to new lead — Priya Mehta',
  summary: 'Niko drafted a reply to a website enquiry.',
  payload: const {
    'to': 'priya.mehta@example.in',
    'subject': 'Re: Enquiry about your automation service',
    'body': 'Hi Priya,\n\nThanks for reaching out — happy to help.',
  },
  editableFields: const ['subject', 'body'],
  status: ActionStatus.pending,
  createdAt: _now.subtract(const Duration(minutes: 12)),
);

final ActionItem _linkedInAction = ActionItem(
  id: 'niko-3',
  agentId: 'niko',
  agentName: 'Niko',
  agentPlatform: AgentPlatform.n8n,
  type: 'post', // unknown type -> generic renderer (TR-5)
  title: 'Post weekly update on LinkedIn',
  summary: 'Niko wrote this week’s build-in-public post.',
  payload: const {'text': 'Week 12: shipping the approval inbox.'},
  status: ActionStatus.pending,
  createdAt: _now.subtract(const Duration(hours: 2)),
);

final ActionItem _followUpApproved = ActionItem(
  id: 'niko-4',
  agentId: 'niko',
  agentName: 'Niko',
  agentPlatform: AgentPlatform.n8n,
  type: ActionTypes.email,
  title: 'Send follow-up to Rao & Co.',
  summary: 'Sent after you approved it.',
  payload: const {'to': 'hello@raoandco.example'},
  status: ActionStatus.decided,
  decision: DecisionType.approved,
  createdAt: _now.subtract(const Duration(hours: 5)),
  decidedAt: _now.subtract(const Duration(hours: 4)),
);

final List<ActionItem> _feed = [
  _invoiceAction,
  _leadAction,
  _linkedInAction,
  _followUpApproved,
];

/// Detail controller that serves one fixed item and accepts any decision.
class _DemoDetailController extends ActionDetailController {
  _DemoDetailController(this.item) : super(item.id);

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

Override _detailOverride(ActionItem item) =>
    actionDetailControllerProvider(item.id)
        .overrideWith(() => _DemoDetailController(item));

// ---------------------------------------------------------------------------
// Font loading
// ---------------------------------------------------------------------------

/// Registers the real brand fonts plus everything already in the bundle.
///
/// `test/flutter_test_config.dart` sets `AppFonts.useGoogleFonts = false` so the
/// app's styles fall back to plain family names; without the matching font
/// files every glyph renders as a box. The generator script downloads them to
/// [_fontCacheDir] first.
Future<void> _loadFonts() async {
  // MaterialIcons and anything declared in pubspec come from the test bundle.
  final manifest = await rootBundle.loadString('FontManifest.json');
  for (final entry in (jsonDecodeList(manifest))) {
    final family = entry['family'] as String?;
    final fonts = (entry['fonts'] as List?)?.cast<Map<String, dynamic>>();
    if (family == null || fonts == null) continue;
    final loader = FontLoader(family);
    for (final font in fonts) {
      final asset = font['asset'] as String?;
      if (asset != null) loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }

  final dir = Directory(_fontCacheDir);
  if (!dir.existsSync()) {
    throw StateError(
      'Brand fonts are missing from $_fontCacheDir.\n'
      'Run tool/generate_reel_screenshots.sh (or .ps1) — it downloads them '
      'before invoking this test.',
    );
  }

  // Files are named "<Family>__<weight>.ttf"; every weight of a family is
  // registered together so Flutter can pick the right face per TextStyle.
  final byFamily = <String, List<File>>{};
  for (final file in dir.listSync().whereType<File>()) {
    if (!file.path.endsWith('.ttf')) continue;
    final name = file.uri.pathSegments.last;
    final family = name.split('__').first.replaceAll('_', ' ');
    byFamily.putIfAbsent(family, () => []).add(file);
  }

  if (byFamily.isEmpty) {
    throw StateError('No .ttf files found in $_fontCacheDir.');
  }

  for (final entry in byFamily.entries) {
    final loader = FontLoader(entry.key);
    for (final file in entry.value) {
      loader.addFont(
        Future.value(ByteData.sublistView(file.readAsBytesSync())),
      );
    }
    await loader.load();
  }
}

/// FontManifest.json is always a list of `{family, fonts}` maps.
List<Map<String, dynamic>> jsonDecodeList(String source) =>
    (jsonDecode(source) as List).cast<Map<String, dynamic>>();

// ---------------------------------------------------------------------------
// Capture
// ---------------------------------------------------------------------------

final GlobalKey _boundaryKey = GlobalKey();

/// Wraps [child] in the RepaintBoundary that [_capture] photographs.
Widget _framed(Widget child) => RepaintBoundary(key: _boundaryKey, child: child);

/// Writes the boundary to [fileName] at [_reelPixelRatio].
Future<void> _capture(WidgetTester tester, String fileName) async {
  late Uint8List bytes;

  await tester.runAsync(() async {
    final boundary = _boundaryKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: _reelPixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    bytes = data!.buffer.asUint8List();
  });

  final file = File('$_outDir${Platform.pathSeparator}$fileName')
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes);

  // Surfaced in the test output so the operator can see what was produced.
  // ignore: avoid_print
  print('wrote ${file.path} (${(bytes.length / 1024).toStringAsFixed(0)} KB)');
}

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
    setUpAll(_loadFonts);

    testWidgets('01_notification', (tester) async {
      await pumpApp(
        tester,
        _framed(const _LockScreenNotification()),
        size: _reelSize,
      );
      await _capture(tester, '01_notification.png');
    });

    testWidgets('02_action_detail_pending', (tester) async {
      await pumpApp(
        tester,
        _framed(ActionDetailScreen(actionId: _invoiceAction.id)),
        size: _reelSize,
        overrides: [_detailOverride(_invoiceAction)],
      );
      await _capture(tester, '02_action_detail_pending.png');
    });

    testWidgets('03_action_detail_approved', (tester) async {
      await pumpApp(
        tester,
        _framed(ActionDetailScreen(actionId: _invoiceApproved.id)),
        size: _reelSize,
        overrides: [_detailOverride(_invoiceApproved)],
      );
      await _capture(tester, '03_action_detail_approved.png');
    });

    testWidgets('04_feed', (tester) async {
      await pumpApp(
        tester,
        _framed(const ActionsFeedScreen()),
        size: _reelSize,
        overrides: [feedOverride(_feed)],
      );
      await _capture(tester, '04_feed.png');
    });

    testWidgets('02_action_detail_pending_dark', (tester) async {
      await pumpApp(
        tester,
        _framed(ActionDetailScreen(actionId: _invoiceAction.id)),
        size: _reelSize,
        themeMode: ThemeMode.dark,
        overrides: [_detailOverride(_invoiceAction)],
      );
      await _capture(tester, '02_action_detail_pending_dark.png');
    });

    testWidgets('04_feed_dark', (tester) async {
      await pumpApp(
        tester,
        _framed(const ActionsFeedScreen()),
        size: _reelSize,
        themeMode: ThemeMode.dark,
        overrides: [feedOverride(_feed)],
      );
      await _capture(tester, '04_feed_dark.png');
    });

    testWidgets('logo_1080', (tester) async {
      await pumpApp(
        tester,
        _framed(
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
      final boundaryContext = _boundaryKey.currentContext!;
      expect(boundaryContext.findRenderObject(), isA<RenderRepaintBoundary>());

      await _capture(tester, 'logo_1080.png');
    });
  });
}
