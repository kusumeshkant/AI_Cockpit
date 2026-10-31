import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/connections/domain/entities/callback_delivery.dart';
import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart';
import 'package:cockpit/features/connections/domain/usecases/get_last_callback.dart';

class _MockConnectionsRepository extends Mock implements ConnectionsRepository {}

void main() {
  late _MockConnectionsRepository repository;
  late GetLastCallback getLastCallback;

  setUp(() {
    repository = _MockConnectionsRepository();
    getLastCallback = GetLastCallback(repository);
  });

  test('returns the latest delivery for the agent', () async {
    final delivery = CallbackDelivery(
      state: CallbackDeliveryState.delivered,
      at: DateTime.utc(2026, 10, 31, 9),
    );
    when(() => repository.lastCallback('g1')).thenAnswer((_) async => Right(delivery));

    expect(await getLastCallback('g1'), Right<Failure, CallbackDelivery?>(delivery));
    verify(() => repository.lastCallback('g1')).called(1);
  });

  test('returns null before the first callback', () async {
    when(() => repository.lastCallback('g1')).thenAnswer((_) async => const Right(null));

    expect(await getLastCallback('g1'), const Right<Failure, CallbackDelivery?>(null));
  });

  test('passes failures through', () async {
    when(() => repository.lastCallback('g1'))
        .thenAnswer((_) async => const Left(NetworkFailure('offline')));

    expect((await getLastCallback('g1')).isLeft(), isTrue);
  });
}
