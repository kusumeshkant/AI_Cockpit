// Feed card: source line (mono, muted) + status pill, title, optional preview.
// Entity-agnostic; the actions feature adapts ActionItem onto it.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';

/// Reusable card for feed-style lists.
class ActionCard extends StatelessWidget {
  /// Creates a card.
  const ActionCard({
    required this.source,
    required this.title,
    required this.status,
    this.preview,
    this.dimmed = false,
    this.selected = false,
    this.onTap,
    super.key,
  });

  /// Opacity applied to completed (decided) cards.
  static const double dimmedOpacity = 0.7;

  /// Where the action came from, e.g. "n8n · Email agent".
  final String source;

  /// Primary line.
  final String title;

  /// Trailing status (usually a StatusPill).
  final Widget status;

  /// Secondary preview line.
  final String? preview;

  /// Renders the card faded (already decided).
  final bool dimmed;

  /// Selected state in master–detail layouts.
  final bool selected;

  /// Tap handler.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final text = context.textTheme;

    final card = AppCard(
      onTap: onTap,
      selected: selected,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  source,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelMedium?.copyWith(
                    color: colors.muted,
                    letterSpacing: 0,
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),
              status,
            ],
          ),
          SizedBox(height: spacing.sm - spacing.xxs / 2),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.titleMedium,
          ),
          if (preview != null) ...[
            SizedBox(height: spacing.xs),
            Text(
              preview!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall?.copyWith(color: colors.muted),
            ),
          ],
        ],
      ),
    );

    return RepaintBoundary(
      child: dimmed ? Opacity(opacity: dimmedOpacity, child: card) : card,
    );
  }
}
