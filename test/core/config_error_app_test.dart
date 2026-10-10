// The screen a mis-built prod release shows instead of demo data.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/widgets/config_error_app.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('explains the missing server settings (en)', (tester) async {
    await pumpApp(tester, const ConfigErrorScreen());

    expect(find.text("This build can't start"), findsOneWidget);
    expect(find.textContaining('missing its server settings'), findsOneWidget);
  });

  testWidgets('is translated (hi) and fits a 320dp phone', (tester) async {
    await pumpApp(
      tester,
      const ConfigErrorScreen(),
      locale: const Locale('hi'),
      size: narrowPhoneSize,
    );

    expect(find.text('यह बिल्ड शुरू नहीं हो सकता'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('runs standalone, without DI or the router', (tester) async {
    await tester.pumpWidget(const ConfigErrorApp());
    await tester.pumpAndSettle();

    expect(find.byType(ConfigErrorScreen), findsOneWidget);
    expect(find.text("This build can't start"), findsOneWidget);
  });
}
