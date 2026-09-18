// Feature: notifications · Layer: presentation
// Translates a tapped push into a GoRouter navigation. The router's auth
// redirect still applies, so a signed-out user lands on sign-in instead.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/router/app_router.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';

/// Routes tapped notifications to screens.
class PushRouter {
  /// Creates the router bridge.
  const PushRouter(this._router);

  final GoRouter _router;

  /// Opens the action a push points at (`{type: action, action_id}`).
  /// Returns `false` when the message has no destination.
  bool handle(PushMessage message) {
    final actionId = message.actionId;
    if (actionId == null) return false;
    _router.goNamed(RouteNames.actionDetail, pathParameters: {'id': actionId});
    return true;
  }
}

/// Push → route bridge.
final pushRouterProvider =
    Provider<PushRouter>((ref) => PushRouter(ref.watch(appRouterProvider)));
