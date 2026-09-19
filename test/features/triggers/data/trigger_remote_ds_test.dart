import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Headers;

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/triggers/data/datasources/trigger_remote_ds.dart';
import 'package:cockpit/features/triggers/data/repositories/trigger_repository_impl.dart';

import '../../../helpers/live_fakes.dart';

void main() {
  setUpAll(registerDioFallbacks);

  late List<Recorded> requests;
  late MockDio dio;
  late SupabaseClient client;

  setUp(() {
    requests = [];
    dio = MockDio();
    client = fakeSupabase((request) {
      if (request.url.path.endsWith('/trigger_run')) {
        return jsonResponse([
          {'agent_id': 'g1', 'created_at': '2026-09-19T10:05:00Z'},
          {'agent_id': 'g2', 'created_at': '2026-09-19T09:00:00Z'},
          {'agent_id': 'g1', 'created_at': '2026-09-19T08:00:00Z'},
        ]);
      }
      return jsonResponse([
        {
          'agent_id': 'g1',
          'trigger_url': 'https://n8n.example.com/start',
          'secret_hint': 'abcd',
          'enabled': true,
          'min_interval_secs': 30,
        },
      ]);
    }, requests);
  });

  tearDown(() => client.dispose());

  TriggerRemoteDataSourceImpl build() => TriggerRemoteDataSourceImpl(client, DioClient.withDio(dio));

  List<dynamic> postedTo() => verify(
        () => dio.post<Object?>(captureAny(), data: captureAny(named: 'data'), options: any(named: 'options')),
      ).captured;

  test('listTriggers reads agent_trigger without the Vault secret id', () async {
    final triggers = await build().listTriggers();
    final uri = requests.single.url;
    expect(uri.path, '/rest/v1/agent_trigger');
    expect(uri.queryParameters['select'], isNot(contains('trigger_secret_id')));
    expect(triggers.single.toEntity().secretHint, 'abcd');
  });

  test('lastRuns keeps the newest run per agent', () async {
    final runs = await build().lastRuns();
    expect(requests.single.url.path, '/rest/v1/trigger_run');
    expect(requests.single.url.queryParameters['order'], startsWith('created_at.desc'));
    expect(runs, {
      'g1': DateTime.parse('2026-09-19T10:05:00Z'),
      'g2': DateTime.parse('2026-09-19T09:00:00Z'),
    });
  });

  test('runAgent POSTs agents-trigger with the agent id', () async {
    when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
        .thenAnswer((_) async => envelope({'run_id': 'r1', 'delivered': true, 'detail': 'http_200'}));

    final run = (await build().runAgent('g1')).toEntity();
    final captured = postedTo();
    expect(captured[0], '/agents-trigger');
    expect(captured[1], {'agent_id': 'g1'});
    expect(run.delivered, isTrue);
  });

  test('configureTrigger POSTs action configure and returns the secret once', () async {
    when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
        .thenAnswer((_) async => envelope({
              'trigger': {
                'agent_id': 'g1',
                'trigger_url': 'https://n8n.example.com/start',
                'secret_hint': 'WXYZ',
                'enabled': true,
                'min_interval_secs': 30,
                'updated_at': '2026-09-19T10:00:00Z',
              },
              'trigger_secret': 'whtrig_one_time_WXYZ',
            }));

    final credentials = (await build().configureTrigger(
      agentId: 'g1',
      triggerUrl: 'https://n8n.example.com/start',
    ))
        .toEntity();
    final captured = postedTo();
    expect(captured[0], '/agents-configure-trigger');
    expect(captured[1], {
      'action': 'configure',
      'agent_id': 'g1',
      'trigger_url': 'https://n8n.example.com/start',
    });
    expect(credentials.secret, 'whtrig_one_time_WXYZ');
    expect(credentials.trigger.secretHint, 'WXYZ');
  });

  test('setTriggerEnabled POSTs action set_enabled', () async {
    when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
        .thenAnswer((_) async => envelope({
              'trigger': {
                'agent_id': 'g1',
                'trigger_url': 'https://n8n.example.com/start',
                'secret_hint': 'WXYZ',
                'enabled': false,
                'min_interval_secs': 30,
              },
            }));

    final trigger = (await build().setTriggerEnabled(agentId: 'g1', enabled: false)).toEntity();
    expect(postedTo()[1], {'action': 'set_enabled', 'agent_id': 'g1', 'enabled': false});
    expect(trigger.enabled, isFalse);
  });

  for (final (status, code, type) in [
    (404, 'feature_disabled', FeatureDisabledFailure),
    (409, 'trigger_disabled', TriggerDisabledFailure),
    (429, 'rate_limited', RateLimitedFailure),
    (404, 'not_found', ServerFailure),
  ]) {
    test('repository maps $status $code to $type', () async {
      when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
          .thenThrow(edgeError(status, code, headers: {'retry-after': '17'}));
      final result = await TriggerRepositoryImpl(build()).runAgent('g1');
      final failure = result.fold((f) => f, (_) => null);
      expect(failure.runtimeType, type);
    });
  }

  test('repository.listTriggers combines triggers with last runs', () async {
    final result = await TriggerRepositoryImpl(build()).listTriggers();
    final trigger = result.getOrElse(() => const []).single;
    expect(trigger.lastRunAt, DateTime.parse('2026-09-19T10:05:00Z'));
  });

  test('DioException without a known code keeps the status mapping', () async {
    final error = DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError);
    when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options'))).thenThrow(error);
    final failure = (await TriggerRepositoryImpl(build()).runAgent('g1')).fold((f) => f, (_) => null);
    expect(failure, isA<NetworkFailure>());
  });
}
