// BrandMark shows the AI Cockpit radar symbol for the current brightness and
// announces itself as "AI Cockpit".
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/widgets/brand_mark.dart';

import '../helpers/pump_app.dart';

String _assetName(WidgetTester tester) {
  final image = tester.widget<Image>(find.byType(Image));
  return (image.image as ResizeImage).imageProvider is AssetImage
      ? ((image.image as ResizeImage).imageProvider as AssetImage).assetName
      : '';
}

void main() {
  testWidgets('light theme uses the light-background symbol', (tester) async {
    await pumpApp(tester, const Center(child: BrandMark(size: 44)));
    expect(_assetName(tester), BrandMark.lightAsset);
  });

  testWidgets('dark theme uses the dark-background symbol', (tester) async {
    await pumpApp(tester, const Center(child: BrandMark(size: 44)), themeMode: ThemeMode.dark);
    expect(_assetName(tester), BrandMark.darkAsset);
  });

  testWidgets('keeps its size, with or without the halo', (tester) async {
    await pumpApp(
      tester,
      const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [BrandMark(size: 30), BrandMark(size: 44, halo: true)],
        ),
      ),
    );
    final sizes = tester.renderObjectList<RenderBox>(find.byType(BrandMark)).map((b) => b.size);
    expect(sizes, [const Size(30, 30), const Size(44, 44)]);
  });

  testWidgets('is announced as "AI Cockpit" in en and hi', (tester) async {
    for (final locale in const [Locale('en'), Locale('hi')]) {
      final handle = tester.ensureSemantics();
      await pumpApp(tester, const Center(child: BrandMark(size: 44)), locale: locale);
      expect(find.bySemanticsLabel('AI Cockpit'), findsOneWidget);
      handle.dispose();
    }
  });
}
