import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/auth/presentation/screens/sign_in_screen.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('SignInScreen', () {
    testWidgets('renders brand, headline, email field and CTA', (tester) async {
      await pumpApp(tester, const SignInScreen());

      expect(find.text('Cockpit'), findsOneWidget);
      expect(find.text('CONTROL PANEL FOR AI AGENTS'), findsOneWidget);
      expect(find.text('EMAIL'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Send magic link'), findsOneWidget);
    });

    testWidgets('shows a validation error for an invalid email', (tester) async {
      await pumpApp(tester, const SignInScreen());

      await tester.enterText(find.byType(TextField), 'not-an-email');
      await tester.tap(find.text('Send magic link'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
    });

    group('one-time code step', () {
      late FakeAuthController auth;

      setUp(() => auth = FakeAuthController(null));

      Future<void> sendEmail(WidgetTester tester, {Size size = phoneSize}) async {
        await pumpApp(
          tester,
          const SignInScreen(),
          size: size,
          overrides: [authControllerProvider.overrideWith(() => auth)],
        );
        await tester.enterText(find.byType(TextField), 'meera@clinic.example');
        await tester.tap(find.text('Send magic link'));
        await tester.pumpAndSettle();
      }

      testWidgets('after sending, asks for the code and verifies it', (tester) async {
        await sendEmail(tester);

        expect(auth.signInEmails, ['meera@clinic.example']);
        expect(
          find.text('We sent a sign-in email to meera@clinic.example. Enter the 6-digit code from it.'),
          findsOneWidget,
        );

        await tester.enterText(find.byType(TextField).last, '123456');
        await tester.tap(find.text('Verify code'));
        await tester.pumpAndSettle();

        expect(auth.verifiedCodes, [('meera@clinic.example', '123456')]);
      });

      testWidgets('rejects malformed and wrong codes inline', (tester) async {
        await sendEmail(tester);

        await tester.enterText(find.byType(TextField).last, '12');
        await tester.tap(find.text('Verify code'));
        await tester.pumpAndSettle();
        expect(find.text('Enter the 6-digit code from the email.'), findsOneWidget);
        expect(auth.verifiedCodes, isEmpty);

        auth.verifyFailure = const ValidationFailure();
        await tester.enterText(find.byType(TextField).last, '000000');
        await tester.tap(find.text('Verify code'));
        await tester.pumpAndSettle();
        expect(find.text('Enter the 6-digit code from the email.'), findsOneWidget);
      });

      testWidgets('a send failure keeps the email step and shows a message', (tester) async {
        auth.signInFailure = const NetworkFailure();
        await sendEmail(tester);

        expect(find.text('Verify code'), findsNothing);
        expect(find.text('You appear to be offline. Check your connection.'), findsOneWidget);
      });

      testWidgets('can go back to change the email; lays out at 320px', (tester) async {
        await sendEmail(tester, size: narrowPhoneSize);
        expect(tester.takeException(), isNull);

        await tester.ensureVisible(find.text('Use a different email'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Use a different email'));
        await tester.pumpAndSettle();
        expect(find.text('Send magic link'), findsOneWidget);
      });
    });

    for (final (label, themeMode, locale) in [
      ('light en', ThemeMode.light, const Locale('en')),
      ('dark hi', ThemeMode.dark, const Locale('hi')),
    ]) {
      testWidgets('lays out at 320px without overflow ($label)', (tester) async {
        await pumpApp(
          tester,
          const SignInScreen(),
          size: narrowPhoneSize,
          themeMode: themeMode,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
