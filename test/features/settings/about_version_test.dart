import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/config/app_version.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/settings/presentation/widgets/about_card.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('About shows the installed app version (appVersionProvider, ADR-012)', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(body: AboutCard()),
      overrides: [appVersionProvider.overrideWithValue('1.2.3')],
    );
    expect(find.text('Version 1.2.3'), findsOneWidget);
  });

  testWidgets('StatusPill neutral: muted text on the alternate surface', (tester) async {
    late Color muted;
    late Color surfaceAlt;
    await pumpApp(
      tester,
      Builder(builder: (context) {
        muted = context.colors.muted;
        surfaceAlt = context.colors.surfaceAlt;
        return const Scaffold(body: Center(child: StatusPill(label: 'Not enabled', tone: StatusTone.neutral)));
      }),
    );
    final text = tester.widget<Text>(find.text('NOT ENABLED'));
    expect(text.style?.color, muted);
    final backgrounds = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(StatusPill), matching: find.byType(DecoratedBox)))
        .map((b) => b.decoration as BoxDecoration)
        .where((d) => d.borderRadius != null);
    expect(backgrounds.single.color, surfaceAlt);
  });
}
