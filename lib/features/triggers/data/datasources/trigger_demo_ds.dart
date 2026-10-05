// Feature: triggers · Layer: data
// In-memory Agent Triggers for demo mode (no backend). The seeded "Email agent"
// has an enabled trigger; runs succeed after a short delay and respect
// min_interval_secs, so the running / started / rate-limited states can be
// explored without a backend.
import 'dart:math';

import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/triggers/data/datasources/trigger_remote_ds.dart';
import 'package:cockpit/features/triggers/data/models/agent_trigger_dto.dart';

/// Demo implementation.
@LazySingleton(as: TriggerRemoteDataSource, env: [AppEnvironments.demo])
class TriggerDemoDataSource implements TriggerRemoteDataSource {
  /// Creates the datasource with the seeded trigger.
  TriggerDemoDataSource()
      : _triggers = {
          'agt_email': const AgentTriggerDto(
            agentId: 'agt_email',
            triggerUrl: 'https://n8n.example.com/webhook/cockpit-run',
            secretHint: '7c2e',
          ),
        },
        _lastRuns = {'agt_email': DateTime.now().subtract(const Duration(minutes: 12))};

  /// Simulated network latency of a run.
  static const Duration runLatency = Duration(milliseconds: 700);

  final Map<String, AgentTriggerDto> _triggers;
  final Map<String, DateTime> _lastRuns;
  final Random _random = Random();

  @override
  Future<List<AgentTriggerDto>> listTriggers() async => List.unmodifiable(_triggers.values);

  @override
  Future<Map<String, DateTime>> lastRuns() async => Map.unmodifiable(_lastRuns);

  @override
  Future<TriggerRunDto> runAgent(String agentId) async {
    final trigger = _triggers[agentId];
    if (trigger == null) throw const ServerFailure('not_found', 404);
    if (!trigger.enabled) throw const TriggerDisabledFailure();
    final last = _lastRuns[agentId];
    final wait = last == null
        ? Duration.zero
        : last.add(Duration(seconds: trigger.minIntervalSecs)).difference(DateTime.now());
    if (wait > Duration.zero) throw RateLimitedFailure('rate_limited', wait);

    await Future<void>.delayed(runLatency);
    _lastRuns[agentId] = DateTime.now();
    return TriggerRunDto(runId: 'run_${_hex(4)}', delivered: true, detail: 'http_200');
  }

  @override
  Future<TriggerCredentialsDto> configureTrigger({
    required String agentId,
    required String triggerUrl,
    int? minIntervalSecs,
  }) async {
    final secret = 'whtrig_${_hex(24)}';
    final trigger = AgentTriggerDto(
      agentId: agentId,
      triggerUrl: triggerUrl,
      secretHint: secret.substring(secret.length - 4),
      enabled: _triggers[agentId]?.enabled ?? true,
      minIntervalSecs: minIntervalSecs ?? 30,
    );
    _triggers[agentId] = trigger;
    return TriggerCredentialsDto(trigger: trigger, triggerSecret: secret);
  }

  @override
  Future<AgentTriggerDto> setTriggerEnabled({
    required String agentId,
    required bool enabled,
  }) async {
    final trigger = _triggers[agentId];
    if (trigger == null) throw const ServerFailure('trigger_not_found', 404);
    return _triggers[agentId] = trigger.copyWith(enabled: enabled);
  }

  String _hex(int bytes) => List.generate(
        bytes,
        (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
}
