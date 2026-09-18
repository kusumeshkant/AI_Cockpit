// GoRouter configuration exposed through Riverpod so redirects can react to
// auth state and push notifications can navigate without a BuildContext.
//
// Top-level destinations (Actions, Connections, Audit, Settings) live in a
// StatefulShellRoute so each keeps its own stack under the shared navigation.
// Pushed screens (action detail, connect agent) and sign-in render on the
// root navigator, above the shell.
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_navigation.dart';
import 'package:cockpit/core/widgets/app_shell.dart';
import 'package:cockpit/features/actions/presentation/controllers/actions_feed_controller.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';
import 'package:cockpit/features/audit/presentation/screens/audit_screen.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cockpit/features/connections/presentation/screens/connect_agent_screen.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';
import 'package:cockpit/features/settings/presentation/screens/settings_screen.dart';

/// The app's [GoRouter].
final appRouterProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  // Re-evaluates redirects whenever the signed-in user changes.
  final auth = ValueNotifier<AsyncValue<AuthUser?>>(ref.read(authControllerProvider));
  ref.listen(authControllerProvider, (_, next) => auth.value = next);

  final router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: RoutePaths.feed,
    refreshListenable: auth,
    redirect: (context, state) {
      final current = auth.value;
      // Wait for the first auth event before deciding.
      if (!current.hasValue) return null;
      final signedIn = current.value != null;
      final atSignIn = state.matchedLocation == RoutePaths.signIn;
      if (!signedIn && !atSignIn) return RoutePaths.signIn;
      if (signedIn && atSignIn) return RoutePaths.feed;
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _NavigationShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.feed,
                path: RoutePaths.feed,
                builder: (context, state) => const ActionsFeedScreen(),
                routes: [
                  GoRoute(
                    name: RouteNames.actionDetail,
                    path: RoutePaths.actionDetail,
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => ActionDetailScreen(
                      actionId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.connections,
                path: RoutePaths.connections,
                builder: (context, state) => const ConnectionsScreen(),
                routes: [
                  GoRoute(
                    name: RouteNames.connectAgent,
                    path: RoutePaths.connectAgent,
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => const ConnectAgentScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.audit,
                path: RoutePaths.audit,
                builder: (context, state) => const AuditScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.settings,
                path: RoutePaths.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: RouteNames.signIn,
        path: RoutePaths.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    auth.dispose();
  });
  return router;
});

class _NavigationShell extends ConsumerWidget {
  const _NavigationShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final pendingCount = ref.watch(pendingCountProvider);
    return AppShell(
      brandName: l10n.appTitle,
      currentIndex: shell.currentIndex,
      onSelected: (index) => shell.goBranch(
        index,
        initialLocation: index == shell.currentIndex,
      ),
      items: [
        AppNavItem(
          key: const Key('nav.actions'),
          icon: AppIcons.tray,
          label: l10n.navFeed,
          railLabel: l10n.navFeed,
          badgeCount: pendingCount,
        ),
        AppNavItem(
          key: const Key('nav.connect'),
          icon: AppIcons.link,
          label: l10n.navConnectShort,
          railLabel: l10n.navConnections,
        ),
        AppNavItem(
          key: const Key('nav.audit'),
          icon: AppIcons.list,
          label: l10n.navAuditShort,
          railLabel: l10n.navAudit,
        ),
        AppNavItem(
          key: const Key('nav.settings'),
          icon: AppIcons.gear,
          label: l10n.navSettings,
          railLabel: l10n.navSettings,
        ),
      ],
      child: shell,
    );
  }
}
