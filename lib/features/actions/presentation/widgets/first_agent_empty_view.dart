// Feature: actions · Layer: presentation
// Empty feed for a workspace with no agents yet (F13): a next step instead of
// "All clear". Owners get a short how-it-works list and a Connect button;
// approvers can't connect agents, so they are pointed to the owner.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_icon.dart';

/// Onboarding empty state for a workspace without agents.
class FirstAgentEmptyView extends StatelessWidget {
  /// Creates the view; [canConnect] shows the owner's steps and button.
  const FirstAgentEmptyView({required this.canConnect, super.key});

  /// Whether the user may connect agents (workspace owner).
  final bool canConnect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final text = context.textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: spacing.formMaxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppIcon(AppIcons.link, size: spacing.iconXl, color: colors.muted),
              SizedBox(height: spacing.md),
              Text(l10n.firstAgentTitle, textAlign: TextAlign.center, style: text.titleMedium),
              SizedBox(height: spacing.xs),
              if (canConnect) ...[
                Text(
                  l10n.firstAgentMessage,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(color: colors.muted),
                ),
                SizedBox(height: spacing.lg),
                for (final (index, step) in [
                  l10n.firstAgentStepConnect,
                  l10n.firstAgentStepPropose,
                  l10n.firstAgentStepDecide,
                ].indexed)
                  _Step(number: index + 1, text: step),
                SizedBox(height: spacing.lg),
                AppButton(
                  key: const ValueKey('feed_connect_first_agent'),
                  label: l10n.connectFirstAgent,
                  icon: AppIcons.plus,
                  expand: true,
                  onPressed: () => context.goNamed(RouteNames.connectAgent),
                ),
              ] else
                Text(
                  l10n.firstAgentAskOwner,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(color: colors.muted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: spacing.iconMd + spacing.xxs,
            height: spacing.iconMd + spacing.xxs,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colors.accentWash, shape: BoxShape.circle),
            child: Text(
              context.l10n.stepNumber(number),
              style: context.textTheme.labelMedium?.copyWith(color: colors.accent),
            ),
          ),
          SizedBox(width: spacing.sm),
          Expanded(child: Text(text, style: context.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
