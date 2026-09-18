// Feature: actions · Layer: presentation
// Email draft card (design: ActionDetail.dc.html): To / Subject header,
// body, and an "editable" footer. In edit mode editable fields become inputs.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/renderers/action_renderer.dart';

/// Email action renderer.
class EmailRenderer extends StatelessWidget {
  /// Creates the renderer.
  const EmailRenderer({
    required this.item,
    this.editing = RendererEditing.off,
    super.key,
  });

  /// Payload field: recipient.
  static const String fieldTo = 'to';

  /// Payload field: subject.
  static const String fieldSubject = 'subject';

  /// Payload field: body.
  static const String fieldBody = 'body';

  /// The action to render.
  final ActionItem item;

  /// Editing state.
  final RendererEditing editing;

  String _field(String name) => '${item.payload[name] ?? ''}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final text = context.textTheme;
    final subjectController = editing.controllers[fieldSubject];
    final bodyController = editing.controllers[fieldBody];

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.cardPadding,
              vertical: spacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderRow(label: l10n.emailTo, value: _field(fieldTo)),
                SizedBox(height: spacing.xs + spacing.xxs),
                if (editing.enabled && subjectController != null)
                  AppTextField(
                    label: l10n.emailSubject,
                    controller: subjectController,
                  )
                else
                  _HeaderRow(
                    label: l10n.emailSubject,
                    value: _field(fieldSubject),
                    emphasize: true,
                  ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(spacing.cardPadding),
            child: editing.enabled && bodyController != null
                ? AppTextField(
                    label: l10n.emailBody,
                    controller: bodyController,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                  )
                : SelectableText(
                    _field(fieldBody),
                    style: text.bodyMedium?.copyWith(color: colors.inkSoft),
                  ),
          ),
          if (item.editableFields.isNotEmpty && !editing.enabled) ...[
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.cardPadding,
                vertical: spacing.sm + spacing.xxs / 2,
              ),
              child: Row(
                children: [
                  AppIcon(
                    AppIcons.pencil,
                    size: spacing.iconSm - spacing.xxs,
                    color: colors.accent,
                  ),
                  SizedBox(width: spacing.sm - spacing.xxs / 2),
                  Expanded(
                    child: Text(
                      item.editableFields.toSet().containsAll(
                                const {fieldSubject, fieldBody},
                              )
                          ? l10n.emailEditableHint
                          : l10n.fieldsEditableHint,
                      style: text.labelMedium?.copyWith(
                        color: colors.accent,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final text = context.textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: spacing.fieldLabelWidth),
          child: Text(
            label,
            style: text.labelMedium?.copyWith(
              color: colors.muted,
              fontSize: text.bodySmall?.fontSize,
              letterSpacing: 0,
            ),
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: Text(
            value,
            style: text.bodySmall?.copyWith(
              color: colors.ink,
              fontWeight: emphasize ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
