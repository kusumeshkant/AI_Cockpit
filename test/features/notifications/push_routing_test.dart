import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/features/notifications/data/datasources/fcm_message_ds.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';
import 'package:cockpit/features/notifications/presentation/local_notifier.dart';
import 'package:cockpit/features/notifications/presentation/push_router.dart';

void main() {
  group('PushMessage.actionId (payload → route)', () {
    test('an action push points at its action', () {
      expect(const PushMessage(data: {'type': 'action', 'action_id': 'a-1'}).actionId, 'a-1');
    });

    test('other types, missing or empty ids point nowhere', () {
      expect(const PushMessage(data: {'type': 'digest', 'action_id': 'a-1'}).actionId, isNull);
      expect(const PushMessage(data: {'type': 'action'}).actionId, isNull);
      expect(const PushMessage(data: {'type': 'action', 'action_id': ''}).actionId, isNull);
      expect(const PushMessage().actionId, isNull);
    });

    test('fromData keeps string values only', () {
      final message = PushMessage.fromData({'type': 'action', 'action_id': 'a-1', 'n': 3});
      expect(message.data, {'type': 'action', 'action_id': 'a-1'});
    });
  });

  test('an FCM RemoteMessage maps to a PushMessage', () {
    final message = FcmMessageDataSourceImpl.fromRemote(
      const RemoteMessage(
        data: {'type': 'action', 'action_id': 'a-9'},
        notification: RemoteNotification(title: 'Reply to Priya', body: 'Approve a refund'),
      ),
    );
    expect(message.title, 'Reply to Priya');
    expect(message.body, 'Approve a refund');
    expect(message.actionId, 'a-9');
  });

  test('a local notification payload round-trips its data', () {
    expect(FlutterLocalNotifier.decodePayload('{"type":"action","action_id":"a-3"}')?.actionId, 'a-3');
    expect(FlutterLocalNotifier.decodePayload('not json'), isNull);
    expect(FlutterLocalNotifier.decodePayload(null), isNull);
  });

  group('PushRouter', () {
    late GoRouter router;

    setUp(() {
      router = GoRouter(
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
    });

    tearDown(() => router.dispose());

    Future<void> pump(WidgetTester tester) =>
        tester.pumpWidget(MaterialApp.router(routerConfig: router));

    testWidgets('opens the action detail for an action push', (tester) async {
      await pump(tester);

      final handled = PushRouter(router).handle(
        const PushMessage(data: {'type': 'action', 'action_id': 'a-42'}),
      );
      await tester.pumpAndSettle();

      expect(handled, isTrue);
      expect(find.text('detail a-42'), findsOneWidget);
    });

    testWidgets('ignores pushes without a destination', (tester) async {
      await pump(tester);

      final handled = PushRouter(router).handle(const PushMessage(data: {'type': 'digest'}));
      await tester.pumpAndSettle();

      expect(handled, isFalse);
      expect(find.text('feed'), findsOneWidget);
    });
  });
}
