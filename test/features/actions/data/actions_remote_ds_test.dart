import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/actions/data/datasources/action_change_source.dart';
import 'package:cockpit/features/actions/data/datasources/actions_remote_ds.dart';
import 'package:cockpit/features/actions/data/repositories/actions_repository_impl.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';

import '../../../helpers/live_fakes.dart';

class _FakeChanges implements ActionChangeSource {
  final StreamController<void> controller = StreamController<void>.broadcast();

  @override
  Stream<void> changes() => controller.stream;
}

Map<String, dynamic> _row({String id = 'a1', String status = 'pending'}) => {
      'id': id,
      'agent_id': 'g1',
      'type': 'email',
      'title': 'Reply to Priya',
      'summary': 'Refund',
      'payload': {'subject': 'Hi'},
      'editable_fields': ['subject'],
      'status': status,
      'decision': status == 'decided' ? 'approved_with_edits' : null,
      'decided_at': status == 'decided' ? '2026-09-15T07:00:00Z' : null,
      'expires_at': null,
      'created_at': '2026-09-15T06:00:00Z',
      'agent': {'name': 'Email agent', 'platform': 'n8n'},
    };

void main() {
  setUpAll(registerDioFallbacks);

  late List<Recorded> requests;
  late MockDio dio;
  late _FakeChanges changes;
  late SupabaseClient client;
  var rows = <Map<String, dynamic>>[];

  ActionsRemoteDataSourceImpl build({Duration poll = const Duration(hours: 1)}) =>
      ActionsRemoteDataSourceImpl.test(
        client,
        DioClient.withDio(dio),
        changes,
        pollInterval: poll,
        now: () => DateTime.utc(2026, 9, 15, 8),
      );

  setUp(() {
    requests = [];
    rows = [_row(), _row(id: 'a2', status: 'decided')];
    dio = MockDio();
    changes = _FakeChanges();
    client = fakeSupabase((request) {
      final wantsObject = request.headers['Accept']?.contains('vnd.pgrst.object') ?? false;
      return jsonResponse(wantsObject ? rows.first : rows);
    }, requests);
  });

  tearDown(() => client.dispose());

  group('fetchPending', () {
    test('queries pending + recently decided actions with the agent joined', () async {
      final result = await build().fetchPending();

      final uri = requests.single.url;
      expect(uri.path, '/rest/v1/action');
      expect(uri.queryParameters['select'], contains('agent:agent_id(name,platform)'));
      expect(uri.queryParameters['or'], '(status.eq.pending,decided_at.gte.2026-09-14T08:00:00.000Z)');
      expect(uri.queryParameters['order'], 'created_at.desc.nullslast');
      expect(uri.queryParameters['limit'], '100');

      expect(result, hasLength(2));
      final entity = result.first.toEntity();
      expect(entity.agentName, 'Email agent');
      expect(entity.agentPlatform, AgentPlatform.n8n);
      expect(entity.status, ActionStatus.pending);
      expect(result.last.toEntity().decision, DecisionType.approvedWithEdits);
    });

    test('getById requests a single object', () async {
      final dto = await build().getById('a1');

      final request = requests.single;
      expect(request.url.queryParameters['id'], 'eq.a1');
      expect(request.headers['Accept'], contains('vnd.pgrst.object'));
      expect(dto.id, 'a1');
    });
  });

  group('watchPending (TR-4)', () {
    test('emits on subscribe, on every Realtime change and on each poll', () async {
      // Real timers: keep the poll well clear of the event-queue pumps below
      // so a busy machine can't slip an extra poll in between.
      final source = build(poll: const Duration(milliseconds: 300));
      final emissions = <int>[];
      final sub = source.watchPending().listen((items) => emissions.add(items.length));

      await pumpEventQueue();
      expect(emissions, [2], reason: 'initial fetch');

      rows = [_row()];
      changes.controller.add(null);
      await pumpEventQueue();
      expect(emissions, [2, 1], reason: 'realtime change triggers a refetch');

      await Future<void>.delayed(const Duration(milliseconds: 400));
      await pumpEventQueue();
      expect(emissions.length, greaterThanOrEqualTo(3), reason: 'poll reconcile');

      await sub.cancel();
      final countAfterCancel = requests.length;
      await Future<void>.delayed(const Duration(milliseconds: 700));
      expect(requests.length, countAfterCancel, reason: 'poll stops on cancel');
    });

    test('repository turns fetch errors into Left failures', () async {
      client.dispose();
      client = fakeSupabase(
        (_) => jsonResponse({'code': 'PGRST301', 'message': 'JWT expired'}, status: 401),
        requests,
      );
      final repository = ActionsRepositoryImpl(build());

      final first = await repository.watchPendingActions().first;
      expect(first, isA<Left<Failure, List<ActionItem>>>());
      expect(first.fold((failure) => failure, (_) => null), isA<AuthFailure>());
    });
  });

  group('postDecision', () {
    const decision = ActionDecision(
      actionId: 'a1',
      type: DecisionType.approvedWithEdits,
      idempotencyKey: 'key-123456',
      editedPayload: {'subject': 'Re: Hi'},
    );

    test('POSTs actions-decision with the Idempotency-Key header', () async {
      when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => envelope({'decision_recorded': true, 'duplicate': false, 'callback_delivered': true}));

      await build().postDecision(decision);

      final captured = verify(
        () => dio.post<Object?>(captureAny(), data: captureAny(named: 'data'), options: captureAny(named: 'options')),
      ).captured;
      expect(captured[0], '/actions-decision');
      expect(captured[1], {
        'action_id': 'a1',
        'decision': 'approved_with_edits',
        'edited_payload': {'subject': 'Re: Hi'},
      });
      expect((captured[2] as dynamic).headers, {'Idempotency-Key': 'key-123456'});
    });

    for (final (status, code, type) in [
      (409, 'conflict', ConflictFailure),
      (410, 'expired', ExpiredFailure),
      (422, 'validation', ValidationFailure),
      (401, 'unauthorized', AuthFailure),
      (500, 'server', ServerFailure),
    ]) {
      test('maps HTTP $status to $type', () async {
        when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
            .thenThrow(edgeError(status, code));

        final result = await ActionsRepositoryImpl(build()).decide(decision);

        expect(result.fold((failure) => failure.runtimeType, (_) => null), type);
      });
    }

    test('a malformed envelope is a server failure', () async {
      when(() => dio.post<Object?>(any(), data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => envelope({})..data = jsonDecode('{"ok": false}'));

      final result = await ActionsRepositoryImpl(build()).decide(decision);

      expect(result.fold((failure) => failure, (_) => null), isA<ServerFailure>());
    });
  });
}
