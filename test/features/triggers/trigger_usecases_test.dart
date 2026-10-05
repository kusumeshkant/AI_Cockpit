import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/repositories/trigger_repository.dart';
import 'package:cockpit/features/triggers/domain/usecases/configure_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/list_agent_triggers.dart';
import 'package:cockpit/features/triggers/domain/usecases/run_agent.dart';
import 'package:cockpit/features/triggers/domain/usecases/set_trigger_enabled.dart';

class _MockTriggerRepository extends Mock implements TriggerRepository {}

const _trigger = AgentTrigger(
  agentId: 'g1',
  triggerUrl: 'https://n8n.example.com/start',
  secretHint: 'abcd',
  enabled: true,
  minIntervalSecs: 30,
);

void main() {
  late _MockTriggerRepository repository;

  setUp(() => repository = _MockTriggerRepository());

  test('ListAgentTriggers delegates', () async {
    when(() => repository.listTriggers()).thenAnswer((_) async => const Right([_trigger]));
    expect(await ListAgentTriggers(repository)(), const Right<Failure, List<AgentTrigger>>([_trigger]));
  });

  test('RunAgent starts the given agent and passes failures through', () async {
    const run = TriggerRun(runId: 'r1', delivered: true, detail: 'http_200');
    when(() => repository.runAgent('g1')).thenAnswer((_) async => const Right(run));
    expect(await RunAgent(repository)('g1'), const Right<Failure, TriggerRun>(run));

    when(() => repository.runAgent('g2')).thenAnswer((_) async => const Left(TriggerDisabledFailure()));
    expect((await RunAgent(repository)('g2')).fold((f) => f, (_) => null), isA<TriggerDisabledFailure>());
  });

  test('ConfigureTrigger trims the URL and forwards the interval', () async {
    const credentials = TriggerCredentials(trigger: _trigger, secret: 'whtrig_x');
    when(() => repository.configureTrigger(
          agentId: any(named: 'agentId'),
          triggerUrl: any(named: 'triggerUrl'),
          minIntervalSecs: any(named: 'minIntervalSecs'),
        )).thenAnswer((_) async => const Right(credentials));

    await ConfigureTrigger(repository)(
      agentId: 'g1',
      triggerUrl: '  https://n8n.example.com/start ',
      minIntervalSecs: 60,
    );
    verify(() => repository.configureTrigger(
          agentId: 'g1',
          triggerUrl: 'https://n8n.example.com/start',
          minIntervalSecs: 60,
        )).called(1);
  });

  test('SetTriggerEnabled delegates', () async {
    when(() => repository.setTriggerEnabled(agentId: 'g1', enabled: false))
        .thenAnswer((_) async => Right(_trigger.copyWith(enabled: false)));
    final result = await SetTriggerEnabled(repository)(agentId: 'g1', enabled: false);
    expect(result.fold((_) => null, (t) => t.enabled), isFalse);
  });
}
