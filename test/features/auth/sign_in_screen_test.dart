import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/clock.dart';
import 'package:cockpit/features/auth/domain/auth_constants.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/auth/presentation/screens/sign_in_screen.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

final Finder _code = find.byKey(const ValueKey('sign_in_code'));
final Finder _resend = find.byKey(const ValueKey('sign_in_resend'));

Widget _textScale(double scale, Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
        child: child,
      ),
    );

void main() {
  group('SignInScreen', () {
    testWidgets('renders brand, headline, email field and CTA', (tester) async {
      await pumpApp(tester, const SignInScreen());

      expect(find.text('AI Cockpit'), findsOneWidget);
      expect(find.text('CONTROL PANEL FOR AI AGENTS'), findsOneWidget);
      expect(find.text('EMAIL'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Email me a code'), findsOneWidget);
      expect(find.textContaining('a $otpLength-digit code'), findsOneWidget,
          reason: 'the copy talks about a code, not a magic link');
    });

    testWidgets('shows a validation error for an invalid email', (tester) async {
      await pumpApp(tester, const SignInScreen());

      await tester.enterText(find.byType(TextField), 'not-an-email');
      await tester.tap(find.text('Email me a code'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
    });

    group('one-time code step', () {
      late FakeAuthController auth;
      late DateTime now;

      setUp(() {
        auth = FakeAuthController(null);
        now = DateTime(2026, 10, 10, 9);
      });

      List<Override> overrides() => [
            authControllerProvider.overrideWith(() => auth),
            clockProvider.overrideWithValue(() => now),
          ];

      Future<void> sendEmail(
        WidgetTester tester, {
        Size size = phoneSize,
        Locale locale = const Locale('en'),
        double textScale = 1,
      }) async {
        await pumpApp(
          tester,
          _textScale(textScale, const SignInScreen()),
          size: size,
          locale: locale,
          overrides: overrides(),
        );
        await tester.enterText(find.byType(TextField), 'meera@clinic.example');
        await tester.testTextInput.receiveAction(TextInputAction.go);
        await tester.pump();
        await tester.pump();
      }

      Future<void> advance(WidgetTester tester, Duration by) async {
        now = now.add(by);
        await tester.pump(const Duration(seconds: 1));
      }

      testWidgets('says how long the code is and how long it is valid', (tester) async {
        await sendEmail(tester);

        expect(auth.signInEmails, ['meera@clinic.example']);
        expect(
          find.text(
            'We sent a $otpLength-digit code to meera@clinic.example. '
            "It's valid for ${otpValidity.inMinutes} minutes.",
          ),
          findsOneWidget,
        );
      });

      testWidgets('auto-verifies once every digit is in, exactly once', (tester) async {
        await sendEmail(tester);

        await tester.enterText(_code, '12345');
        await tester.pump();
        expect(auth.verifiedCodes, isEmpty, reason: 'not all digits yet');

        auth.verifyGate = Completer<void>();
        await tester.enterText(_code, '123456');
        await tester.pump();
        // While the first verify is in flight, every other trigger is ignored.
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.enterText(_code, '123456');
        await tester.pump();
        auth.verifyGate!.complete();
        await tester.pumpAndSettle();

        expect(auth.verifiedCodes, [('meera@clinic.example', '123456')],
            reason: 'the submitting lock blocks a second verify');
      });

      testWidgets('a pasted code with spaces or dashes is cleaned and verified', (tester) async {
        await sendEmail(tester);

        await tester.enterText(_code, '123 456');
        await tester.pump();
        expect(auth.verifiedCodes, [('meera@clinic.example', '123456')]);

        auth.verifiedCodes.clear();
        auth.verifyFailure = const ValidationFailure();
        await tester.enterText(_code, 'code: 654-321 (expires in 60)');
        await tester.pump();
        expect(auth.verifiedCodes, [('meera@clinic.example', '654321')],
            reason: 'digits only, cut at the code length');
      });

      testWidgets('a short code and a rejected code get different messages', (tester) async {
        await sendEmail(tester);

        await tester.enterText(_code, '12');
        await tester.tap(find.text('Verify code'));
        await tester.pumpAndSettle();
        expect(find.text('Enter all $otpLength digits.'), findsOneWidget);
        expect(auth.verifiedCodes, isEmpty);

        auth.verifyFailure = const ValidationFailure();
        await tester.enterText(_code, '000000');
        await tester.pumpAndSettle();
        expect(
          find.text('That code is wrong or has expired. Check the latest email or send a new code.'),
          findsOneWidget,
        );
        final field = tester.widget<TextField>(find.descendant(of: _code, matching: find.byType(TextField)));
        expect(field.decoration!.errorMaxLines, greaterThan(1), reason: 'the whole sentence is shown');
        expect(field.controller!.text, isEmpty, reason: 'cleared so the next code can be typed');
      });

      testWidgets('resend waits for the cooldown, then sends again', (tester) async {
        await sendEmail(tester);

        expect(find.text('Resend code in 1:00'), findsOneWidget);
        await tester.ensureVisible(_resend);
        await tester.tap(_resend);
        await tester.pump();
        expect(auth.signInEmails, hasLength(1), reason: 'disabled during the cooldown');

        await advance(tester, const Duration(seconds: 20));
        expect(find.text('Resend code in 0:40'), findsOneWidget);

        await advance(tester, otpResendCooldown);
        expect(find.text('Resend code'), findsOneWidget);
        await tester.tap(_resend);
        await tester.pump();
        await tester.pump();

        expect(auth.signInEmails, ['meera@clinic.example', 'meera@clinic.example']);
        expect(find.text('We sent a new code.'), findsOneWidget);
        expect(find.text('Resend code in 1:00'), findsOneWidget, reason: 'the cooldown restarts');
      });

      testWidgets('a rate-limited resend explains it and keeps waiting', (tester) async {
        await sendEmail(tester);
        await advance(tester, otpResendCooldown);

        auth.signInFailure = const RateLimitedFailure('over_email_send_rate_limit');
        await tester.ensureVisible(_resend);
        await tester.tap(_resend);
        await tester.pump();
        await tester.pump();

        expect(find.text('Too many codes requested. Try again in a few minutes.'), findsOneWidget);
        expect(find.textContaining('Resend code in'), findsOneWidget);
      });

      testWidgets('a send failure keeps the email step and shows a message', (tester) async {
        auth.signInFailure = const NetworkFailure();
        await sendEmail(tester);

        expect(find.text('Verify code'), findsNothing);
        expect(find.text('You appear to be offline. Check your connection.'), findsOneWidget);
      });

      testWidgets('Change email goes back; the same email does not resend early', (tester) async {
        await sendEmail(tester);

        await tester.ensureVisible(find.text('Change email'));
        await tester.tap(find.text('Change email'));
        await tester.pumpAndSettle();
        expect(find.text('Email me a code'), findsOneWidget);

        await tester.tap(find.text('Email me a code'));
        await tester.pump();
        await tester.pump();
        expect(auth.signInEmails, hasLength(1), reason: 'a code for this address is on its way');
        expect(find.text('Verify code'), findsOneWidget);

        await tester.ensureVisible(find.text('Change email'));
        await tester.tap(find.text('Change email'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'other@clinic.example');
        await tester.tap(find.text('Email me a code'));
        await tester.pump();
        await tester.pump();
        expect(auth.signInEmails, ['meera@clinic.example', 'other@clinic.example'],
            reason: 'a different address may send at once');
      });

      for (final (label, locale) in const [('en', Locale('en')), ('hi', Locale('hi'))]) {
        testWidgets('code step fits 320dp at 1.5x text ($label)', (tester) async {
          await sendEmail(tester, size: narrowPhoneSize, locale: locale, textScale: 1.5);

          expect(tester.takeException(), isNull);
          expect(_resend, findsOneWidget);
        });
      }

      testWidgets('code step is translated (hi)', (tester) async {
        await sendEmail(tester, locale: const Locale('hi'));

        expect(find.text('ईमेल बदलें'), findsOneWidget);
        expect(find.text('1:00 में कोड दोबारा भेजें'), findsOneWidget);
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
