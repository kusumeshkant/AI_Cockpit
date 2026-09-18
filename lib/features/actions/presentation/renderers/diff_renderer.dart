// Feature: actions · Layer: presentation
// Before/after diff (`before`, `after` maps): one row per changed field with
// the old value in stop red (struck through) and the new value in go green.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_text_styles.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/section_label.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/renderers/generic_renderer.dart';

/// Diff action renderer.
class DiffRenderer extends StatelessWidget {
  /// Creates the renderer.
  const DiffRenderer({required this.item, super.key});

  /// The action to render.
  final ActionItem item;

  @override
  Widget build(BuildContext context) {
    final before = item.payload['before'];
    final after = item.payload['after'];
    if (before is! Map || after is! Map) return GenericRenderer(item: item);

    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final fields = {...before.keys, ...after.keys}
        .where((key) => before[key] != after[key])
        .toList(growable: false);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0) const Divider(),
            Padding(
              padding: EdgeInsets.all(spacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel('${fields[i]}', dense: true),
                  SizedBox(height: spacing.xs + spacing.xxs),
                  _Value(
                    label: l10n.diffBefore,
                    value: before[fields[i]],
                    color: colors.stop,
                    background: colors.stopBg,
                    struck: true,
                  ),
                  SizedBox(height: spacing.xs),
                  _Value(
                    label: l10n.diffAfter,
                    value: after[fields[i]],
                    color: colors.go,
                    background: colors.goBg,
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

class _Value extends StatelessWidget {
  const _Value({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
    this.struck = false,
  });

  final String label;
  final Object? value;
  final Color color;
  final Color background;
  final bool struck;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Semantics(
      label: '$label: ${value ?? ''}',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(spacing.radiusField),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm + spacing.xxs,
            vertical: spacing.xs + spacing.xxs,
          ),
          child: Text(
            '${value ?? '—'}',
            style: AppTextStyles.monoData.copyWith(
              color: color,
              decoration: struck ? TextDecoration.lineThrough : null,
              decorationColor: color,
            ),
          ),
        ),
      ),
    );
  }
}
