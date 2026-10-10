// Feature: settings · Layer: presentation
// Settings → Legal (F03): Terms of Service and Privacy Policy rows that open
// the configured pages in the browser. Renders nothing (not even its label)
// when no legal URL is configured.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/legal_links.dart';
import 'package:cockpit/core/widgets/section_label.dart';

/// Labelled Legal section for Settings.
class LegalSection extends ConsumerWidget {
  /// Creates the section; [topGap] is added above it when it renders.
  const LegalSection({required this.topGap, super.key});

  /// Space above the section (only when it has links).
  final double topGap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = configuredLegalPages(ref);
    if (pages.isEmpty) return const SizedBox.shrink();
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.only(top: topGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(context.l10n.sectionLegal),
          SizedBox(height: spacing.sm + spacing.xxs / 2),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < pages.length; i++) ...[
                  if (i > 0) const Divider(),
                  _LegalRow(page: pages[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalRow extends ConsumerWidget {
  const _LegalRow({required this.page});

  final LegalPage page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final label = legalPageLabel(context, page);
    return Semantics(
      link: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('settings_legal_${page.name}'),
        onTap: () => openLegalPage(context, ref, page),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: spacing.minTapTarget),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.cardPadding),
            child: Row(
              children: [
                Expanded(child: Text(label, style: context.textTheme.titleSmall)),
                AppIcon(AppIcons.chevronRight, color: context.colors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
