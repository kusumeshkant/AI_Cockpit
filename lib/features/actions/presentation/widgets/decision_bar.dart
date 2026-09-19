// Feature: actions · Layer: presentation
// Sticky decision bar (design: ActionDetail.dc.html / TabletFeed.dc.html).
//  * phone  — Reject (danger, flex) · Edit (secondary, sized to its label,
//             at least editButtonMinWidth) · Approve (success, widest).
//             Edit is capped so Approve always stays the widest button.
//  * wide   — right-aligned, intrinsic-width buttons.
// Edit mode swaps to Cancel · Approve with edits.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';

/// Reject / Edit / Approve controls.
class DecisionBar extends StatelessWidget {
  /// Creates the bar.
  const DecisionBar({
    required this.onApprove,
    required this.onReject,
    this.onEdit,
    this.onCancelEdit,
    this.editing = false,
    this.isSubmitting = false,
    this.wide = false,
    super.key,
  });

  /// Flex of the Reject / Cancel button.
  static const int rejectFlex = 10;

  /// Flex of the Approve button (widest).
  static const int approveFlex = 13;

  /// Widest the Edit button may be in a phone row of [rowWidth] with
  /// [gap] between buttons, so that Approve (which shares the remaining
  /// width with Reject at [approveFlex] : [rejectFlex]) is never narrower.
  static double maxEditWidth(double rowWidth, double gap) =>
      (rowWidth - 2 * gap) * approveFlex / (rejectFlex + 2 * approveFlex);

  /// Approve (or approve-with-edits in edit mode).
  final VoidCallback onApprove;

  /// Reject handler.
  final VoidCallback onReject;

  /// Enters edit mode; the Edit button is hidden when `null`.
  final VoidCallback? onEdit;

  /// Leaves edit mode.
  final VoidCallback? onCancelEdit;

  /// Whether the bar is in edit mode.
  final bool editing;

  /// Disables the bar while a decision is in flight.
  final bool isSubmitting;

  /// Right-aligned intrinsic layout for wide panes.
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final busy = isSubmitting;

    final leading = editing
        ? AppButton(
            label: l10n.cancel,
            variant: AppButtonVariant.secondary,
            onPressed: busy ? null : onCancelEdit,
            expand: !wide,
          )
        : AppButton(
            label: l10n.reject,
            icon: AppIcons.close,
            variant: AppButtonVariant.danger,
            onPressed: busy ? null : onReject,
            expand: !wide,
          );
    final edit = !editing && onEdit != null
        ? AppButton(
            label: l10n.edit,
            variant: AppButtonVariant.secondary,
            onPressed: busy ? null : onEdit,
          )
        : null;
    final approve = AppButton(
      label: editing ? l10n.approveWithEdits : l10n.approve,
      icon: AppIcons.check,
      variant: AppButtonVariant.success,
      isLoading: busy,
      onPressed: onApprove,
      expand: !wide,
    );

    final Widget row = wide
        ? Wrap(
            alignment: WrapAlignment.end,
            spacing: spacing.sm + spacing.xxs,
            runSpacing: spacing.sm,
            children: [leading, ?edit, approve],
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              final gap = spacing.sm + spacing.xxs / 2;
              final maxEdit = maxEditWidth(constraints.maxWidth, gap);
              return Row(
                children: [
                  Expanded(flex: rejectFlex, child: leading),
                  if (edit != null) ...[
                    SizedBox(width: gap),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: spacing.editButtonMinWidth,
                        maxWidth: maxEdit < spacing.editButtonMinWidth
                            ? spacing.editButtonMinWidth
                            : maxEdit,
                      ),
                      child: edit,
                    ),
                  ],
                  SizedBox(width: gap),
                  Expanded(flex: approveFlex, child: approve),
                ],
              );
            },
          );

    return AppBottomBar(child: row);
  }
}
