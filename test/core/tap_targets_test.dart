import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/theme/app_spacing.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_chip.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_navigation.dart';
import 'package:cockpit/features/settings/presentation/widgets/theme_mode_tile.dart';

import '../helpers/pump_app.dart';

/// Minimum tap target from the design spec (AppSpacing.minTapTarget).
const double _minTap = 44;

/// The visible surface (Material) of a control, as opposed to its tap box.
Rect _visualRect(WidgetTester tester, Finder control) => tester.getRect(
      find.descendant(of: control, matching: find.byType(Material)).first,
    );

void main() {
  test('the spec minimum is the AppSpacing token', () {
    expect(const AppSpacing().minTapTarget, _minTap);
  });

  testWidgets('AppChip stays compact but is tappable over ≥ 44', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      Center(
        child: AppChip(label: 'Rejected', selected: false, onSelected: () => taps++),
      ),
    );
    final chip = find.byType(AppChip);
    final visual = _visualRect(tester, chip);

    expect(tester.getSize(chip).height, greaterThanOrEqualTo(_minTap));
    expect(visual.height, lessThan(_minTap), reason: 'the pill itself keeps its compact look');

    // Inside the tap box but above the visible pill.
    await tester.tapAt(Offset(visual.center.dx, visual.top - 4));
    expect(taps, 1);

    // Well outside the tap box.
    await tester.tapAt(Offset(visual.center.dx, tester.getRect(chip).top - 20));
    expect(taps, 1);
  });

  testWidgets('segmented chips are tappable over ≥ 44 and keyed', (tester) async {
    await pumpApp(tester, const Padding(padding: EdgeInsets.all(16), child: ThemeModeTile()));

    for (final key in ['themeMode.system', 'themeMode.light', 'themeMode.dark']) {
      final segment = find.byKey(Key(key));
      expect(segment, findsOneWidget, reason: key);
      expect(tester.getSize(segment).height, greaterThanOrEqualTo(_minTap), reason: key);
    }

    final dark = find.byKey(const Key('themeMode.dark'));
    final visual = _visualRect(tester, dark);
    expect(visual.height, const AppSpacing().segmentHeight);

    // A tap just below the visible segment still selects it.
    await tester.tapAt(Offset(visual.center.dx, visual.bottom + 1));
    await tester.pumpAndSettle();
    final selected = tester.widget<Semantics>(
      find.descendant(of: dark, matching: find.byType(Semantics)).first,
    );
    expect(selected.properties.selected, isTrue);
  });

  testWidgets('regular AppButton meets the control height', (tester) async {
    await pumpApp(
      tester,
      Center(child: AppButton(label: 'Connect', icon: AppIcons.plus, onPressed: () {})),
    );
    expect(
      tester.getSize(find.byType(AppButton)).height,
      const AppSpacing().buttonHeight,
    );
    expect(const AppSpacing().buttonHeight, greaterThanOrEqualTo(_minTap));
  });

  testWidgets('bottom-nav items carry stable keys and ≥ 44 targets', (tester) async {
    var tapped = -1;
    await pumpApp(
      tester,
      Scaffold(
        bottomNavigationBar: AppBottomNav(
          currentIndex: 0,
          onSelected: (index) => tapped = index,
          items: const [
            AppNavItem(key: Key('nav.actions'), icon: AppIcons.tray, label: 'Actions', railLabel: 'Actions'),
            AppNavItem(key: Key('nav.connect'), icon: AppIcons.link, label: 'Connect', railLabel: 'Connections'),
            AppNavItem(key: Key('nav.audit'), icon: AppIcons.list, label: 'Audit', railLabel: 'Audit log'),
            AppNavItem(key: Key('nav.settings'), icon: AppIcons.gear, label: 'Settings', railLabel: 'Settings'),
          ],
        ),
        body: const SizedBox.shrink(),
      ),
    );

    for (final key in ['nav.actions', 'nav.connect', 'nav.audit', 'nav.settings']) {
      expect(tester.getSize(find.byKey(Key(key))).height, greaterThanOrEqualTo(_minTap), reason: key);
    }
    await tester.tap(find.byKey(const Key('nav.audit')));
    expect(tapped, 2);
  });
}
