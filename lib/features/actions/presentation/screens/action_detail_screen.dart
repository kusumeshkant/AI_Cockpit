// Feature: actions · Layer: presentation
// Phone action detail (design: technical/design/ActionDetail.dc.html): back
// app bar with source line and status pill, review body, sticky decision bar.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_error_view.dart';
import 'package:cockpit/core/widgets/app_loader.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_review.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_status_pill.dart';

/// Action detail screen.
class ActionDetailScreen extends ConsumerWidget {
  /// Creates the screen for [actionId].
  const ActionDetailScreen({required this.actionId, super.key});

  /// Id of the action to review.
  final String actionId;

  void _close(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    if (router == null) {
      Navigator.of(context).maybePop();
    } else if (router.canPop()) {
      router.pop();
    } else {
      router.goNamed(RouteNames.feed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detail = ref.watch(actionDetailControllerProvider(actionId));
    final item = detail.value;

    return AppScaffold(
      topBar: AppTopBar.back(
        title: l10n.actionDetailTitle,
        onBack: () => _close(context),
        subtitle: item == null
            ? null
            : Text(
                context.sourceLabel(item.agentPlatform, item.agentName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colors.muted,
                  letterSpacing: 0,
                ),
              ),
        trailing: item == null ? null : ActionStatusPill(item: item),
      ),
      body: switch (detail) {
        AsyncData(:final value) => ActionReview(
            item: value,
            onDecided: () => _close(context),
          ),
        AsyncError(:final error) => AppErrorView(
            message: context.failureMessage(error),
            onRetry: () =>
                ref.invalidate(actionDetailControllerProvider(actionId)),
          ),
        _ => const AppLoader(),
      },
    );
  }
}
