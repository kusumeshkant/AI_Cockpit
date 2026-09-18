// Read-only mono value with a copy button (inbound URL, signing secret).
// The displayed text may be masked while the full value is copied.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/theme/app_text_styles.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/section_label.dart';

/// Labelled value with a copy action.
class CopyableField extends StatelessWidget {
  /// Creates the field.
  const CopyableField({
    required this.label,
    required this.value,
    this.displayValue,
    this.onCopied,
    super.key,
  });

  /// Localized label (uppercase mono).
  final String label;

  /// Full value placed on the clipboard.
  final String value;

  /// Text shown instead of [value] (e.g. a masked secret).
  final String? displayValue;

  /// Called after the value is copied (show a snackbar).
  final VoidCallback? onCopied;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(spacing.radiusField);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionLabel(label, dense: true),
        SizedBox(height: spacing.xs),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: radius,
            border: Border.all(color: colors.line),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: spacing.md - spacing.xxs / 2),
                  child: Text(
                    displayValue ?? value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.monoData.copyWith(color: colors.ink),
                  ),
                ),
              ),
              Tooltip(
                message: context.l10n.copy,
                child: Semantics(
                  button: true,
                  label: '${context.l10n.copy} $label',
                  excludeSemantics: true,
                  child: InkWell(
                    borderRadius: radius,
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: value));
                      onCopied?.call();
                    },
                    child: SizedBox.square(
                      dimension: spacing.minTapTarget,
                      child: Center(
                        child: AppIcon(
                          AppIcons.copy,
                          size: spacing.iconSm,
                          color: colors.accent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
