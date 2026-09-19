import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/theme/app_spacing.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_chip.dart';
import 'package:cockpit/features/actions/presentation/widgets/decision_bar.dart';
import 'package:cockpit/features/settings/presentation/widgets/language_tile.dart';

import '../../helpers/pump_app.dart';

const AppSpacing _spacing = AppSpacing();

Finder _button(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(AppButton));

double _width(WidgetTester tester, String label) => tester.getSize(_button(label)).width;

Future<void> _pumpBar(WidgetTester tester, {required Size size, required Locale locale}) => pumpApp(
      tester,
      Scaffold(
        body: const SizedBox.shrink(),
        bottomNavigationBar: DecisionBar(onApprove: () {}, onReject: () {}, onEdit: () {}),
      ),
      size: size,
      locale: locale,
    );

void main() {
  test('maxEditWidth is exactly where Approve would stop being the widest', () {
    const row = 292.0;
    const gap = 9.0;
    final edit = DecisionBar.maxEditWidth(row, gap);
    final approve = (row - 2 * gap - edit) *
        DecisionBar.approveFlex /
        (DecisionBar.rejectFlex + DecisionBar.approveFlex);
    expect(approve, closeTo(edit, 1e-9));
  });

  for (final (name, locale, labels) in [
    ('en', const Locale('en'), ('Reject', 'Edit', 'Approve')),
    ('hi', const Locale('hi'), ('अस्वीकार करें', 'संपादित करें', 'स्वीकृत करें')),
  ]) {
    for (final (sizeName, size) in [('320', narrowPhoneSize), ('390', phoneSize)]) {
      testWidgets('decision bar fits and keeps Approve widest ($name, ${sizeName}px)', (tester) async {
        await _pumpBar(tester, size: size, locale: locale);
        expect(tester.takeException(), isNull, reason: 'no overflow');

        final (reject, edit, approve) = labels;
        expect(_width(tester, edit), greaterThanOrEqualTo(_spacing.editButtonMinWidth));
        expect(_width(tester, approve), greaterThanOrEqualTo(_width(tester, edit) - 1e-6));
        expect(_width(tester, approve), greaterThan(_width(tester, reject)));
      });
    }
  }

  testWidgets('the Edit button grows past its minimum for the Hindi label', (tester) async {
    await _pumpBar(tester, size: phoneSize, locale: const Locale('hi'));
    expect(_width(tester, 'संपादित करें'), greaterThan(_spacing.editButtonMinWidth));
  });

  testWidgets('segment labels share forced line metrics (aligned across scripts)', (tester) async {
    await pumpApp(tester, const Padding(padding: EdgeInsets.all(16), child: LanguageTile()));

    final labels = tester.widgetList<Text>(
      find.descendant(of: find.byType(SegmentedChips<String?>), matching: find.byType(Text)),
    );
    expect(labels, hasLength(3));
    for (final text in labels) {
      expect(text.strutStyle?.forceStrutHeight, isTrue, reason: text.data);
      expect(text.strutStyle?.height, text.style?.height, reason: text.data);
    }
  });
}
