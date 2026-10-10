// F25: bottom-navigation labels are at least 11 sp and fit a 320dp phone at
// 1.5x text, in English and Hindi.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_text_styles.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_navigation.dart';
import 'package:cockpit/core/widgets/app_shell.dart';

import '../helpers/pump_app.dart';

Widget _shell(double textScale) => Builder(
      builder: (context) {
        final l10n = context.l10n;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: AppShell(
            items: [
              AppNavItem(icon: AppIcons.tray, label: l10n.navFeed, railLabel: l10n.navFeed, badgeCount: 3),
              AppNavItem(icon: AppIcons.link, label: l10n.navConnectShort, railLabel: l10n.navConnections),
              AppNavItem(icon: AppIcons.list, label: l10n.navAuditShort, railLabel: l10n.navAudit),
              AppNavItem(icon: AppIcons.gear, label: l10n.navSettings, railLabel: l10n.navSettings),
            ],
            currentIndex: 0,
            onSelected: (_) {},
            brandName: l10n.appTitle,
            child: const SizedBox.expand(),
          ),
        );
      },
    );

void main() {
  for (final (label, locale) in const [('en', Locale('en')), ('hi', Locale('hi'))]) {
    testWidgets('labels are >= 11 sp ($label)', (tester) async {
      await pumpApp(tester, _shell(1), locale: locale);

      final labels = tester.widgetList<Text>(
        find.descendant(of: find.byType(AppBottomNav), matching: find.byType(Text)),
      );
      final sized = labels.where((t) => t.style?.fontSize != null).toList();
      expect(sized.length, greaterThanOrEqualTo(4));
      for (final text in sized) {
        expect(text.style!.fontSize, greaterThanOrEqualTo(AppTextStyles.navLabelMinFontSize),
            reason: text.data);
      }
    });

    testWidgets('fits 320dp at 1.5x text ($label)', (tester) async {
      await pumpApp(tester, _shell(1.5), size: narrowPhoneSize, locale: locale);
      expect(find.byType(AppBottomNav), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
