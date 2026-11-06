import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/config/app_version.dart';
import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/agent_services/data/datasources/agent_gateway_client.dart';
import 'package:cockpit/features/agent_services/data/datasources/agent_services_ds.dart';
import 'package:cockpit/features/agent_services/data/models/agent_service_dto.dart';
import 'package:cockpit/features/agent_services/data/repositories/agent_services_repository_impl.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/domain/repositories/agent_services_repository.dart';
import 'package:cockpit/features/agent_services/domain/usecases/agent_services_usecases.dart';

/// Answers every request with [respond]; records what was sent.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.respond);

  final ResponseBody Function(RequestOptions options) respond;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(Object body, int status, {Map<String, List<String>> headers = const {}}) => ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...headers,
      },
    );

class _FixedVersion implements AppVersionSource {
  @override
  Future<String> version() async => '0.1.1';
}

class _MockRepository extends Mock implements AgentServicesRepository {}

({AgentGatewayClient client, FakeAdapter adapter}) gateway(ResponseBody Function(RequestOptions o) respond) {
  final adapter = FakeAdapter(respond);
  final dio = Dio(BaseOptions(baseUrl: 'https://cockpit.example/functions/v1', contentType: Headers.jsonContentType))
    ..httpClientAdapter = adapter;
  return (client: AgentGatewayClient(DioClient.withDio(dio), _FixedVersion()), adapter: adapter);
}

Map<String, dynamic> okEnvelope(Object? result, Map<String, dynamic> meta) => {
      'ok': true,
      'data': {'result': result, 'meta': meta},
    };

Map<String, dynamic> errEnvelope(String code, {Object? details}) => {
      'ok': false,
      'error': {'code': code, 'message': 'SERVICE DETAIL TEXT', 'details': ?details},
    };

