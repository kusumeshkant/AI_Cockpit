// Feature: actions · Layer: presentation
// Review surface shared by the phone detail screen and the tablet detail
// pane: scrollable body (title, "What it wants to do", renderer) above the
// decision bar. Owns edit mode, the reject sheet and decision submission.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_banner.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';
import 'package:cockpit/features/actions/presentation/renderers/action_renderer.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_status_pill.dart';
import 'package:cockpit/features/actions/presentation/widgets/decision_bar.dart';
import 'package:cockpit/features/actions/presentation/widgets/reject_sheet.dart';

/// Body + decision bar for one action.
class ActionReview extends ConsumerStatefulWidget {
  /// Creates the review surface.
  const ActionReview({
    required this.item,
    this.wide = false,
    this.showTitle = true,
    this.onDecided,
    super.key,
  });

  /// The action under review.
  final ActionItem item;

  /// Wide pane layout (larger padding, right-aligned bar, capped width).
  final bool wide;

  /// Whether the action title is shown at the top of the body.
  final bool showTitle;

  /// Called after a decision succeeds.
  final VoidCallback? onDecided;

  @override
  ConsumerState<ActionReview> createState() => _ActionReviewState();
}

class _ActionReviewState extends ConsumerState<ActionReview> {
  final Map<String, TextEditingController> _controllers = {};
  bool _editing = false;
  bool _submitting = false;

  ActionItem get _item => widget.item;

  @override
  void didUpdateWidget(covariant ActionReview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) _stopEditing();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  void _startEditing() {
    for (final field in _item.editableFields) {
      _controllers[field] =
          TextEditingController(text: '${_item.payload[field] ?? ''}');
    }
    setState(() => _editing = true);
  }

  void _stopEditing() {
    _disposeControllers();
    if (mounted) setState(() => _editing = false);
  }

  Map<String, dynamic> _editedPayload() => {
        for (final entry in _controllers.entries)
          if (entry.value.text != '${_item.payload[entry.key] ?? ''}')
            entry.key: entry.value.text,
      };

  Future<void> _submit(DecisionType type, {String? reason}) async {
    final edits = type == DecisionType.approvedWithEdits ? _editedPayload() : null;
    final effectiveType = type == DecisionType.approvedWithEdits && edits!.isEmpty
        ? DecisionType.approved
        : type;

    setState(() => _submitting = true);
    final failure = await ref
        .read(actionDetailControllerProvider(_item.id).notifier)
        .decide(effectiveType, editedPayload: edits, reason: reason);
    if (!mounted) return;
    setState(() => _submitting = false);

    final messenger = ScaffoldMessenger.of(context);
    if (failure != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(context.failureMessage(failure))),
      );
      return;
    }
    _stopEditing();
    messenger.showSnackBar(SnackBar(content: Text(context.l10n.decisionRecorded)));
    widget.onDecided?.call();
  }

  Future<void> _reject() async {
    final result = await showRejectSheet(context);
    if (result != null && mounted) {
      await _submit(DecisionType.rejected, reason: result.reason);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final padding = widget.wide ? spacing.xl : spacing.screenPadding;
    final gap = widget.wide ? spacing.lg : spacing.md;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(padding),
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: widget.wide ? spacing.detailMaxWidth : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.showTitle) ...[
                        Text(_item.title, style: context.textTheme.titleLarge),
                        SizedBox(height: gap),
                      ],
                      if (_item.summary != null) ...[
                        AppBanner(
                          label: l10n.whatItWantsToDo,
                          message: _item.summary!,
                        ),
                        SizedBox(height: gap),
                      ],
                      ActionRenderers.build(
                        _item,
                        editing: RendererEditing(
                          enabled: _editing,
                          controllers: _controllers,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_item.isPending)
          DecisionBar(
            wide: widget.wide,
            editing: _editing,
            isSubmitting: _submitting,
            onReject: _reject,
            onEdit: _item.editableFields.isEmpty ? null : _startEditing,
            onCancelEdit: _stopEditing,
            onApprove: () => _submit(
              _editing ? DecisionType.approvedWithEdits : DecisionType.approved,
            ),
          )
        else
          _DecidedBar(item: _item),
      ],
    );
  }
}

class _DecidedBar extends StatelessWidget {
  const _DecidedBar({required this.item});

  final ActionItem item;

  @override
  Widget build(BuildContext context) {
    final decidedAt = item.decidedAt;
    return AppBottomBar(
      child: Row(
        children: [
          ActionStatusPill(item: item),
          if (decidedAt != null) ...[
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(
                context.formatDayOrTime(decidedAt),
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colors.muted,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
