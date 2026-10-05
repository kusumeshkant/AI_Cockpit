import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/config/feature_flags.dart';

class _FakeRemote implements RemoteFlagSource {
  _FakeRemote(this.value);

  final bool? value;
  final List<String> asked = [];

  @override
  Future<bool?> isEnabled(String key) async {
    asked.add(key);
    return value;
  }
}

Future<bool> _agentTriggers(RemoteFlagSource remote) async {
  final container = ProviderContainer(
    overrides: [remoteFlagSourceProvider.overrideWithValue(remote)],
  );
  addTearDown(container.dispose);
  container.read(agentTriggersProvider); // start the remote read
  await Future<void>.delayed(Duration.zero);
  return container.read(agentTriggersProvider);
}

void main() {
  test('Agent Triggers is off by default (compile-time)', () {
    expect(FeatureFlags.agentTriggers, isFalse);
  });

  test('stays off when the remote flag is unknown or false', () async {
    expect(await _agentTriggers(_FakeRemote(null)), isFalse);
    expect(await _agentTriggers(_FakeRemote(false)), isFalse);
  });

  test('turns on when the remote (PostHog) flag is true', () async {
    final remote = _FakeRemote(true);
    expect(await _agentTriggers(remote), isTrue);
    expect(remote.asked, [RemoteFlagKeys.agentTriggers]);
  });

  test('unconfigured PostHog never touches the plugin and reads as unknown', () async {
    expect(await const PostHogFlagSource(configured: false).isEnabled('agent_triggers'), isNull);
  });

  test('agentTriggersOverride forces the flag for widget tests', () {
    final container = ProviderContainer(overrides: [agentTriggersOverride(enabled: true)]);
    addTearDown(container.dispose);
    expect(container.read(agentTriggersProvider), isTrue);
  });
}