void main() {
  group('DTO parsing is tolerant', () {
    test('agent_service: full row', () {
      final s = agentServiceFromJson({
        'slug': 'content-creator',
        'display_name': 'Content creator',
        'description': 'Drafts posts',
        'icon': 'sparkles',
        'status': 'paused',
        'contract_version': '1.0',
        'min_app_version': '0.2.0',
        'ui': 'native',
        'ui_schema_version': 2,
        'extra_column': 'ignored',
      });
      expect(s.status, ServiceStatus.paused);
      expect(s.ui, ServiceUi.native);
      expect(s.minAppVersion, '0.2.0');
      expect(s.uiSchemaVersion, 2);
    });

    test('agent_service: nulls, unknown enums and missing optionals fall back', () {
      final s = agentServiceFromJson({'slug': 'x', 'status': 'draft', 'ui': 'web', 'ui_schema_version': null});
      expect(s.displayName, 'x');
      expect(s.description, '');
      expect(s.icon, isNull);
      expect(s.status, ServiceStatus.unknown);
      expect(s.ui, ServiceUi.unknown);
      expect(s.uiSchemaVersion, 1);
      expect(() => agentServiceFromJson({'display_name': 'no slug'}), throwsA(anything));
    });

    test('service_access: unknown state → unknown; dates parsed; slug from the caller', () {
      final a = serviceAccessFromJson({
        'service_slug': 's',
        'state': 'frozen',
        'consented_at': '2026-11-01T10:00:00Z',
        'first_used_at': null,
      });
      expect(a.state, AccessState.unknown);
      expect(a.consentedAt, DateTime.utc(2026, 11, 1, 10));
      expect(a.firstUsedAt, isNull);
      expect(serviceAccessFromJson({'state': 'active'}, slug: 'from-call').serviceSlug, 'from-call');
    });

    test('gateway answer: result untouched, meta type-checked', () {
      final r = gatewayResponseFromJson({
        'result': {'ideas': [1, 2]},
        'meta': {
          'request_id': 'req-1',
          'usage': {'used': 3, 'limit': 10, 'trial_ends_at': null},
          'poll_after_ms': 250,
          'version': 'v2',
          'other': 'dropped',
        },
      }, accepted: true);
      expect(r.result, {'ideas': [1, 2]});
      expect(r.accepted, isTrue);
      expect(r.meta.requestId, 'req-1');
      expect(r.meta.usage, const ServiceUsage(used: 3, limit: 10));
      expect(r.meta.pollAfter, const Duration(milliseconds: 250));
      final loose = gatewayResponseFromJson({
        'result': null,
        'meta': {'request_id': 'r', 'usage': {'used': 'x'}, 'poll_after_ms': -5},
      }, accepted: false);
      expect(loose.meta.usage, isNull);
      expect(loose.meta.pollAfter, isNull);
    });
  });

  group('AgentGatewayClient', () {
    test('sends service / op / params, X-App-Version and the caller\'s Idempotency-Key', () async {
      final g = gateway((_) => jsonBody(okEnvelope({'ok': 1}, {'request_id': 'key-123'}), 200));
      final r = await g.client.call(service: 'svc', op: 'brand.save', params: {'brand': 'x'}, requestId: 'key-123');
      final sent = g.adapter.requests.single;
      expect(sent.path, endsWith('/agent-proxy'));
      expect(sent.data, {'service': 'svc', 'op': 'brand.save', 'params': {'brand': 'x'}});
      expect(sent.headers['X-App-Version'], '0.1.1');
      expect(sent.headers['Idempotency-Key'], 'key-123');
      expect(r.accepted, isFalse);
      expect(r.result, {'ok': 1});
    });

    test('a read without a request id sends no Idempotency-Key (the client never invents one)', () async {
      final g = gateway((_) => jsonBody(okEnvelope([], {'request_id': 'server-made'}), 200));
      await g.client.call(service: 'svc', op: 'ideas.list');
      expect(g.adapter.requests.single.headers.containsKey('Idempotency-Key'), isFalse);
      expect(g.adapter.requests.single.data, {'service': 'svc', 'op': 'ideas.list'});
    });

    test('the same id is reused when the caller retries the same action', () async {
      var calls = 0;
      final g = gateway((_) => ++calls == 1
          ? jsonBody(errEnvelope('agent_unavailable'), 503, headers: {'retry-after': ['5']})
          : jsonBody(okEnvelope({}, {'request_id': 'a1'}), 200));
      await expectLater(g.client.call(service: 's', op: 'w', requestId: 'a1'), throwsA(isA<DioException>()));
      await g.client.call(service: 's', op: 'w', requestId: 'a1');
      expect(g.adapter.requests.map((r) => r.headers['Idempotency-Key']), ['a1', 'a1']);
    });

    test('HTTP 202 is a success and is distinguishable', () async {
      final g = gateway((_) => jsonBody(okEnvelope({'job_id': 'j'}, {'request_id': 'r', 'poll_after_ms': 500}), 202));
      final r = await g.client.call(service: 's', op: 'idea.generate', requestId: 'r');
      expect(r.accepted, isTrue);
      expect(r.meta.pollAfter, const Duration(milliseconds: 500));
    });

    test('if_match is sent only when given', () async {
      final g = gateway((_) => jsonBody(okEnvelope({}, {'request_id': 'r'}), 200));
      await g.client.call(service: 's', op: 'o', ifMatch: 'v3', requestId: 'r');
      expect((g.adapter.requests.single.data as Map)['if_match'], 'v3');
    });
  });

  group('error mapping for every gateway code', () {
    Future<Failure> failureFor(Map<String, dynamic> body, int status, {Map<String, List<String>> headers = const {}}) async {
      final g = gateway((_) => jsonBody(body, status, headers: headers));
      try {
        await g.client.call(service: 's', op: 'o', requestId: 'r');
      } on DioException catch (e) {
        return mapDioException(e);
      }
      fail('expected a failure');
    }

    final cases = <(String, int, Type)>[
      ('agent_unavailable', 503, AgentUnavailableFailure),
      ('agent_timeout', 504, AgentTimeoutFailure),
      ('agent_error', 502, AgentErrorFailure),
      ('agent_paused', 503, AgentPausedFailure),
      ('trial_ended', 403, TrialEndedFailure),
      ('quota_reached', 403, QuotaReachedFailure),
      ('approval_blocked', 422, ApprovalBlockedFailure),
      ('unsupported_op', 422, UnsupportedOpFailure),
      ('app_update_required', 426, AppUpdateRequiredFailure),
      ('service_not_found', 404, ServiceNotFoundFailure),
      ('service_not_enabled', 403, ServiceNotEnabledFailure),
      ('feature_disabled', 404, FeatureDisabledFailure),
      ('rate_limited', 429, RateLimitedFailure),
    ];
    for (final (code, status, type) in cases) {
      test('$code ($status) → $type', () async {
        final failure = await failureFor(errEnvelope(code), status);
        expect(failure.runtimeType, type);
        expect(failure.message, isNot(contains('SERVICE DETAIL')), reason: 'no service text');
      });
    }

    test('agent_unavailable carries Retry-After; rate_limited too', () async {
      final unavailable = await failureFor(errEnvelope('agent_unavailable'), 503, headers: {'retry-after': ['7']});
      expect((unavailable as AgentUnavailableFailure).retryAfter, const Duration(seconds: 7));
      final limited = await failureFor(errEnvelope('rate_limited'), 429, headers: {'retry-after': ['42']});
      expect((limited as RateLimitedFailure).retryAfter, const Duration(seconds: 42));
    });

    test('conflict with details.code idea_final → IdeaFinalFailure; plain conflict unchanged', () async {
      expect(await failureFor(errEnvelope('conflict', details: {'code': 'idea_final'}), 409), isA<IdeaFinalFailure>());
      expect(await failureFor(errEnvelope('conflict'), 409), isA<ConflictFailure>());
    });

    test('retryable: unavailable / timeout yes; trial / quota / agent_error no', () {
      expect(isRetryable(const AgentUnavailableFailure()), isTrue);
      expect(isRetryable(const AgentTimeoutFailure()), isTrue);
      expect(isRetryable(const TrialEndedFailure()), isFalse);
      expect(isRetryable(const QuotaReachedFailure()), isFalse);
      expect(isRetryable(const AgentErrorFailure()), isFalse);
    });
  });

  group('repository + use cases', () {
    test('the demo datasource seeds one enabled and one not-enabled service', () async {
      final demo = AgentServicesDemoDataSource();
      final services = await demo.fetchServices();
      final access = await demo.fetchAccess();
      expect(services, hasLength(2));
      expect(access.single.state, AccessState.active);
      expect((await demo.enable('inbox-helper', 'v1', 'r')).state, AccessState.active);
      expect((await demo.disable('inbox-helper', 'r')).state, AccessState.disabled);
    });

    test('the repository maps datasource errors to Failures (never throws)', () async {
      final repo = AgentServicesRepositoryImpl(_ThrowingSource());
      expect((await repo.listServices()).isLeft(), isTrue);
      final enable = await repo.enableService(slug: 's', consentVersion: 'v1', requestId: 'r');
      expect(enable.fold((f) => f, (_) => null), isA<Failure>());
    });

    test('use cases delegate to the repository', () async {
      final repo = _MockRepository();
      const access = ServiceAccess(serviceSlug: 's', state: AccessState.active);
      when(repo.listServices).thenAnswer((_) async => const Right([]));
      when(repo.listAccess).thenAnswer((_) async => const Right([access]));
      when(() => repo.enableService(slug: 's', consentVersion: 'v1', requestId: 'r1'))
          .thenAnswer((_) async => const Right(access));
      when(() => repo.disableService(slug: 's', requestId: 'r2'))
          .thenAnswer((_) async => const Right(access));
      expect(await ListServices(repo)(), const Right<Failure, List<AgentService>>([]));
      expect(await GetServiceAccess(repo)(), const Right<Failure, List<ServiceAccess>>([access]));
      expect(await EnableService(repo)(slug: 's', consentVersion: 'v1', requestId: 'r1'), const Right<Failure, ServiceAccess>(access));
      expect(await DisableService(repo)(slug: 's', requestId: 'r2'), const Right<Failure, ServiceAccess>(access));
      verify(() => repo.enableService(slug: 's', consentVersion: 'v1', requestId: 'r1')).called(1);
    });
  });
}

class _ThrowingSource implements AgentServicesDataSource {
  @override
  Future<List<AgentService>> fetchServices() => throw DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError);

  @override
  Future<List<ServiceAccess>> fetchAccess() => throw StateError('x');

  @override
  Future<ServiceAccess> enable(String slug, String consentVersion, String requestId) =>
      throw DioException(requestOptions: RequestOptions(), type: DioExceptionType.receiveTimeout);

  @override
  Future<ServiceAccess> disable(String slug, String requestId) => throw StateError('x');
}
