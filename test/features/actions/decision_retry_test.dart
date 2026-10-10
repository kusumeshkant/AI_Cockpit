// F23: a decision that failed on the network or with a 5xx offers Retry,
// which resends with the same idempotency key; answers about the action
// itself (already decided, expired, invalid…) get no Retry.
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/usecases/decide_action.dart';
import 'package:cockpit/features/actions/domain/usecases/get_action_detail.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';

import '../../helpers/action_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockGetDetail extends Mock implements GetActionDetail {}

class _MockDecide extends Mock implements DecideAction {}

void main() {
  late _MockGetDetail getDetail;
  late _MockDecide decide;
  late List<ActionDecision> sent;

  setUpAll(() {
    registerFallbackValue(
      const ActionDecision(actionId: 'x', type: DecisionType.approved, idempotencyKey: 'k'),
    );
  });

  setUp(() {
    getDetail = _MockGetDetail();
    decide = _MockDecide();
    sent = [];
    when(() => getDetail(pendingEmail.id)).thenAnswer((_) async => Right(pendingEmail));
    getIt
      ..registerSingleton<GetActionDetail>(getDetail)
      ..registerSingleton<DecideAction>(decide);
  });

  tearDown(getIt.reset);

  void answers(List<Failure?> results) {
    var call = 0;
    when(() => decide(any())).thenAnswer((invocation) async {
      sent.add(invocation.positionalArguments.first as ActionDecision);
      final failure = results[call++];
      return failure == null ? const Right(unit) : Left(failure);
    });
  }

  Future<void> approve(WidgetTester tester) async {
    await pumpApp(tester, ActionDetailScreen(actionId: pendingEmail.id));
    await tester.tap(find.text('Approve'));
    await tester.pumpAndSettle();
  }

  final Finder retry = find.widgetWithText(SnackBarAction, 'Retry');

  for (final (label, failure) in [
    ('network error', const NetworkFailure() as Failure),
    ('5xx', const ServerFailure('server', 503)),
    ('server error without a status', const ServerFailure()),
  ]) {
    testWidgets('$label → Retry with the same idempotency key', (tester) async {
      answers([failure, null]);
      await approve(tester);

      expect(retry, findsOneWidget);
      await tester.tap(retry);
      await tester.pumpAndSettle();

      expect(sent, hasLength(2));
      expect(sent[1].idempotencyKey, sent[0].idempotencyKey);
      expect(sent[1].type, DecisionType.approved);
      expect(find.text('Decision recorded'), findsOneWidget);
    });
  }

  for (final (label, failure) in [
    ('409 already decided', const ConflictFailure() as Failure),
    ('410 expired', const ExpiredFailure()),
    ('validation', const ValidationFailure()),
    ('rate limited', const RateLimitedFailure()),
    ('forbidden', const ForbiddenFailure()),
  ]) {
    testWidgets('$label → no Retry', (tester) async {
      answers([failure]);
      await approve(tester);

      expect(retry, findsNothing);
      expect(sent, hasLength(1));
    });
  }

  test('isRetryable', () {
    expect(isRetryable(const NetworkFailure()), isTrue);
    expect(isRetryable(const ServerFailure('server', 500)), isTrue);
    expect(isRetryable(const ServerFailure('server', 404)), isFalse);
    expect(isRetryable(const ConflictFailure()), isFalse);
    expect(isRetryable(const ExpiredFailure()), isFalse);
    expect(isRetryable(const AuthFailure()), isFalse);
  });
}
