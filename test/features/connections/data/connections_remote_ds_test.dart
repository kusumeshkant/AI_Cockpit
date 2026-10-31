import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/connections/data/datasources/connections_remote_ds.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/domain/entities/callback_delivery.dart';

import '../../../helpers/live_fakes.dart';

void main() {
  setUpAll(registerDioFallbacks);

  late List<Recorded> requests;
  late MockDio dio;
  late SupabaseClient client;

  setUp(() {
    requests = [];
    dio = MockDio();
    client = fakeSupabase(
      (_) => jsonResponse([
        {
          'id': 'g1',
          'name': 'Email agent',
          'platform': 'n8n',
          'callback_url': 'https://n8n.example.com/hook',
          'status': 'active',
          'secret_hint': '3a9f',
          'last_action_at': '2026-09-15T06:00:00Z',
        },
        {
          'id': 'g2',
          'name': 'Support triage',
          'platform': 'custom',
          'callback_url': 'https://support.example.com/hook',
          'status': 'disabled',
          'secret_hint': '09de',
          'last_action_at': null,
        },
      ]),
      requests,
    );
  });

  tearDown(() => client.dispose());

  ConnectionsRemoteDataSourceImpl build() =>
      ConnectionsRemoteDataSourceImpl(client, DioClient.withDio(dio));

  test('listAgents reads agents via REST, newest first', () async {
    final agents = await build().listAgents();

    final uri = requests.single.url;
    expect(uri.path, '/rest/v1/agent');
    expect(
      uri.queryParameters['select']!.split(','),
      containsAll(['id', 'name', 'platform', 'callback_url', 'status', 'secret_hint', 'last_action_at']),
    );
    expect(uri.queryParameters['select'], isNot(contains('inbound_secret_id')));
    expect(uri.queryParameters['order'], 'created_at.desc.nullslast');

    final entities = agents.map((dto) => dto.toEntity()).toList();
    expect(entities.first.platform, AgentPlatform.n8n);
    expect(entities.last.status, AgentStatus.disabled);
  });

  test('createAgent calls agents-create and maps the one-time secret', () async {
    when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
        .thenAnswer(
      (_) async => envelope({
        'agent': {
          'id': 'g9',
          'name': 'Leads bot',
          'platform': 'make',
          'callback_url': 'https://hook.make.com/x',
          'status': 'active',
          'secret_hint': 'AbCd',
          'last_action_at': null,
          'created_at': '2026-09-15T08:00:00Z',
        },
        'inbound_url': 'http://10.0.2.2:54321/functions/v1/actions-inbound',
        'signing_secret': 'whsec_one_time_AbCd',
      }),
    );

    final credentials = (await build().createAgent(
      name: 'Leads bot',
      callbackUrl: 'https://hook.make.com/x',
      platform: AgentPlatform.make,
    ))
        .toEntity();

    final captured = verify(
      () => dio.post<Object?>(captureAny(), data: captureAny(named: 'data'), options: any(named: 'options')),
    ).captured;
    expect(captured[0], '/agents-create');
    expect(captured[1], {
      'name': 'Leads bot',
      'platform': 'make',
      'callback_url': 'https://hook.make.com/x',
    });
    expect(credentials.inboundSecret, 'whsec_one_time_AbCd');
    expect(credentials.inboundUrl, endsWith('/actions-inbound'));
    expect(credentials.agent.platform, AgentPlatform.make);
  });

  test('sendTestAction POSTs agents-test-action with the agent id', () async {
    when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
        .thenAnswer((_) async => envelope({'action_id': 'a-test'}));

    await build().sendTestAction('g1');

    final captured = verify(
      () => dio.post<Object?>(captureAny(), data: captureAny(named: 'data'), options: any(named: 'options')),
    ).captured;
    expect(captured[0], '/agents-test-action');
    expect(captured[1], {'agent_id': 'g1'});
  });

  test('sendTestAction surfaces a 429 as rate limited', () async {
    when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
        .thenThrow(edgeError(429, 'rate_limited', headers: {'retry-after': '30'}));

    expect(
      () => build().sendTestAction('g1'),
      throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'status', 429)),
    );
  });

  group('lastCallback', () {
    late List<Recorded> calls;

    ConnectionsRemoteDataSourceImpl withRows(List<Map<String, dynamic>> rows) {
      calls = [];
      final supabase = fakeSupabase((_) => jsonResponse(rows), calls);
      addTearDown(supabase.dispose);
      return ConnectionsRemoteDataSourceImpl(supabase, DioClient.withDio(dio));
    }

    test('reads the newest callback audit event of the agent', () async {
      final event = await withRows([
        {'event': 'callback_delivered', 'created_at': '2026-10-31T09:00:00Z', 'action': {'agent_id': 'g1'}},
      ]).lastCallback('g1');

      final uri = calls.single.url;
      expect(uri.path, '/rest/v1/audit_entry');
      expect(uri.queryParameters['select'], 'event,created_at,action!inner(agent_id)');
      expect(uri.queryParameters['event'], 'in.("callback_delivered","callback_attempted","callback_failed")');
      expect(uri.queryParameters['action.agent_id'], 'eq.g1');
      expect(uri.queryParameters['order'], 'created_at.desc.nullslast');
      expect(uri.queryParameters['limit'], '1');
      expect(
        event!.toEntity(),
        CallbackDelivery(state: CallbackDeliveryState.delivered, at: DateTime.utc(2026, 10, 31, 9)),
      );
    });

    test('maps attempted to retrying and failed to failed', () async {
      for (final (wire, state) in [
        ('callback_attempted', CallbackDeliveryState.retrying),
        ('callback_failed', CallbackDeliveryState.failed),
      ]) {
        final event = await withRows([
          {'event': wire, 'created_at': '2026-10-31T09:00:00Z'},
        ]).lastCallback('g1');
        expect(event!.toEntity().state, state);
      }
    });

    test('is null before the first callback', () async {
      expect(await withRows(const []).lastCallback('g1'), isNull);
    });
  });
}
