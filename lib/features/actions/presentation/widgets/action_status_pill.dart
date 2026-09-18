// Feature: actions · Layer: presentation
// Maps an action's status/decision onto the shared StatusPill.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';

/// Status pill for an [ActionItem].
class ActionStatusPill extends StatelessWidget {
  /// Creates the pill.
  const ActionStatusPill({required this.item, super.key});

  /// The action.
  final ActionItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, tone) = switch ((item.status, item.decision)) {
      (ActionStatus.pending, _) => (l10n.statusPending, StatusTone.pending),
      (ActionStatus.expired, _) => (l10n.statusExpired, StatusTone.stop),
      (_, DecisionType.rejected) => (l10n.statusRejected, StatusTone.stop),
      (_, _) => (l10n.statusApproved, StatusTone.go),
    };
    return StatusPill(label: label, tone: tone);
  }
}
