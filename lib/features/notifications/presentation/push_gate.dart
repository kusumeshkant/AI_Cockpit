// Feature: notifications · Layer: presentation
// Ties push to the session: starts NotificationService when a user signs in
// and stops it on sign-out. Mounted once, around the router, from
// MaterialApp.builder (so localized channel texts are available).
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/notifications/presentation/local_notifier.dart';
import 'package:cockpit/features/notifications/presentation/notification_service.dart';
import 'package:cockpit/features/notifications/presentation/push_router.dart';

/// Starts / stops push with the signed-in user; renders [child] unchanged.
class PushGate extends ConsumerStatefulWidget {
  /// Creates the gate.
  const PushGate({required this.child, super.key});

  /// The app content.
  final Widget child;

  @override
  ConsumerState<PushGate> createState() => _PushGateState();
}

class _PushGateState extends ConsumerState<PushGate> {
  late final ProviderSubscription<String?> _user;

  @override
  void initState() {
    super.initState();
    _user = ref.listenManual<String?>(
      authControllerProvider.select((auth) => auth.value?.id),
      (previous, userId) => _onUser(userId),
      fireImmediately: true,
    );
  }

  void _onUser(String? userId) {
    final service = ref.read(notificationServiceProvider);
    if (userId == null) {
      unawaited(service.stop());
      return;
    }
    // Localized texts need an inherited context: wait for the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = context.l10n;
      unawaited(
        service.start(
          channel: NotificationChannelText(
            name: l10n.notificationChannelName,
            description: l10n.notificationChannelDescription,
          ),
          onOpen: (message) => ref.read(pushRouterProvider).handle(message),
        ),
      );
    });
  }

  @override
  void dispose() {
    _user.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
