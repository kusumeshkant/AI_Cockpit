// The brand name next to the mark never truncates or wraps: the rail drops
// the name when it doesn't fit, and the sign-in title stays on one line.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_navigation.dart';
import 'package:cockpit/core/widgets/brand_mark.dart';
import 'package:cockpit/features/auth/presentation/screens/sign_in_screen.dart';

import '../../helpers/pump_app.dart';

const _items = [
  AppNavItem(icon: AppIcons.tray, label: 'Actions', railLabel: 'Actions'),
  AppNavItem(icon: AppIcons.link, label: 'Connect', railLabel: 'Connections'),
  AppNavItem(icon: AppIcons.gear, label: 'Settings', railLabel: 'Settings'),
];

Widget _textScale(double scale, Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
        child: child,
      ),
    );

Widget _rail(String brandName) => Row(
      children: [
        AppNavRail(
          items: _items,
          currentIndex: 0,
          onSelected: (_) {},
          brandName: brandName,
        ),
        const Expanded(child: SizedBox.expand()),
      ],
    );

/// Distinct line tops of [paragraph]'s text.
int _lines(RenderParagraph paragraph) => paragraph
    .getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: paragraph.text.toPlainText().length),
    )
    .map((box) => box.top.round())
    .toSet()
    .length;

void main() {
  group('rail brand', () {
    testWidgets('shows the name when it fits', (tester) async {
      await pumpApp(tester, _rail('Co'), size: tabletSize);

      final name = tester.renderObject<RenderParagraph>(find.text('Co'));
      expect(name.didExceedMaxLines, isFalse);
      expect(find.byType(BrandMark), findsOneWidget);
    });

    testWidgets('at 1.5x text shows only the mark, still announced as AI Cockpit',
        (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, _textScale(1.5, _rail('AI Cockpit')), size: tabletSize);

      expect(find.text('AI Cockpit'), findsNothing, reason: 'no truncated "AI Co…"');
      expect(find.byType(BrandMark), findsOneWidget);
      expect(find.bySemanticsLabel('AI Cockpit'), findsOneWidget);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });

    testWidgets('other rail labels keep their ellipsis behaviour at 1.5x', (tester) async {
      await pumpApp(tester, _textScale(1.5, _rail('AI Cockpit')), size: tabletSize);

      final label = tester.widget<Text>(find.text('Connections'));
      expect(label.overflow, TextOverflow.ellipsis);
      expect(label.maxLines, 1);
    });
  });

  group('sign-in title', () {
    for (final scale in [1.0, 1.5]) {
      testWidgets('one line at 320dp, ${scale}x text, no overflow', (tester) async {
        await pumpApp(tester, _textScale(scale, const SignInScreen()), size: narrowPhoneSize);

        final title = tester.renderObject<RenderParagraph>(find.text('AI Cockpit'));
        expect(_lines(title), 1);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
