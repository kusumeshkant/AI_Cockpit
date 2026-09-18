// Feature: actions · Layer: presentation
// Home feed.
//  * phone (Main.dc.html, FeedDark.dc.html): "Pending" header with amber
//    review count and settings gear, pull-to-refresh list of action cards;
//    tapping opens the detail screen.
//  * wide content (TabletFeed.dc.html): 340px list column + detail pane with
//    the same review surface; tapping selects instead of navigating.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/responsive/breakpoints.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_empty_view.dart';
import 'package:cockpit/core/widgets/app_error_view.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_loader.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';
import 'package:cockpit/features/actions/presentation/controllers/actions_feed_controller.dart';
import 'package:cockpit/features/actions/presentation/controllers/selected_action_controller.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_card.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_review.dart';
import 'package:cockpit/features/actions/presentation/widgets/action_status_pill.dart';

/// Pending actions feed.
class ActionsFeedScreen extends StatelessWidget {
  /// Creates the screen.
  const ActionsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth >= Breakpoints.masterDetailMinWidth
              ? const _MasterDetailFeed()
              : const _PhoneFeed(),
    );
  }
}

/// Loading / error / empty handling shared by both layouts.
class _FeedStates extends ConsumerWidget {
  const _FeedStates({required this.builder});

  final Widget Function(List<ActionItem> items) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return switch (ref.watch(actionsFeedControllerProvider)) {
      AsyncData(:final value) when value.isEmpty => AppEmptyView(
          title: l10n.emptyPendingTitle,
          message: l10n.emptyPendingMessage,
        ),
      AsyncData(:final value) => builder(value),
      AsyncError(:final error) => AppErrorView(
          message: context.failureMessage(error),
          onRetry: () => ref.invalidate(actionsFeedControllerProvider),
        ),
      _ => const AppLoader(),
    };
  }
}

class _PhoneFeed extends StatelessWidget {
  const _PhoneFeed();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.feedTitle,
        subtitle: const _ReviewCount(),
        trailing: AppIconButton(
          icon: AppIcons.gear,
          tooltip: l10n.navSettings,
          onPressed: () => context.goNamed(RouteNames.settings),
        ),
      ),
      body: _FeedStates(
        builder: (items) => _FeedList(
          items: items,
          padding: EdgeInsets.all(context.spacing.screenPadding),
          onTap: (item) => context.goNamed(
            RouteNames.actionDetail,
            pathParameters: {'id': item.id},
          ),
        ),
      ),
    );
  }
}

class _MasterDetailFeed extends ConsumerWidget {
  const _MasterDetailFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    ref.watch(selectedActionIdProvider);
    final selection = ref.read(selectedActionIdProvider.notifier);
    final items = ref.watch(actionsFeedControllerProvider).value ?? const [];
    final selectedId = selection.resolve(items);

    return Scaffold(
      backgroundColor: colors.paper,
      body: SafeArea(
        left: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: colors.line)),
              ),
              child: SizedBox(
                width: spacing.listPaneWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        spacing.lg + spacing.xxs,
                        spacing.xl - spacing.xxs,
                        spacing.lg + spacing.xxs,
                        spacing.screenPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              context.l10n.feedTitle,
                              style: context.textTheme.displayLarge,
                            ),
                          ),
                          SizedBox(height: spacing.xxs),
                          const _ReviewCount(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _FeedStates(
                        builder: (items) => _FeedList(
                          items: items,
                          selectedId: selectedId,
                          showPreview: false,
                          padding: EdgeInsets.fromLTRB(
                            spacing.screenPadding,
                            0,
                            spacing.screenPadding,
                            spacing.screenPadding,
                          ),
                          onTap: (item) => selection.choose(item.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: selectedId == null
                  ? const SizedBox.shrink()
                  : _DetailPane(
                      key: ValueKey(selectedId),
                      actionId: selectedId,
                      onDecided: () {
                        final next = items.where(
                          (item) => item.isPending && item.id != selectedId,
                        );
                        if (next.isNotEmpty) selection.choose(next.first.id);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailPane extends ConsumerWidget {
  const _DetailPane({
    required this.actionId,
    required this.onDecided,
    super.key,
  });

  final String actionId;
  final VoidCallback onDecided;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(actionDetailControllerProvider(actionId));
    return switch (detail) {
      AsyncData(:final value) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailPaneHeader(item: value),
            Expanded(
              child: ActionReview(
                item: value,
                wide: true,
                showTitle: false,
                onDecided: onDecided,
              ),
            ),
          ],
        ),
      AsyncError(:final error) => AppErrorView(
          message: context.failureMessage(error),
          onRetry: () => ref.invalidate(actionDetailControllerProvider(actionId)),
        ),
      _ => const AppLoader(),
    };
  }
}

class _DetailPaneHeader extends StatelessWidget {
  const _DetailPaneHeader({required this.item});

  final ActionItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.xl,
          spacing.xl - spacing.xxs,
          spacing.xl,
          spacing.lg,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(item.title, style: context.textTheme.titleLarge),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    context.sourceLabel(item.agentPlatform, item.agentName),
                    style: context.textTheme.labelMedium?.copyWith(
                      color: colors.muted,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.md),
            ActionStatusPill(item: item),
          ],
        ),
      ),
    );
  }
}

class _ReviewCount extends ConsumerWidget {
  const _ReviewCount();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final count = ref.watch(pendingCountProvider);
    final color = count > 0 ? colors.pending : colors.muted;

    return Row(
      children: [
        if (count > 0) ...[
          SizedBox.square(
            dimension: spacing.dotSm + spacing.xxs / 2,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          SizedBox(width: spacing.xs + spacing.xxs),
        ],
        Flexible(
          child: Text(
            context.l10n.needsReviewCount(count),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.monoLabel.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _FeedList extends ConsumerWidget {
  const _FeedList({
    required this.items,
    required this.padding,
    required this.onTap,
    this.selectedId,
    this.showPreview = true,
  });

  final List<ActionItem> items;
  final EdgeInsetsGeometry padding;
  final ValueChanged<ActionItem> onTap;
  final String? selectedId;
  final bool showPreview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    return RefreshIndicator(
      color: context.colors.accent,
      backgroundColor: context.colors.surface,
      onRefresh: () => ref.read(actionsFeedControllerProvider.notifier).refresh(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: spacing.cardGap),
        itemBuilder: (context, index) {
          final item = items[index];
          return ActionItemCard(
            key: ValueKey(item.id),
            item: item,
            selected: item.id == selectedId,
            showPreview: showPreview,
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}
