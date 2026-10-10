// Delete account (F02): warning, type-to-confirm, success, failure + retry.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/settings/presentation/screens/delete_account_screen.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

final Finder _field = find.byKey(const ValueKey('delete_account_confirm'));
final Finder _button = find.byKey(const ValueKey('delete_account_button'));
final Finder _list = find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable)).first;

AppButton _deleteButton(WidgetTester tester) => tester.widget<AppButton>(_button);

Widget _textScale(double scale, Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
        child: child,
      ),
    );

void main() {
  late FakeAuthController auth;

  setUp(() => auth = FakeAuthController());

  Future<void> pumpScreen(
    WidgetTester tester, {
    Size size = phoneSize,
    Locale locale = const Locale('en'),
    double textScale = 1,
  }) =>
      pumpApp(
        tester,
        _textScale(textScale, const DeleteAccountScreen()),
        size: size,
        locale: locale,
        overrides: [authControllerProvider.overrideWith(() => auth)],
      );

  test('the email check ignores case and surrounding spaces', () {
    expect(confirmsEmail(' Meera@Clinic.example ', 'meera@clinic.example'), isTrue);
    expect(confirmsEmail('meera@clinic.exampl', 'meera@clinic.example'), isFalse);
    expect(confirmsEmail('', ''), isFalse);
  });

  testWidgets('explains what is deleted, for owners and approvers', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Delete account'), findsOneWidget);
    expect(find.text("This can't be undone"), findsOneWidget);
    expect(find.textContaining('profile and sign-in are deleted'), findsOneWidget);
    expect(find.textContaining('stops getting notifications'), findsOneWidget);
    expect(find.textContaining('If you own the workspace'), findsOneWidget);
    expect(find.textContaining("If you're an approver"), findsOneWidget);
  });

  testWidgets('the button stays disabled until the account email is typed', (tester) async {
    await pumpScreen(tester);
    expect(_deleteButton(tester).onPressed, isNull);

    await tester.enterText(_field, 'someone@else.example');
    await tester.pump();
    expect(_deleteButton(tester).onPressed, isNull);
    expect(find.text("This doesn't match your account email."), findsOneWidget);

    await tester.enterText(_field, 'MEERA@clinic.example');
    await tester.pump();
    expect(_deleteButton(tester).onPressed, isNotNull);
    expect(find.text("This doesn't match your account email."), findsNothing);
    expect(auth.deleteCalls, 0, reason: 'typing never deletes');
  });

  testWidgets('confirming deletes the account and says so', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(_field, 'meera@clinic.example');
    await tester.pump();

    await tester.tap(_button);
    await tester.pumpAndSettle();

    expect(auth.deleteCalls, 1);
    expect(find.text('Your account was deleted.'), findsOneWidget);
    expect(auth.state.value, isNull, reason: 'signed out → the router returns to sign-in');
  });

  testWidgets('a failure is shown and the same button retries', (tester) async {
    auth.deleteFailure = const NetworkFailure();
    await pumpScreen(tester);
    await tester.enterText(_field, 'meera@clinic.example');
    await tester.pump();

    await tester.tap(_button);
    await tester.pumpAndSettle();

    expect(find.textContaining("Your account wasn't deleted."), findsOneWidget);
    expect(_deleteButton(tester).onPressed, isNotNull);

    auth.deleteFailure = null;
    await tester.tap(_button);
    await tester.pumpAndSettle();
    expect(auth.deleteCalls, 2);
    expect(find.text('Your account was deleted.'), findsOneWidget);
  });

  for (final (label, locale) in const [('en', Locale('en')), ('hi', Locale('hi'))]) {
    testWidgets('fits 320dp at 1.5x text ($label)', (tester) async {
      await pumpScreen(tester, size: narrowPhoneSize, locale: locale, textScale: 1.5);
      await tester.scrollUntilVisible(_field, 200, scrollable: _list);
      await tester.enterText(_field, 'meera@clinic.example');
      await tester.pump();
      await tester.scrollUntilVisible(_button, 200, scrollable: _list);

      expect(tester.takeException(), isNull);
      expect(_deleteButton(tester).onPressed, isNotNull);
    });
  }

  testWidgets('is translated (hi)', (tester) async {
    await pumpScreen(tester, locale: const Locale('hi'));

    expect(find.text('अकाउंट डिलीट करें'), findsOneWidget);
    expect(find.text('इसे वापस नहीं किया जा सकता'), findsOneWidget);
  });
}
