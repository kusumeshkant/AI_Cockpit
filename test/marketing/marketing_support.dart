// Shared helpers for the opt-in marketing screenshot generators
// (reel_screenshots_test.dart, store_screenshots_test.dart): the "Niko" demo
// data, real brand-font loading and PNG capture. Test-only; nothing in lib/
// depends on it.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';

// ---------------------------------------------------------------------------
// Demo data — "Niko", the dog that asks before it acts.
// ---------------------------------------------------------------------------

final DateTime demoNow = DateTime(2026, 9, 26, 10, 30);

final ActionItem invoiceAction = ActionItem(
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
  createdAt: demoNow,
);

/// The same action after the owner taps Approve.
final ActionItem invoiceApproved = invoiceAction.copyWith(
  status: ActionStatus.decided,
  decision: DecisionType.approved,
  decidedAt: demoNow.add(const Duration(minutes: 1)),
);

final ActionItem leadAction = ActionItem(
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
  createdAt: demoNow.subtract(const Duration(minutes: 12)),
);

final ActionItem linkedInAction = ActionItem(
  id: 'niko-3',
  agentId: 'niko',
  agentName: 'Niko',
  agentPlatform: AgentPlatform.n8n,
  type: 'post', // unknown type -> generic renderer (TR-5)
  title: 'Post weekly update on LinkedIn',
  summary: 'Niko wrote this week’s build-in-public post.',
  payload: const {'text': 'Week 12: shipping the approval inbox.'},
  status: ActionStatus.pending,
  createdAt: demoNow.subtract(const Duration(hours: 2)),
);

final ActionItem followUpApproved = ActionItem(
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
  createdAt: demoNow.subtract(const Duration(hours: 5)),
  decidedAt: demoNow.subtract(const Duration(hours: 4)),
);

final List<ActionItem> demoFeed = [
  invoiceAction,
  leadAction,
  linkedInAction,
  followUpApproved,
];

/// Detail controller that serves one fixed item and accepts any decision.
class DemoDetailController extends ActionDetailController {
  DemoDetailController(this.item) : super(item.id);

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

Override detailOverride(ActionItem item) =>
    actionDetailControllerProvider(item.id)
        .overrideWith(() => DemoDetailController(item));

// ---------------------------------------------------------------------------
// Font loading
// ---------------------------------------------------------------------------

/// Fonts the generator scripts download (tool/fetch_brand_fonts). Family
/// names match the fallbacks in [AppFonts] when `useGoogleFonts` is false
/// (see test/flutter_test_config.dart).
const String brandFontCacheDir = '.dart_tool/reel_fonts';

/// Registers the real brand fonts plus everything already in the bundle.
///
/// `test/flutter_test_config.dart` sets `AppFonts.useGoogleFonts = false` so the
/// app's styles fall back to plain family names; without the matching font
/// files every glyph renders as a box. The generator script downloads them to
/// [brandFontCacheDir] first.
Future<void> loadBrandFonts() async {
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

  final dir = Directory(brandFontCacheDir);
  if (!dir.existsSync()) {
    throw StateError(
      'Brand fonts are missing from $brandFontCacheDir.\n'
      'Run tool/generate_reel_screenshots or tool/generate_store_screenshots '
      '(.sh or .ps1) — they download them before invoking the test.',
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
    throw StateError('No .ttf files found in $brandFontCacheDir.');
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

final GlobalKey marketingBoundaryKey = GlobalKey();

/// Wraps [child] in the RepaintBoundary that [capture] photographs.
Widget framed(Widget child) => RepaintBoundary(key: marketingBoundaryKey, child: child);

/// Decodes every on-screen [Image] (e.g. the BrandMark asset) and repaints.
///
/// Image decoding is real async work that the fake test clock never waits
/// for, so without this the logo would be missing from the PNG.
Future<void> settleImages(WidgetTester tester) async {
  final images = tester.elementList(find.byType(Image)).toList();
  if (images.isEmpty) return;
  await tester.runAsync(() async {
    for (final element in images) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pumpAndSettle();
}

/// Writes the [framed] boundary to [outDir]/[fileName] at [pixelRatio].
Future<void> capture(
  WidgetTester tester,
  String outDir,
  String fileName, {
  double pixelRatio = 3,
}) async {
  await settleImages(tester);
  late Uint8List bytes;

  await tester.runAsync(() async {
    final boundary = marketingBoundaryKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    bytes = data!.buffer.asUint8List();
  });

  final file = File('$outDir${Platform.pathSeparator}$fileName')
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes);

  // Surfaced in the test output so the operator can see what was produced.
  // ignore: avoid_print
  print('wrote ${file.path} (${(bytes.length / 1024).toStringAsFixed(0)} KB)');
}
