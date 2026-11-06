import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cockpit/app.dart';
import 'package:cockpit/core/config/app_links.dart';
import 'package:cockpit/core/config/app_version.dart';
import 'package:cockpit/core/config/config_providers.dart';
import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/di/providers.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/theme/theme_controller.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_navigation.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/presentation/controllers/agent_services_controller.dart';
import 'package:cockpit/features/agent_services/presentation/screens/service_detail_screen.dart';
import 'package:cockpit/features/agent_services/presentation/widgets/service_consent_sheet.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';

import '../../helpers/agent_services_fakes.dart';
import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

class _FakeConnections extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => const [
        Agent(id: 'a1', name: 'Email agent', platform: AgentPlatform.n8n, callbackUrl: 'https://x.example/cb'),
      ];
}

void main() {
  late FakeServices world;
  final opened = <Uri>[];

  setUp(() {
    world = FakeServices();
    opened.clear();
  });

  List<Override> overrides({bool flag = true, bool? owner = true, String version = '0.1.1'}) => [
        agentServicesProvider.overrideWithValue(flag),
        workspaceOwnerRoleProvider.overrideWithValue(owner),
        appVersionProvider.overrideWithValue(version),
        authControllerProvider.overrideWith(FakeAuthController.new),
        listServicesProvider.overrideWithValue(world.list),
        getServiceAccessProvider.overrideWithValue(world.getAccess),
        enableServiceProvider.overrideWithValue(world.enable),
        disableServiceProvider.overrideWithValue(world.disable),
        connectionsControllerProvider.overrideWith(_FakeConnections.new),
        externalUrlOpenerProvider.overrideWithValue((uri) async {
          opened.add(uri);
          return true;
        }),
      ];

  // ---------------------------------------------------------------------------
  // Connections
  // ---------------------------------------------------------------------------

  testWidgets('Connections, flag off: no Services section and no service reads', (tester) async {
    await pumpApp(tester, const ConnectionsScreen(), overrides: overrides(flag: false));
    expect(find.byKey(const Key('services.section')), findsNothing);
    expect(find.text('Email agent'), findsOneWidget);
    expect(world.listCalls, 0);
  });

  testWidgets('Connections, approver: no Services section', (tester) async {
    await pumpApp(tester, const ConnectionsScreen(), overrides: overrides(owner: false));
    expect(find.byKey(const Key('services.section')), findsNothing);
  });

  testWidgets('Connections, owner + flag: Services section with each service and its status', (tester) async {
    world.access = {'content-creator': const ServiceAccess(serviceSlug: 'content-creator', state: AccessState.active)};
    await pumpApp(tester, const ConnectionsScreen(), overrides: overrides());
    expect(find.byKey(const Key('services.section')), findsOneWidget);
    expect(find.text('SERVICES'), findsOneWidget, reason: 'section labels are upper case');
    expect(find.byKey(const ValueKey('service.content-creator')), findsOneWidget);
    expect(find.byKey(const ValueKey('service.inbox-helper')), findsOneWidget);
    expect(find.bySemanticsLabel('Content creator, Enabled'), findsOneWidget);
    expect(find.bySemanticsLabel('Inbox helper, Not enabled'), findsOneWidget);
    expect(find.text('Email agent'), findsOneWidget, reason: 'agents are still listed');
  });

  testWidgets('Connections with services fits a 320 dp phone', (tester) async {
    await pumpApp(tester, const ConnectionsScreen(), overrides: overrides(), size: narrowPhoneSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('services.section')), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // Service detail
  // ---------------------------------------------------------------------------

  Future<void> openDetail(WidgetTester tester, String slug, {String version = '0.1.1'}) =>
      pumpApp(tester, ServiceDetailScreen(slug: slug), overrides: overrides(version: version));

  testWidgets('not enabled: Enable → consent (button disabled until ticked) → enabled', (tester) async {
    await openDetail(tester, 'inbox-helper');
    expect(find.text('Inbox helper'), findsWidgets);
    expect(find.byKey(const Key('serviceDetail.disable')), findsNothing);
    await tester.tap(find.byKey(const Key('serviceDetail.enable')));
    await tester.pumpAndSettle();

    expect(find.byType(ServiceConsentSheet), findsOneWidget);
    expect(find.text('Before you enable Inbox helper'), findsOneWidget);
    final enable = find.byKey(const Key('consent.enable'));
    expect(tester.widget<AppButton>(enable).onPressed, isNull, reason: 'disabled until ticked');
    await tester.tap(enable);
    await tester.pumpAndSettle();
    expect(world.requestIds, isEmpty);

    await tester.tap(find.byKey(const Key('consent.agree')));
    await tester.pump();
    expect(tester.widget<AppButton>(enable).onPressed, isNotNull);
    await tester.tap(enable);
    await tester.pumpAndSettle();

    expect(world.requestIds, hasLength(1));
    expect(world.access['inbox-helper']?.state, AccessState.active);
    expect(find.text('Service enabled'), findsOneWidget);
    expect(find.byKey(const Key('serviceDetail.ready')), findsOneWidget);
    expect(find.byKey(const Key('serviceDetail.disable')), findsOneWidget);
  });

  testWidgets('consent: cancel enables nothing', (tester) async {
    await openDetail(tester, 'inbox-helper');
    await tester.tap(find.byKey(const Key('serviceDetail.enable')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('consent.cancel')));
    await tester.pumpAndSettle();
    expect(world.requestIds, isEmpty);
    expect(find.byKey(const Key('serviceDetail.enable')), findsOneWidget);
  });

  testWidgets('enabled: Ready, Disable asks first with Cancel focused, then disables', (tester) async {
    world.access = {'content-creator': const ServiceAccess(serviceSlug: 'content-creator', state: AccessState.active)};
    await openDetail(tester, 'content-creator');
    expect(find.byKey(const Key('serviceDetail.ready')), findsOneWidget);
    await tester.tap(find.byKey(const Key('serviceDetail.disable')));
    await tester.pumpAndSettle();

    expect(find.text('Disable Content creator?'), findsOneWidget);
    expect(tester.widget<AppButton>(find.byKey(const Key('serviceDisable.cancel'))).autofocus, isTrue);
    final focused = FocusManager.instance.primaryFocus?.context;
    expect(focused, isNotNull);
    expect(
      find.ancestor(of: find.byWidget(focused!.widget), matching: find.byKey(const Key('serviceDisable.cancel'))),
      findsOneWidget,
      reason: 'the safe choice has focus',
    );

    await tester.tap(find.byKey(const Key('serviceDisable.confirm')));
    await tester.pumpAndSettle();
    expect(world.access['content-creator']?.state, AccessState.disabled);
    expect(find.text('Service disabled'), findsOneWidget);
    expect(find.byKey(const Key('serviceDetail.enable')), findsOneWidget);
  });

  testWidgets('a failure shows a calm message and changes nothing', (tester) async {
    await openDetail(tester, 'inbox-helper');
    world.nextFailure = const AgentUnavailableFailure();
    await tester.tap(find.byKey(const Key('serviceDetail.enable')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('consent.agree')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('consent.enable')));
    await tester.pumpAndSettle();
    expect(find.text("The service isn't reachable right now. Try again in a moment."), findsOneWidget);
    expect(find.byKey(const Key('serviceDetail.enable')), findsOneWidget);
  });

  testWidgets('paused: banner + Disable', (tester) async {
    world.services = [FakeServices.contentCreator.copyWith(status: ServiceStatus.paused)];
    world.access = {'content-creator': const ServiceAccess(serviceSlug: 'content-creator', state: AccessState.active)};
    await openDetail(tester, 'content-creator');
    expect(find.byKey(const Key('serviceDetail.pausedBanner')), findsOneWidget);
    expect(find.byKey(const Key('serviceDetail.disable')), findsOneWidget);
    expect(find.byKey(const Key('serviceDetail.ready')), findsNothing);
  });

  testWidgets('update required: banner + store link, no Enable', (tester) async {
    world.services = [FakeServices.inboxHelper.copyWith(minAppVersion: '9.0.0')];
    await openDetail(tester, 'inbox-helper');
    expect(find.byKey(const Key('serviceDetail.updateBanner')), findsOneWidget);
    expect(find.byKey(const Key('serviceDetail.enable')), findsNothing);
    await tester.tap(find.byKey(const Key('serviceDetail.update')));
    await tester.pump();
    expect(opened, [AppLinks.playStoreListing]);
  });

  testWidgets('blocked access reads exactly as "not available", with no action', (tester) async {
    world.access = {'inbox-helper': const ServiceAccess(serviceSlug: 'inbox-helper', state: AccessState.blocked)};
    await openDetail(tester, 'inbox-helper');
    expect(find.text("This service isn't available for your account."), findsOneWidget);
    expect(find.byKey(const Key('serviceDetail.enable')), findsNothing);
    expect(find.byKey(const Key('serviceDetail.disable')), findsNothing);
  });

  testWidgets('an unknown slug: not listed', (tester) async {
    await openDetail(tester, 'nope');
    expect(find.text('This service is no longer listed.'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // Consent sheet: 320 dp, 1.5× text, semantics
  // ---------------------------------------------------------------------------

  testWidgets('consent sheet: 320 dp at 1.5× text, checkbox semantics, button gated', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpApp(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.5)),
          child: const Scaffold(body: ServiceConsentSheet(serviceName: 'Content creator')),
        ),
      ),
      size: narrowPhoneSize,
    );
    expect(tester.takeException(), isNull, reason: 'no overflow');
    final agree = find.byKey(const Key('consent.agree'));
    await tester.ensureVisible(agree);
    await tester.pumpAndSettle();
    expect(tester.getSize(agree).height, greaterThanOrEqualTo(48));
    expect(
      tester.getSemantics(agree),
      matchesSemantics(
        label: 'I understand and agree',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    expect(tester.widget<AppButton>(find.byKey(const Key('consent.enable'))).onPressed, isNull);
    await tester.tap(agree);
    await tester.pump();
    expect(tester.widget<AppButton>(find.byKey(const Key('consent.enable'))).onPressed, isNotNull);
    semantics.dispose();
  });

  // ---------------------------------------------------------------------------
  // Router: the real app (demo data), pushed above the shell
  // ---------------------------------------------------------------------------

  testWidgets('router: Connections → service detail is pushed above the shell', (tester) async {
    configureDependencies(demo: true);
    addTearDown(getIt.reset);
    tester.view
      ..physicalSize = phoneSize
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(<String, Object>{ThemeController.storageKey: ThemeMode.light.name, 'locale': 'en'});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          agentServicesProvider.overrideWithValue(true),
          workspaceOwnerRoleProvider.overrideWithValue(true),
        ],
        child: const CockpitApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connect'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('services.section')), findsOneWidget);
    expect(find.byType(AppBottomNav), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('service.inbox-helper')));
    await tester.pumpAndSettle();
    expect(find.byType(ServiceDetailScreen), findsOneWidget);
    expect(find.byType(AppBottomNav), findsNothing, reason: 'pushed on the root navigator, above the shell');
    final router = GoRouterLocation.of(tester);
    expect(router, '/connections/services/inbox-helper');
  });
}

/// The router's current path in the pumped app.
abstract final class GoRouterLocation {
  static String of(WidgetTester tester) {
    final context = tester.element(find.byType(ServiceDetailScreen));
    return GoRouterState.of(context).uri.path;
  }
}
