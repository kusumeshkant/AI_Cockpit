// Feature: actions · Layer: data
// Live actions: RLS-scoped REST reads, Realtime + 30s poll for the feed
// (TR-4), and decisions via the `actions-decision` Edge Function (dio).
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/actions/data/datasources/action_change_source.dart';
import 'package:cockpit/features/actions/data/models/action_item_dto.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';

/// Remote source for actions.
abstract interface class ActionsRemoteDataSource {
  /// Feed rows (pending + recently decided), re-emitted on every change.
  Stream<List<ActionItemDto>> watchPending();

  /// Fetches feed rows once.
  Future<List<ActionItemDto>> fetchPending();

  /// Fetches one action row.
  Future<ActionItemDto> getById(String id);

  /// POSTs the decision with the `Idempotency-Key` header.
  Future<void> postDecision(ActionDecision decision);
}

/// Supabase + Edge Function implementation.
@LazySingleton(as: ActionsRemoteDataSource, env: [AppEnvironments.live])
class ActionsRemoteDataSourceImpl implements ActionsRemoteDataSource {
  /// Creates the datasource.
  ActionsRemoteDataSourceImpl(this._client, this._functions, this._changes)
      : _pollInterval = defaultPollInterval,
        _now = DateTime.now;

  /// Creates the datasource with a custom poll interval and clock (tests).
  @visibleForTesting
  ActionsRemoteDataSourceImpl.test(
    this._client,
    this._functions,
    this._changes, {
    required Duration pollInterval,
    DateTime Function()? now,
  })  : _pollInterval = pollInterval,
        _now = now ?? DateTime.now;

  /// Poll reconcile interval while the feed is watched (TR-4).
  static const Duration defaultPollInterval = Duration(seconds: 30);

  /// How long decided actions stay in the feed.
  static const Duration decidedWindow = Duration(hours: 24);

  /// Max rows loaded into the feed.
  static const int feedLimit = 100;

  static const String _columns =
      'id, agent_id, type, title, summary, payload, editable_fields, status, '
      'decision, decided_at, expires_at, created_at, agent:agent_id(name, platform)';

  final SupabaseClient _client;
  final DioClient _functions;
  final ActionChangeSource _changes;
  final Duration _pollInterval;
  final DateTime Function() _now;

  @override
  Stream<List<ActionItemDto>> watchPending() {
    StreamSubscription<void>? changeSub;
    Timer? poll;
    var inFlight = false;
    var queued = false;
    late final StreamController<List<ActionItemDto>> controller;

    Future<void> refresh() async {
      if (inFlight) {
        queued = true;
        return;
      }
      inFlight = true;
      try {
        final rows = await fetchPending();
        if (!controller.isClosed) controller.add(rows);
      } catch (error, stack) {
        if (!controller.isClosed) controller.addError(error, stack);
      } finally {
        inFlight = false;
        if (queued && !controller.isClosed) {
          queued = false;
          unawaited(refresh());
        }
      }
    }

    controller = StreamController<List<ActionItemDto>>(
      onListen: () {
        unawaited(refresh());
        changeSub = _changes.changes().listen((_) => refresh());
        poll = Timer.periodic(_pollInterval, (_) => refresh());
      },
      onCancel: () async {
        poll?.cancel();
        await changeSub?.cancel();
      },
    );
    return controller.stream;
  }

  @override
  Future<List<ActionItemDto>> fetchPending() async {
    final since = _now().toUtc().subtract(decidedWindow).toIso8601String();
    final rows = await _client
        .from(DbTables.action)
        .select(_columns)
        .or('status.eq.pending,decided_at.gte.$since')
        .order('created_at', ascending: false)
        .limit(feedLimit);
    return rows.map(_toDto).toList(growable: false);
  }

  @override
  Future<ActionItemDto> getById(String id) async {
    final row = await _client.from(DbTables.action).select(_columns).eq('id', id).single();
    return _toDto(row);
  }

  @override
  Future<void> postDecision(ActionDecision decision) async {
    await _functions.postFunction(
      ApiEndpoints.actionsDecision,
      {
        'action_id': decision.actionId,
        'decision': DecisionWire.encode(decision.type),
        if (decision.editedPayload != null) 'edited_payload': decision.editedPayload,
        if (decision.reason != null) 'reason': decision.reason,
      },
      headers: {'Idempotency-Key': decision.idempotencyKey},
    );
  }

  static ActionItemDto _toDto(Map<String, dynamic> row) {
    final agent = row['agent'];
    return ActionItemDto.fromJson({
      ...row,
      'agent_name': agent is Map ? agent['name'] : null,
      'agent_platform': agent is Map ? agent['platform'] : null,
    });
  }
}
