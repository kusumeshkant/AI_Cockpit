// Feature: actions · Layer: presentation
// Tabular payloads (`columns`, `rows`) as a card with a mono header row and
// hairline-separated rows. Scrolls horizontally when there are many columns.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/section_label.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/renderers/generic_renderer.dart';

/// Table action renderer.
class TableRenderer extends StatelessWidget {
  /// Creates the renderer.
  const TableRenderer({required this.item, super.key});

  /// Columns above which the table scrolls horizontally.
  static const int maxFittedColumns = 3;

  /// The action to render.
  final ActionItem item;

  @override
  Widget build(BuildContext context) {
    final columns = item.payload['columns'];
    final rows = item.payload['rows'];
    if (columns is! List || rows is! List) return GenericRenderer(item: item);

    final colors = context.colors;
    final spacing = context.spacing;
    final cellPadding = EdgeInsets.symmetric(
      horizontal: spacing.cardPadding,
      vertical: spacing.sm + spacing.xxs,
    );

    final table = Table(
      defaultColumnWidth: columns.length > maxFittedColumns
          ? const IntrinsicColumnWidth()
          : const FlexColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder(horizontalInside: BorderSide(color: colors.line)),
      children: [
        TableRow(
          decoration: BoxDecoration(color: colors.surfaceAlt),
          children: [
            for (final column in columns)
              Padding(padding: cellPadding, child: SectionLabel('$column', dense: true)),
          ],
        ),
        for (final row in rows.whereType<List<dynamic>>())
          TableRow(
            children: [
              for (var i = 0; i < columns.length; i++)
                Padding(
                  padding: cellPadding,
                  child: Text(
                    i < row.length ? '${row[i]}' : '',
                    style: context.textTheme.bodySmall?.copyWith(color: colors.ink),
                  ),
                ),
            ],
          ),
      ],
    );

    return AppCard(
      padding: EdgeInsets.zero,
      child: columns.length > maxFittedColumns
          ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: table)
          : table,
    );
  }
}
