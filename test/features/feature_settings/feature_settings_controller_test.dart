import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';
import 'package:cockpit/features/feature_settings/presentation/controllers/feature_settings_controller.dart';

import '../../helpers/fakes.dart';
import '../../helpers/feature_settings_fakes.dart';

const Either<Failure, List<FeatureSetting>> failing = Left(NetworkFailure());

/// Drives the app lifecycle through valid transitions to `resumed`.
void resumeApp(WidgetTester tester) {
  for (final state in [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(state);
  }
}

void main() {
  late FakeGetFeatureSettings get;
  late ProviderContainer container;

  ProviderContainer create({bool capability = true, String version = '0.1.0'}) {
    final c = ProviderContainer(
      overrides: [
        getFeatureSettingsProvider.overrideWithValue(get),
        appVersionProvider.overrideWithValue(version),
        agentTriggersCapabilityProvider.overrideWithValue(capability),
        authControllerProvider.overrideWith(FakeAuthController.new),
      ],
    );
    // Keep the controller alive like CockpitApp does.
    c.listen(featureSettingsControllerProvider, (_, _) {});
    return c;
  }

  bool triggers() => container.read(agentTriggersProvider);
  bool services() => container.read(agentServicesProvider);

  testWidgets('nothing known yet → every flag off (fail closed)', (tester) async {
    get = FakeGetFeatureSettings(failing);
    container = create();
    expect(triggers(), isFalse, reason: 'before the first read');
    await tester.pump();
    expect(container.read(featureSettingsControllerProvider), isNull);
    expect(triggers(), isFalse);
    expect(services(), isFalse);
    container.dispose();
  });

  testWidgets('reads on start; Agent Triggers = capability AND server', (tester) async {
    get = FakeGetFeatureSettings(serverFlags(triggers: true, services: true));
    container = create();
    await tester.pump();
    expect(get.calls, greaterThanOrEqualTo(1));
    expect(triggers(), isTrue);
    expect(services(), isTrue);
    container.dispose();

    container = create(capability: false);
    await tester.pump();
    expect(triggers(), isFalse, reason: 'no compile-time capability');
    expect(services(), isTrue, reason: 'agent services need only the server flag');
    container.dispose();
  });

  testWidgets('a failed refresh keeps the last known value', (tester) async {
    get = FakeGetFeatureSettings(serverFlags(triggers: true));
    container = create();
    await tester.pump();
    expect(triggers(), isTrue);

    get.next = failing;
    await container.read(featureSettingsControllerProvider.notifier).refresh();
    expect(triggers(), isTrue, reason: 'last known value kept');
    container.dispose();
  });

  testWidgets('refreshes when the app resumes', (tester) async {
    get = FakeGetFeatureSettings(serverFlags());
    container = create();
    await tester.pump();
    expect(triggers(), isFalse);
    final before = get.calls;

    get.next = serverFlags(triggers: true);
    resumeApp(tester);
    await tester.pump();
    expect(get.calls, before + 1);
    expect(triggers(), isTrue);
    container.dispose();
  });

  testWidgets('refreshes every ~5 minutes while running', (tester) async {
    get = FakeGetFeatureSettings(serverFlags(triggers: true));
    container = create();
    await tester.pump();
    final before = get.calls;

    get.next = serverFlags();
    await tester.pump(FeatureSettingsController.refreshInterval - const Duration(seconds: 1));
    expect(get.calls, before);
    expect(triggers(), isTrue);
    await tester.pump(const Duration(seconds: 1));
    expect(get.calls, before + 1);
    expect(triggers(), isFalse);
    container.dispose();
  });

  testWidgets('respects min_app_version', (tester) async {
    get = FakeGetFeatureSettings(const Right([
      FeatureSetting(key: FeatureKeys.agentTriggers, enabled: true, minAppVersion: '0.2.0'),
    ]));
    container = create(version: '0.1.9');
    await tester.pump();
    expect(triggers(), isFalse);
    container.dispose();

    container = create(version: '0.2.0');
    await tester.pump();
    expect(triggers(), isTrue);
    container.dispose();
  });

  testWidgets('an unknown key reads as off', (tester) async {
    get = FakeGetFeatureSettings(const Right([]));
    container = create();
    await tester.pump();
    expect(container.read(featureSettingsControllerProvider), isEmpty);
    expect(triggers(), isFalse);
    expect(services(), isFalse);
    container.dispose();
  });
}
