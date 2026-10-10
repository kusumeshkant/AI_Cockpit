// GoRouter configuration exposed through Riverpod so redirects can react to
// auth state and push notifications can navigate without a BuildContext.
//
// Top-level destinations (Actions, Connections, Audit, Settings) live in a
// StatefulShellRoute so each keeps its own stack under the shared navigation.
// Pushed screens (action detail, connect agent) and sign-in render on the
// root navigator, above the shell.
//
// Startup (F21): until the first auth event the app shows a branded spinner
// (/loading) instead of flashing the feed; if no event comes within
// [authStartupTimeout] (offline / slow) it falls back to sign-in.
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_navigation.dart';
import 'package:cockpit/core/widgets/app_shell.dart';
import 'package:cockpit/core/widgets/startup_screen.dart';
import 'package:cockpit/features/actions/presentation/controllers/actions_feed_controller.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';
import 'package:cockpit/features/audit/presentation/screens/audit_screen.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cockpit/features/connections/presentation/screens/connect_agent_screen.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';
import 'package:cockpit/features/settings/presentation/screens/delete_account_screen.dart';
import 'package:cockpit/features/settings/presentation/screens/settings_screen.dart';

/// How long startup waits for the first auth event before showing sign-in.
const Duration authStartupTimeout = Duration(seconds: 5);

/// Where to send [location] for the given auth state (null = stay). Pure, so
/// every startup case is unit-tested.
///
/// * No auth event yet and not [timedOut]: wait on /loading, remembering the
///   requested location in `from` (a push tap during startup still lands).
/// * Timed out without an event: treated as signed out.
/// * Signed out: sign-in. Signed in: leave sign-in / loading for `from` or
///   the feed. Never redirects a location to itself, so no loop.
@visibleForTesting
String? authRedirect({
  required AsyncValue<AuthUser?> auth,
  required bool timedOut,
  required Uri location,
}) {
  final path = location.path;
  final atLoading = path == RoutePaths.loading;
  final atSignIn = path == RoutePaths.signIn;

  if (!auth.hasValue && !timedOut) {
    if (atLoading) return null;
    final from = atSignIn ? null : location.toString();
    return Uri(
      path: RoutePaths.loading,
      queryParameters: from == null ? null : {'from': from},
    ).toString();
  }

  final signedIn = auth.hasValue && auth.value != null;
  if (!signedIn) return atSignIn ? null : RoutePaths.signIn;
  if (atSignIn) return RoutePaths.feed;
  if (atLoading) {
    final from = location.queryParameters['from'];
    final safe = from != null &&
        from.startsWith('/') &&
        !from.startsWith('//') &&
        !from.startsWith(RoutePaths.loading) &&
        !from.startsWith(RoutePaths.signIn);
    return safe ? from : RoutePaths.feed;
  }
  return null;
}

/// The app's [GoRouter].
final appRouterProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  // Re-evaluates redirects whenever the signed-in user changes.
  final auth = ValueNotifier<AsyncValue<AuthUser?>>(ref.read(authControllerProvider));
  ref.listen(authControllerProvider, (_, next) => auth.value = next);

  // Startup fallback: stop waiting for auth after [authStartupTimeout].
  final timedOut = ValueNotifier<bool>(false);
  final startupTimer = Timer(authStartupTimeout, () => timedOut.value = true);

  final router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: RoutePaths.loading,
    refreshListenable: Listenable.merge([auth, timedOut]),
    redirect: (context, state) =>
        authRedirect(auth: auth.value, timedOut: timedOut.value, location: state.uri),
    routes: [
      GoRoute(
        name: RouteNames.loading,
        path: RoutePaths.loading,
        builder: (context, state) => const StartupScreen(),
      ),
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
                routes: [
                  GoRoute(
                    name: RouteNames.deleteAccount,
                    path: RoutePaths.deleteAccount,
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => const DeleteAccountScreen(),
                  ),
                ],
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
    startupTimer.cancel();
    router.dispose();
    auth.dispose();
    timedOut.dispose();
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
