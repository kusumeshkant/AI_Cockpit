// F06: an expired action never reads as Pending, its decision bar is
// disabled, and a 410 / 409 from the backend updates the screen's state.
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/domain/usecases/decide_action.dart';
import 'package:cockpit/features/actions/domain/usecases/get_action_detail.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_card.dart';

import '../../helpers/action_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockGetDetail extends Mock implements GetActionDetail {}

class _MockDecide extends Mock implements DecideAction {}

class _FakeDetailController extends ActionDetailController {
  _FakeDetailController(this.item) : super(item.id);

  final ActionItem item;

  @override
  Future<ActionItem> build() async => item;
}

AppButton _button(WidgetTester tester, String label) =>
    tester.widget<AppButton>(find.widgetWithText(AppButton, label));

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ActionDecision(actionId: 'x', type: DecisionType.approved, idempotencyKey: 'k'),
    );
  });

  group('ActionItem expiry', () {
    test('a pending action past expiresAt is expired, not pending', () {
      final item = pendingEmail.copyWith(
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      expect(item.isExpired, isTrue);
      expect(item.isPending, isFalse);
    });

    test('a pending action before expiresAt (or without one) is pending', () {
      final later = pendingEmail.copyWith(expiresAt: DateTime.now().add(const Duration(hours: 1)));
      expect(later.isPending, isTrue);
      expect(later.isExpired, isFalse);
      expect(pendingEmail.isPending, isTrue);
    });

    test('status expired is expired regardless of expiresAt', () {
      final item = pendingEmail.copyWith(status: ActionStatus.expired);
      expect(item.isExpired, isTrue);
      expect(item.isPending, isFalse);
    });

    test('a decided action is neither pending nor expired', () {
      expect(approvedLeads.isPending, isFalse);
      expect(approvedLeads.isExpired, isFalse);
    });
  });

  group('expired action UI', () {
    final expired = pendingEmail.copyWith(
      expiresAt: DateTime.now().subtract(const Duration(minutes: 5)),
    );

    testWidgets('feed card shows EXPIRED, not PENDING', (tester) async {
      await pumpApp(tester, Scaffold(body: ActionItemCard(item: expired, onTap: () {})));

      expect(find.text('EXPIRED'), findsOneWidget);
      expect(find.text('PENDING'), findsNothing);
    });

    testWidgets('detail: EXPIRED badge and a disabled decision bar', (tester) async {
      await pumpApp(
        tester,
        ActionDetailScreen(actionId: expired.id),
        overrides: [
          actionDetailControllerProvider(expired.id).overrideWith(() => _FakeDetailController(expired)),
        ],
      );

      expect(find.text('EXPIRED'), findsOneWidget);
      expect(find.text('PENDING'), findsNothing);
      expect(_button(tester, 'Approve').onPressed, isNull);
      expect(_button(tester, 'Reject').onPressed, isNull);
      expect(_button(tester, 'Edit').onPressed, isNull);
    });

    testWidgets('detail: a pending action locks the moment it expires', (tester) async {
      final soon = pendingEmail.copyWith(expiresAt: DateTime.now().add(const Duration(seconds: 2)));
      await pumpApp(
        tester,
        ActionDetailScreen(actionId: soon.id),
        overrides: [
          actionDetailControllerProvider(soon.id).overrideWith(() => _FakeDetailController(soon)),
        ],
      );
      expect(find.text('PENDING'), findsOneWidget);
      expect(_button(tester, 'Approve').onPressed, isNotNull);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('EXPIRED'), findsOneWidget);
      expect(_button(tester, 'Approve').onPressed, isNull);
    });
  });

  group('decision errors update the detail state', () {
    late _MockGetDetail getDetail;
    late _MockDecide decide;

    setUp(() {
      getDetail = _MockGetDetail();
      decide = _MockDecide();
      getIt
        ..registerSingleton<GetActionDetail>(getDetail)
        ..registerSingleton<DecideAction>(decide);
    });

    tearDown(getIt.reset);

    Future<void> pumpReal(WidgetTester tester) =>
        pumpApp(tester, ActionDetailScreen(actionId: pendingEmail.id));

    testWidgets('410 expired: message, EXPIRED badge, buttons disabled', (tester) async {
      when(() => getDetail(pendingEmail.id)).thenAnswer((_) async => Right(pendingEmail));
      when(() => decide(any())).thenAnswer((_) async => const Left(ExpiredFailure()));
      await pumpReal(tester);
      expect(find.text('PENDING'), findsOneWidget);

      await tester.tap(find.text('Approve'));
      await tester.pumpAndSettle();

      expect(find.text('This action has expired and can no longer be decided.'), findsOneWidget);
      expect(find.text('EXPIRED'), findsOneWidget);
      expect(find.text('PENDING'), findsNothing);
      expect(_button(tester, 'Approve').onPressed, isNull);
      expect(_button(tester, 'Reject').onPressed, isNull);
    });

    testWidgets('409 already decided: message, then the real decision is shown', (tester) async {
      final rejected = pendingEmail.copyWith(
        status: ActionStatus.decided,
        decision: DecisionType.rejected,
        decidedAt: DateTime.now(),
      );
      var reads = 0;
      when(() => getDetail(pendingEmail.id))
          .thenAnswer((_) async => Right(reads++ == 0 ? pendingEmail : rejected));
      when(() => decide(any())).thenAnswer((_) async => const Left(ConflictFailure()));
      await pumpReal(tester);

      await tester.tap(find.text('Approve'));
      await tester.pumpAndSettle();

      expect(find.text('This action was already decided.'), findsOneWidget);
      expect(reads, 2, reason: 'the detail is reloaded after 409');
      expect(find.text('REJECTED'), findsWidgets);
      expect(find.text('PENDING'), findsNothing);
      expect(find.widgetWithText(AppButton, 'Approve'), findsNothing);
    });

    testWidgets('other failures keep the action pending (retry possible)', (tester) async {
      when(() => getDetail(pendingEmail.id)).thenAnswer((_) async => Right(pendingEmail));
      when(() => decide(any())).thenAnswer((_) async => const Left(NetworkFailure()));
      await pumpReal(tester);

      await tester.tap(find.text('Approve'));
      await tester.pumpAndSettle();

      expect(find.text('PENDING'), findsOneWidget);
      expect(_button(tester, 'Approve').onPressed, isNotNull);
      verify(() => getDetail(pendingEmail.id)).called(1);
    });
  });
}
