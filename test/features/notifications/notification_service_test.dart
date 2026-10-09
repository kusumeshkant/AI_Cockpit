import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';
import 'package:cockpit/features/notifications/domain/repositories/push_repository.dart';
import 'package:cockpit/features/notifications/domain/usecases/register_device.dart';
import 'package:cockpit/features/notifications/presentation/local_notifier.dart';
import 'package:cockpit/features/notifications/presentation/notification_service.dart';
import 'package:cockpit/features/notifications/presentation/push_router.dart';

class _MockPushRepository extends Mock implements PushRepository {}

class _FakeNotifier implements LocalNotifier {
  NotificationChannelText? channel;
  void Function(PushMessage message)? onTap;
  final List<PushMessage> shown = [];

  @override
  Future<void> initialize({
    required NotificationChannelText channel,
    required void Function(PushMessage message) onTap,
  }) async {
    this.channel = channel;
    this.onTap = onTap;
  }

  /// Simulates tapping the [index]th shown notification: the plugin hands
  /// back the JSON payload FlutterLocalNotifier stored with it.
  void tap(int index) =>
      onTap!(FlutterLocalNotifier.decodePayload(jsonEncode(shown[index].data))!);

  @override
  Future<void> show(PushMessage message) async => shown.add(message);
}

const _channel = NotificationChannelText(name: 'Actions', description: 'Review');
const _tapped = PushMessage(data: {'type': 'action', 'action_id': 'a-1'});
const _incoming = PushMessage(title: 'New action', body: 'Review it', data: {'type': 'action', 'action_id': 'a-2'});

void main() {
  late _MockPushRepository repository;
  late _FakeNotifier notifier;
  late StreamController<PushMessage> foreground;
  late StreamController<PushMessage> opened;
  late StreamController<Either<Failure, Unit>> refreshes;
  late NotificationService service;
  late List<PushMessage> openedMessages;

  setUp(() {
    repository = _MockPushRepository();
    notifier = _FakeNotifier();
    foreground = StreamController<PushMessage>.broadcast();
    opened = StreamController<PushMessage>.broadcast();
    refreshes = StreamController<Either<Failure, Unit>>.broadcast();
    openedMessages = [];

    when(() => repository.isAvailable).thenReturn(true);
    when(() => repository.requestPermission()).thenAnswer((_) async => true);
    when(() => repository.registerDevice()).thenAnswer((_) async => const Right(unit));
    when(() => repository.registerOnTokenRefresh()).thenAnswer((_) => refreshes.stream);
    when(() => repository.foregroundMessages()).thenAnswer((_) => foreground.stream);
    when(() => repository.openedMessages()).thenAnswer((_) => opened.stream);

    service = NotificationService(repository, RegisterDevice(repository), notifier);
  });

  tearDown(() async {
    await service.stop();
    await foreground.close();
    await opened.close();
    await refreshes.close();
  });

  Future<void> start() => service.start(channel: _channel, onOpen: openedMessages.add);

  test('start asks permission, registers the token and sets up the channel', () async {
    await start();

    expect(service.isRunning, isTrue);
    expect(notifier.channel, same(_channel));
    verifyInOrder([
      () => repository.requestPermission(),
      () => repository.registerDevice(),
    ]);
  });

  test('a registration failure does not stop push from starting', () async {
    when(() => repository.registerDevice()).thenAnswer((_) async => const Left(NetworkFailure()));
    await start();

    expect(service.isRunning, isTrue);
    foreground.add(_incoming);
    await pumpEventQueue();
    expect(notifier.shown, [_incoming]);
  });

  test('foreground messages are shown; tapped ones are handed to onOpen', () async {
    await start();

    foreground.add(_incoming);
    opened.add(_tapped);
    await pumpEventQueue();

    expect(notifier.shown, [_incoming]);
    expect(openedMessages, [_tapped]);
  });

  test('token refresh failures are absorbed', () async {
    await start();
    refreshes.add(const Left(ServerFailure()));
    await pumpEventQueue();
    expect(service.isRunning, isTrue);
  });

  test('start is idempotent', () async {
    await start();
    await start();
    verify(() => repository.registerDevice()).called(1);
  });

  test('stop unsubscribes: later taps are ignored', () async {
    await start();
    await service.stop();

    opened.add(_tapped);
    await pumpEventQueue();

    expect(service.isRunning, isFalse);
    expect(openedMessages, isEmpty);
  });

  test('a token rotation re-registers through the repository stream', () async {
    await start();
    verify(() => repository.registerOnTokenRefresh()).called(1);
    refreshes.add(const Right(unit));
    await pumpEventQueue();
    expect(service.isRunning, isTrue);
  });

  testWidgets('tapping a foreground notification opens /actions/:id', (tester) async {
    final router = GoRouter(
      initialLocation: RoutePaths.feed,
      routes: [
        GoRoute(
          name: RouteNames.feed,
          path: RoutePaths.feed,
          builder: (_, _) => const Text('feed'),
          routes: [
            GoRoute(
              name: RouteNames.actionDetail,
              path: RoutePaths.actionDetail,
              builder: (_, state) => Text('detail ${state.pathParameters['id']}'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.runAsync(
      () => service.start(channel: _channel, onOpen: PushRouter(router).handle),
    );
    foreground.add(_incoming);
    await tester.runAsync(pumpEventQueue);
    expect(notifier.shown, [_incoming]);

    notifier.tap(0);
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/actions/a-2');
    expect(find.text('detail a-2'), findsOneWidget);
  });

  test('with push unavailable, start does nothing', () async {
    when(() => repository.isAvailable).thenReturn(false);
    await start();

    expect(service.isRunning, isFalse);
    expect(notifier.channel, isNull);
    verifyNever(() => repository.requestPermission());
    verifyNever(() => repository.registerDevice());
  });
}
