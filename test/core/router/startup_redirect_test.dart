// F21: startup waits on a branded spinner for the first auth event, falls
// back to sign-in after the timeout, and never loops.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cockpit/core/di/providers.dart';
import 'package:cockpit/core/router/app_router.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/startup_screen.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cockpit/l10n/app_localizations.dart';

import '../../helpers/fakes.dart';

/// Auth that never emits (offline / slow start).
class _SilentAuth extends AuthController {
  @override
  Stream<AuthUser?> build() => StreamController<AuthUser?>().stream;
}

const _loading = AsyncLoading<AuthUser?>();
const _signedOut = AsyncData<AuthUser?>(null);
const _signedIn = AsyncData<AuthUser?>(testUser);

String? _redirect(AsyncValue<AuthUser?> auth, String location, {bool timedOut = false}) =>
    authRedirect(auth: auth, timedOut: timedOut, location: Uri.parse(location));

void main() {
  group('authRedirect', () {
    test('waits on /loading before the first auth event, remembering where to go', () {
      expect(_redirect(_loading, RoutePaths.loading), isNull);
      final waiting = Uri.parse(_redirect(_loading, '/actions/a1')!);
      expect(waiting.path, RoutePaths.loading);
      expect(waiting.queryParameters['from'], '/actions/a1');
    });

    test('after the timeout without an event: sign-in', () {
      expect(_redirect(_loading, RoutePaths.loading, timedOut: true), RoutePaths.signIn);
      expect(_redirect(_loading, RoutePaths.signIn, timedOut: true), isNull, reason: 'no loop');
    });

    test('signed out: sign-in, and sign-in stays put', () {
      expect(_redirect(_signedOut, RoutePaths.loading), RoutePaths.signIn);
      expect(_redirect(_signedOut, RoutePaths.feed), RoutePaths.signIn);
      expect(_redirect(_signedOut, RoutePaths.signIn), isNull);
    });

    test('signed in: leaves loading for `from` (or the feed) and sign-in for the feed', () {
      expect(_redirect(_signedIn, '/loading?from=%2Factions%2Fa1'), '/actions/a1');
      expect(_redirect(_signedIn, RoutePaths.loading), RoutePaths.feed);
      expect(_redirect(_signedIn, RoutePaths.signIn), RoutePaths.feed);
      expect(_redirect(_signedIn, RoutePaths.feed), isNull);
    });

    test('`from` can never point back at loading, sign-in or off-app', () {
      expect(_redirect(_signedIn, '/loading?from=%2Floading'), RoutePaths.feed);
      expect(_redirect(_signedIn, '/loading?from=%2Fsign-in'), RoutePaths.feed);
      expect(_redirect(_signedIn, '/loading?from=https%3A%2F%2Fevil.example'), RoutePaths.feed);
      expect(_redirect(_signedIn, '/loading?from=%2F%2Fevil.example'), RoutePaths.feed);
    });

    test('a late sign-in after the timeout still lands on the feed', () {
      expect(_redirect(_signedIn, RoutePaths.signIn, timedOut: true), RoutePaths.feed);
    });
  });

  testWidgets('with no auth event: spinner first, sign-in after the timeout', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authControllerProvider.overrideWith(_SilentAuth.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.buildLight(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(appRouterProvider),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(StartupScreen), findsOneWidget);
    expect(find.byType(SignInScreen), findsNothing, reason: 'no feed flash, no early sign-in');

    await tester.pump(authStartupTimeout);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.byType(StartupScreen), findsNothing);
  });
}
