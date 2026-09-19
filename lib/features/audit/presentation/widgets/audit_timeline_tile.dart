// Feature: audit · Layer: presentation
// Timeline row (design: Audit.dc.html): colored dot with a connector line to
// the next entry, "Decision · title", time on the right, source · note below.
// Agent Triggers entries (flag-gated upstream) read "Agent run started" /
// "Run failed" with an accent / stop dot.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';

/// One audit timeline entry.
class AuditTimelineTile extends StatelessWidget {
  /// Creates the tile. [isLast] hides the connector.
  const AuditTimelineTile({required this.entry, required this.isLast, super.key});

  /// The entry.
  final AuditEntry entry;

  /// Whether this is the final entry.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final text = context.textTheme;
    final metaStyle = text.labelMedium?.copyWith(
      color: colors.muted,
      letterSpacing: 0,
    );

    final String title;
    final Color dotColor;
    switch (entry.event) {
      case AuditEvent.triggerFired:
        title = l10n.auditTriggerFired;
        dotColor = colors.accent;
      case AuditEvent.triggerFailed:
        title = l10n.auditTriggerFailed;
        dotColor = colors.stop;
      default:
        final outcome = entry.isRejection ? l10n.statusRejected : l10n.statusApproved;
        title = entry.actionTitle == null
            ? outcome
            : l10n.metaPair(outcome, entry.actionTitle!);
        dotColor = entry.isRejection ? colors.stop : colors.go;
    }

    var meta = context.sourceLabel(entry.agentPlatform, entry.agentName);
    final reason = entry.reason;
    final note = reason != null && reason.isNotEmpty
        ? l10n.noteQuoted(reason)
        : entry.wasEdited
            ? l10n.editedBeforeApprove
            : null;
    if (note != null) meta = meta.isEmpty ? note : l10n.metaPair(meta, note);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              SizedBox(height: spacing.xs),
              SizedBox.square(
                dimension: spacing.dotLg,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (!isLast) ...[
                SizedBox(height: spacing.xs),
                Expanded(
                  child: SizedBox(
                    width: spacing.connectorWidth,
                    child: ColoredBox(color: colors.line),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: text.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: text.titleMedium?.height,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      Text(
                        context.formatDayOrTime(entry.createdAt),
                        style: metaStyle,
                      ),
                    ],
                  ),
                  if (meta.isNotEmpty) ...[
                    SizedBox(height: spacing.xs - spacing.xxs / 2),
                    Text(meta, style: metaStyle),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
