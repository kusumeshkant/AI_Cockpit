import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/theme/app_text_styles.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_chip.dart';
import 'package:cockpit/core/widgets/section_label.dart';
import 'package:cockpit/core/widgets/status_pill.dart';

import '../helpers/pump_app.dart';

// Widget tests use plain family names (AppFonts.useGoogleFonts = false).
const String _devanagariFamily = 'IBM Plex Sans Devanagari';
const String _monoFamily = 'IBM Plex Mono';

Text _text(WidgetTester tester, Finder of) =>
    tester.widget<Text>(find.descendant(of: of, matching: find.byType(Text)).first);

Future<void> _pumpLabels(WidgetTester tester, Locale locale) => pumpApp(
      tester,
      Column(
        children: [
          const SectionLabel('Appearance'),
          const StatusPill(label: 'Pending', tone: StatusTone.pending),
          AppChip(label: 'Rejected', selected: false, onSelected: () {}),
        ],
      ),
      locale: locale,
    );

void main() {
  group('script detection', () {
    test('Devanagari languages and the Deva script', () {
      expect(AppTextStyles.isDevanagari(const Locale('hi')), isTrue);
      expect(AppTextStyles.isDevanagari(const Locale('mr')), isTrue);
      expect(
        AppTextStyles.isDevanagari(const Locale.fromSubtags(languageCode: 'xx', scriptCode: 'Deva')),
        isTrue,
      );
      expect(AppTextStyles.isDevanagari(const Locale('en')), isFalse);
      expect(AppTextStyles.isDevanagari(null), isFalse);
    });
  });

  group('AppTheme.localize', () {
    final theme = AppTheme.buildLight();

    test('Latin locales keep the theme unchanged', () {
      expect(identical(AppTheme.localize(theme, const Locale('en')), theme), isTrue);
    });

    test('Hindi labels use the Devanagari font with no tracking', () {
      final hi = AppTheme.localize(theme, const Locale('hi'));
      for (final style in [
        hi.textTheme.labelMedium!,
        hi.textTheme.labelSmall!,
        hi.tooltipTheme.textStyle!,
      ]) {
        expect(style.fontFamily, _devanagariFamily);
        expect(style.letterSpacing, 0);
      }
      // Size, weight and height are kept.
      expect(hi.textTheme.labelSmall!.fontSize, theme.textTheme.labelSmall!.fontSize);
      expect(hi.textTheme.labelSmall!.fontWeight, theme.textTheme.labelSmall!.fontWeight);
      // Non-label slots are untouched.
      expect(hi.textTheme.bodyMedium, theme.textTheme.bodyMedium);
    });
  });

  testWidgets('English labels render exactly as before', (tester) async {
    await _pumpLabels(tester, const Locale('en'));

    final section = _text(tester, find.byType(SectionLabel));
    expect(section.data, 'APPEARANCE');
    expect(section.style!.fontFamily, _monoFamily);
    expect(section.style!.letterSpacing, closeTo(10 * 0.08, 1e-9));

    final pill = _text(tester, find.byType(StatusPill));
    expect(pill.data, 'PENDING');
    expect(pill.style!.fontFamily, _monoFamily);
    expect(pill.style!.letterSpacing, closeTo(0.57, 1e-9));

    expect(_text(tester, find.byType(AppChip)).style!.fontFamily, _monoFamily);
  });

  testWidgets('Hindi labels: Devanagari font, no tracking, no uppercase', (tester) async {
    await _pumpLabels(tester, const Locale('hi'));

    for (final (finder, expected) in [
      (find.byType(SectionLabel), 'Appearance'),
      (find.byType(StatusPill), 'Pending'),
      (find.byType(AppChip), 'Rejected'),
    ]) {
      final text = _text(tester, finder);
      expect(text.data, expected, reason: 'no case transform');
      expect(text.style!.fontFamily, _devanagariFamily);
      expect(text.style!.letterSpacing ?? 0, 0);
    }
  });
}
