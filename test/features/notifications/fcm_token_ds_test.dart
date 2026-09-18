import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/features/notifications/data/datasources/fcm_token_ds.dart';

import '../../helpers/live_fakes.dart';

class _MockMessaging extends Mock implements FirebaseMessaging {}

void main() {
  late List<Recorded> requests;
  late SupabaseClient client;
  late _MockMessaging messaging;

  setUp(() {
    requests = [];
    client = fakeSupabase((_) => http.Response('', 204), requests);
    messaging = _MockMessaging();
  });

  tearDown(() => client.dispose());

  FcmTokenDataSourceImpl build({bool available = true}) => FcmTokenDataSourceImpl.test(
        client,
        messaging: () => messaging,
        available: () => available,
      );

  test('registerToken calls rpc/register_fcm_token with the token', () async {
    await build().registerToken('device-token-1');

    final request = requests.single;
    expect(request.method, 'POST');
    expect(request.url.path, '/rest/v1/rpc/register_fcm_token');
    expect(jsonDecode(request.body), {'p_token': 'device-token-1'});
  });

  test('unregisterToken calls rpc/unregister_fcm_token', () async {
    await build().unregisterToken('device-token-1');

    expect(requests.single.url.path, '/rest/v1/rpc/unregister_fcm_token');
    expect(jsonDecode(requests.single.body), {'p_token': 'device-token-1'});
  });

  test('getToken reads the FCM token when Firebase is ready', () async {
    when(() => messaging.getToken()).thenAnswer((_) async => 'fcm-token');
    expect(await build().getToken(), 'fcm-token');
  });

  test('without Firebase, nothing touches FirebaseMessaging', () async {
    final source = build(available: false);

    expect(source.isAvailable, isFalse);
    expect(await source.getToken(), isNull);
    expect(await source.requestPermission(), isFalse);
    expect(await source.onTokenRefresh().isEmpty, isTrue);
    verifyZeroInteractions(messaging);
  });
}
