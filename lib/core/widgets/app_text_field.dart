// Text input: mono uppercase label above, 48px field with lineStrong border,
// radius 12, optional leading icon.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_text_styles.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/section_label.dart';

/// Cockpit's text field.
class AppTextField extends StatelessWidget {
  /// Creates a field.
  const AppTextField({
    required this.label,
    this.controller,
    this.hint,
    this.leadingIcon,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.monospace = false,
    super.key,
  });

  /// Localized label (rendered uppercase above the field).
  final String label;

  /// Text controller.
  final TextEditingController? controller;

  /// Placeholder.
  final String? hint;

  /// Optional leading glyph.
  final AppIcons? leadingIcon;

  /// Localized validation message.
  final String? errorText;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Keyboard action button.
  final TextInputAction? textInputAction;

  /// Autofill hints.
  final Iterable<String>? autofillHints;

  /// Called on every change.
  final ValueChanged<String>? onChanged;

  /// Called on submit.
  final ValueChanged<String>? onSubmitted;

  /// Whether editing is allowed.
  final bool enabled;

  /// Line count; values > 1 grow the field beyond the standard height.
  final int maxLines;

  /// Mono input text (URLs, identifiers). Off by default.
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(spacing.radiusPanel),
          borderSide: BorderSide(color: color, width: width),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionLabel(label, dense: true),
        SizedBox(height: spacing.sm - spacing.xxs / 2),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          maxLines: maxLines,
          style: monospace
              ? AppTextStyles.monoData.copyWith(
                  fontSize: context.textTheme.bodyLarge?.fontSize,
                  color: colors.ink,
                )
              : context.textTheme.bodyLarge?.copyWith(color: colors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.textTheme.bodyLarge?.copyWith(color: colors.muted),
            errorText: errorText,
            errorStyle:
                context.textTheme.bodySmall?.copyWith(color: colors.stop),
            filled: true,
            fillColor: colors.surface,
            isDense: true,
            constraints: maxLines == 1
                ? BoxConstraints(minHeight: spacing.inputHeight)
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing.md + spacing.xxs,
              vertical: spacing.md + spacing.xxs,
            ),
            prefixIcon: leadingIcon == null
                ? null
                : Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: spacing.md + spacing.xxs,
                      end: spacing.sm + spacing.xxs,
                    ),
                    child: AppIcon(
                      leadingIcon!,
                      size: spacing.iconMd - spacing.xxs,
                      color: colors.muted,
                    ),
                  ),
            prefixIconConstraints: const BoxConstraints(),
            enabledBorder: border(colors.lineStrong, spacing.borderThin),
            disabledBorder: border(colors.line, spacing.borderThin),
            focusedBorder: border(colors.accent, spacing.borderMedium),
            errorBorder: border(colors.stop, spacing.borderThin),
            focusedErrorBorder: border(colors.stop, spacing.borderMedium),
          ),
        ),
      ],
    );
  }
}
