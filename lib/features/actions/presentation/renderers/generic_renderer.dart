// Feature: actions · Layer: presentation
// Fallback renderer for unknown action types (TR-5): pretty-printed JSON in a
// card, selectable.
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_text_styles.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/section_label.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';

/// Generic JSON renderer.
class GenericRenderer extends StatelessWidget {
  /// Creates the renderer.
  const GenericRenderer({required this.item, super.key});

  /// The action to render.
  final ActionItem item;

  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(context.l10n.payloadLabel),
          SizedBox(height: spacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              _encoder.convert(item.payload),
              style: AppTextStyles.monoData.copyWith(color: colors.inkSoft),
            ),
          ),
        ],
      ),
    );
  }
}
