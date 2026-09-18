// Feature: actions · Layer: presentation
// Bottom sheet asking for an optional rejection reason (≤ 500 chars).
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';

/// Result of the reject sheet.
@immutable
class RejectResult {
  /// Creates a result.
  const RejectResult(this.reason);

  /// Optional reason; `null` when left empty.
  final String? reason;
}

/// Shows the sheet. Returns `null` when dismissed or cancelled.
Future<RejectResult?> showRejectSheet(BuildContext context) {
  return showModalBottomSheet<RejectResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.spacing.radiusCard),
      ),
    ),
    builder: (_) => const _RejectSheet(),
  );
}

class _RejectSheet extends StatefulWidget {
  const _RejectSheet();

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
  static const int _maxReasonLength = 500;

  final TextEditingController _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _confirm() {
    final text = _reason.text.trim();
    final reason = text.isEmpty
        ? null
        : text.substring(0, text.length.clamp(0, _maxReasonLength));
    Navigator.of(context).pop(RejectResult(reason));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.only(
        left: spacing.lg,
        right: spacing.lg,
        top: spacing.xl,
        bottom: MediaQuery.viewInsetsOf(context).bottom + spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.rejectSheetTitle, style: context.textTheme.titleLarge),
          SizedBox(height: spacing.lg),
          AppTextField(
            label: l10n.rejectReasonHint,
            controller: _reason,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: spacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.cancel,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(context).pop(),
                  expand: true,
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: AppButton(
                  label: l10n.reject,
                  variant: AppButtonVariant.danger,
                  onPressed: _confirm,
                  expand: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
