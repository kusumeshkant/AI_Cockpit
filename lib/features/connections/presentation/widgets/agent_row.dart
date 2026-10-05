// Feature: connections · Layer: presentation
// Agent list row (design: Connections.dc.html): icon tile, name, platform ·
// activity line, bare LIVE / PAUSED status. Optional [footer] / [trailing]
// slots (Agent Triggers, flag-gated) render nothing when null.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';

/// Card row for an [Agent].
class AgentRow extends StatelessWidget {
  /// Creates the row.
  const AgentRow({
    required this.agent,
    this.onTap,
    this.footer,
    this.trailing,
    super.key,
  });

  /// The agent shown.
  final Agent agent;

  /// Optional tap handler.
  final VoidCallback? onTap;

  /// Optional third line under the meta line (e.g. last trigger run).
  final Widget? footer;

  /// Optional control after the status (e.g. the Run button).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final live = agent.status == AgentStatus.active;
    final lastActionAt = agent.lastActionAt;

    final activity = !live
        ? l10n.pausedMeta
        : lastActionAt == null
            ? l10n.noActionsYet
            : l10n.lastActionAgo(context.formatAgo(lastActionAt));

    return RepaintBoundary(
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: spacing.tileSize,
              height: spacing.tileSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: live ? colors.accentWash : colors.paper,
                borderRadius: BorderRadius.circular(spacing.radiusButton),
              ),
              child: AppIcon(
                AppIcons.grid,
                size: spacing.iconMd,
                color: live ? colors.accent : colors.muted,
              ),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall,
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    l10n.metaPair(context.platformLabel(agent.platform), activity),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: colors.muted,
                      letterSpacing: 0,
                    ),
                  ),
                  if (footer != null) ...[
                    SizedBox(height: spacing.xxs),
                    footer!,
                  ],
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            StatusPill.bare(
              label: live ? l10n.statusLive : l10n.statusPaused,
              tone: live ? StatusTone.go : StatusTone.pending,
            ),
            if (trailing != null) ...[
              SizedBox(width: spacing.xs),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
