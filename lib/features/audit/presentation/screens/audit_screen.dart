// Feature: audit · Layer: presentation
// Audit log (design: technical/design/Audit.dc.html): title with All /
// Approved / Rejected filter chips, then a vertical decision timeline.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_chip.dart';
import 'package:cockpit/core/widgets/app_empty_view.dart';
import 'package:cockpit/core/widgets/app_error_view.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_loader.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/features/audit/presentation/controllers/audit_controller.dart';
import 'package:cockpit/features/audit/presentation/widgets/audit_timeline_tile.dart';

/// Audit log screen.
class AuditScreen extends ConsumerWidget {
  /// Creates the screen.
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final entries = ref.watch(filteredAuditEntriesProvider);

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.auditTitle,
        bottom: const _FilterChips(),
      ),
      body: switch (entries) {
        AsyncData(:final value) when value.isEmpty => AppEmptyView(
            icon: AppIcons.list,
            title: l10n.noAuditEntries,
          ),
        AsyncData(:final value) => RefreshIndicator(
            color: context.colors.accent,
            backgroundColor: context.colors.surface,
            onRefresh: () => ref.refresh(auditControllerProvider.future),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(spacing.screenPadding),
              itemCount: value.length,
              itemBuilder: (context, index) => AuditTimelineTile(
                key: ValueKey(value[index].id),
                entry: value[index],
                isLast: index == value.length - 1,
              ),
            ),
          ),
        AsyncError(:final error) => AppErrorView(
            message: context.failureMessage(error),
            onRetry: () => ref.invalidate(auditControllerProvider),
          ),
        _ => const AppLoader(),
      },
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final selected = ref.watch(auditFilterProvider);
    final labels = {
      AuditFilter.all: l10n.filterAll,
      AuditFilter.approved: l10n.statusApproved,
      AuditFilter.rejected: l10n.statusRejected,
    };

    return Wrap(
      spacing: spacing.sm - spacing.xxs / 2,
      runSpacing: spacing.sm - spacing.xxs / 2,
      children: [
        for (final MapEntry(key: filter, value: label) in labels.entries)
          AppChip(
            key: ValueKey(filter),
            label: label,
            selected: filter == selected,
            onSelected: () =>
                ref.read(auditFilterProvider.notifier).choose(filter),
          ),
      ],
    );
  }
}
