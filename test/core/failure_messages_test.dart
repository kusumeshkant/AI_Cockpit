// F14: a disabled agent or a missing item never reads as an expired session.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/localization/formatters.dart';

import '../helpers/pump_app.dart';

void main() {
  Future<void> pumpMessages(WidgetTester tester, Locale locale) => pumpApp(
    tester,
    Scaffold(
      body: Builder(
        builder: (context) => ListView(
          children: [
            Text(context.failureMessage(const AgentDisabledFailure())),
            Text(context.failureMessage(const NotFoundFailure())),
            Text(context.failureMessage(const AuthFailure())),
          ],
        ),
      ),
    ),
    locale: locale,
  );

  testWidgets('each has its own message (en)', (tester) async {
    await pumpMessages(tester, const Locale('en'));

    expect(
      find.text('This agent is turned off. Turn it back on to use it.'),
      findsOneWidget,
    );
    expect(
      find.text('This item no longer exists. Refresh and try again.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('session'),
      findsOneWidget,
      reason: 'only AuthFailure mentions it',
    );
  });

  testWidgets('each has its own message (hi)', (tester) async {
    await pumpMessages(tester, const Locale('hi'));

    expect(
      find.text('यह एजेंट बंद है। इस्तेमाल करने के लिए इसे फिर से चालू करें।'),
      findsOneWidget,
    );
    expect(
      find.text('यह आइटम अब मौजूद नहीं है। रीफ़्रेश करके फिर कोशिश करें।'),
      findsOneWidget,
    );
  });
}
