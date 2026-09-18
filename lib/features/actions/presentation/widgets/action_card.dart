// Feature: actions · Layer: presentation
// Adapts an ActionItem onto the core ActionCard: source line, status pill,
// title and a preview (email body excerpt, summary, or decision time).
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/widgets/action_card.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_status_pill.dart';

/// Feed card for an [ActionItem].
class ActionItemCard extends StatelessWidget {
  /// Creates a card for [item].
  const ActionItemCard({
    required this.item,
    this.onTap,
    this.selected = false,
    this.showPreview = true,
    super.key,
  });

  /// The action shown.
  final ActionItem item;

  /// Opens the detail.
  final VoidCallback? onTap;

  /// Selected state (tablet master–detail).
  final bool selected;

  /// Whether the preview line is shown (hidden in the narrow tablet list).
  final bool showPreview;

  static final RegExp _whitespace = RegExp(r'\s+');

  String? _preview(BuildContext context) {
    final l10n = context.l10n;
    if (!item.isPending) {
      final decidedAt = item.decidedAt;
      if (decidedAt == null) return item.summary;
      final time = context.formatClock(decidedAt);
      final decided = item.decision == DecisionType.rejected
          ? l10n.rejectedAt(time)
          : l10n.approvedAt(time);
      return item.summary == null ? decided : l10n.metaPair(decided, item.summary!);
    }
    final body = item.payload['body'];
    if (item.type == ActionTypes.email && body is String && body.isNotEmpty) {
      return l10n.quotedPreview(body.replaceAll(_whitespace, ' ').trim());
    }
    return item.summary;
  }

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      source: context.sourceLabel(item.agentPlatform, item.agentName),
      title: item.title,
      preview: showPreview ? _preview(context) : null,
      status: ActionStatusPill(item: item),
      dimmed: !item.isPending,
      selected: selected,
      onTap: onTap,
    );
  }
}
