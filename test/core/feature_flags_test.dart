import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';
import 'package:cockpit/features/feature_settings/presentation/controllers/feature_settings_controller.dart';

import '../helpers/fakes.dart';
import '../helpers/feature_settings_fakes.dart';

// These depend on the compile-time value: the default-build assertions are
// skipped (not relaxed) under --dart-define=AGENT_TRIGGERS=true, where the
// compile-time branch is checked instead (testWidgets takes a bool skip).
const Object _skipWhenBuiltOn =
    FeatureFlags.agentTriggers ? 'built with --dart-define=AGENT_TRIGGERS=true' : false;

void main() {
  test('Agent Triggers capability is off by default (compile-time)', skip: _skipWhenBuiltOn, () {
    expect(FeatureFlags.agentTriggers, isFalse);
  });

  testWidgets('without the capability the server flag is never read for it', skip: FeatureFlags.agentTriggers,
      (tester) async {
    final get = FakeGetFeatureSettings(
      const Right([FeatureSetting(key: FeatureKeys.agentTriggers, enabled: true)]),
    );
    final container = ProviderContainer(
      overrides: [
        getFeatureSettingsProvider.overrideWithValue(get),
        authControllerProvider.overrideWith(FakeAuthController.new),
      ],
    );
    expect(container.read(agentTriggersProvider), isFalse);
    await tester.pump();
    expect(container.read(agentTriggersProvider), isFalse);
    expect(get.calls, 0, reason: 'flag-off builds stay exactly as before');
    container.dispose();
  });

  testWidgets('built with the capability: on only while the server flag is on', skip: !FeatureFlags.agentTriggers,
      (tester) async {
    final get = FakeGetFeatureSettings(
      const Right([FeatureSetting(key: FeatureKeys.agentTriggers, enabled: false)]),
    );
    final container = ProviderContainer(
      overrides: [
        getFeatureSettingsProvider.overrideWithValue(get),
        authControllerProvider.overrideWith(FakeAuthController.new),
      ],
    );
    container.listen(agentTriggersProvider, (_, _) {});
    await tester.pump();
    expect(container.read(agentTriggersProvider), isFalse, reason: 'server off wins');

    get.next = const Right([FeatureSetting(key: FeatureKeys.agentTriggers, enabled: true)]);
    await container.read(featureSettingsControllerProvider.notifier).refresh();
    expect(container.read(agentTriggersProvider), isTrue);
    container.dispose();
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
