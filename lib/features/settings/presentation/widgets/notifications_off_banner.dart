// Feature: settings · Layer: presentation
// Settings hint when the OS notification permission was denied (F11): the
// user would otherwise silently get no pushes. Opening the phone's settings
// directly needs another plugin (ADR), so the hint says where to go.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/widgets/app_banner.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/features/notifications/presentation/notification_service.dart';

/// Shown only when notifications were denied; renders nothing otherwise.
class NotificationsOffBanner extends ConsumerWidget {
  /// Creates the banner; [bottomGap] is added below it when it shows.
  const NotificationsOffBanner({required this.bottomGap, super.key});

  /// Space below the banner (only when visible).
  final double bottomGap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(pushPermissionGrantedProvider) != false) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: AppBanner(
        key: const ValueKey('settings_notifications_off'),
        icon: AppIcons.alert,
        label: l10n.notificationsOffTitle,
        message: l10n.notificationsOffBody,
      ),
    );
  }
}
