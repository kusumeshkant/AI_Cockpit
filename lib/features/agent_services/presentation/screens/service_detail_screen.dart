// Feature: agent_services · Layer: presentation
// Service detail (Connections → Services → a service): name, description,
// status, calm banners (paused, app too old), and Enable (consent first) /
// Disable (confirm). Blocked or unknown access reads exactly like "not
// available for your account" — never why. Release A: an enabled service
// shows a neutral "Ready"; its own screens come in the next step.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/config/app_links.dart';
import 'package:cockpit/core/config/config_providers.dart';
import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_banner.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_empty_view.dart';
import 'package:cockpit/core/widgets/app_error_view.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_loader.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/presentation/controllers/agent_services_controller.dart';
import 'package:cockpit/features/agent_services/presentation/widgets/service_consent_sheet.dart';
import 'package:cockpit/features/agent_services/presentation/widgets/services_section.dart';

/// Service detail screen.
class ServiceDetailScreen extends ConsumerStatefulWidget {
  /// Creates the screen for [slug].
  const ServiceDetailScreen({required this.slug, super.key});

  /// The service shown.
  final String slug;

  @override
  ConsumerState<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  bool _busy = false;

  void _close() {
    final router = GoRouter.maybeOf(context);
    if (router != null && router.canPop()) {
      router.pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  Future<void> _enable(AgentService service) async {
    if (!await showServiceConsent(context, service.displayName) || !mounted) return;
    await _act(() => ref.read(agentServicesControllerProvider.notifier).enable(service.slug), context.l10n.serviceEnabledToast);
  }

  Future<void> _disable(AgentService service) async {
    if (!await confirmServiceDisable(context, service.displayName) || !mounted) return;
    await _act(() => ref.read(agentServicesControllerProvider.notifier).disable(service.slug), context.l10n.serviceDisabledToast);
  }

  Future<void> _act(Future<Object?> Function() action, String success) async {
    setState(() => _busy = true);
    final failure = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    _toast(failure == null ? success : context.failureMessage(failure));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final all = ref.watch(agentServicesControllerProvider);
    final listing = ref.watch(serviceListingProvider(widget.slug));
    final updateRequired = ref.watch(serviceUpdateRequiredProvider(widget.slug));
    final availability = listing?.availability;

    final Widget? action = switch (availability) {
      ServiceAvailability.notEnabled when !updateRequired => AppButton(
          key: const Key('serviceDetail.enable'),
          label: l10n.serviceEnable,
          expand: true,
          isLoading: _busy,
          onPressed: () => _enable(listing!.service),
        ),
      ServiceAvailability.enabled || ServiceAvailability.paused => AppButton(
          key: const Key('serviceDetail.disable'),
          label: l10n.serviceDisable,
          variant: AppButtonVariant.danger,
          expand: true,
          isLoading: _busy,
          onPressed: () => _disable(listing!.service),
        ),
      _ => null,
    };

    return AppScaffold(
      topBar: AppTopBar.back(title: listing?.service.displayName ?? '', onBack: _close),
      bottomBar: action == null ? null : AppBottomBar(child: action),
      body: switch (all) {
        _ when listing != null => RefreshIndicator(
            color: context.colors.accent,
            backgroundColor: context.colors.surface,
            onRefresh: () => ref.read(agentServicesControllerProvider.notifier).refresh(),
            child: _Body(listing: listing, updateRequired: updateRequired),
          ),
        AsyncData() => AppEmptyView(icon: AppIcons.grid, title: l10n.serviceNotListed),
        AsyncError(:final error) => AppErrorView(
            message: context.failureMessage(error),
            onRetry: () => ref.invalidate(agentServicesControllerProvider),
          ),
        _ => const AppLoader(),
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.listing, required this.updateRequired});

  final ServiceListing listing;
  final bool updateRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final service = listing.service;
    final availability = listing.availability;
    final (label, tone) = serviceStatus(context, availability);
    final gap = SizedBox(height: spacing.cardGap);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing.screenPadding),
      children: [
        AppCard(
          child: Row(
            children: [
              Container(
                width: spacing.tileSize,
                height: spacing.tileSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: colors.accentWash, borderRadius: BorderRadius.circular(spacing.radiusButton)),
                child: AppIcon(serviceIcon(service.icon), size: spacing.iconMd, color: colors.accent),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text(service.displayName, style: context.textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              SizedBox(width: spacing.sm),
              StatusPill(key: const Key('serviceDetail.status'), label: label, tone: tone),
            ],
          ),
        ),
        if (service.description.isNotEmpty) ...[
          gap,
          Text(service.description, style: context.textTheme.bodyMedium),
        ],
        if (updateRequired) ...[
          gap,
          AppBanner(key: const Key('serviceDetail.updateBanner'), icon: AppIcons.alert, message: l10n.serviceUpdateBanner),
          SizedBox(height: spacing.sm),
          AppButton(
            key: const Key('serviceDetail.update'),
            label: l10n.serviceUpdateAction,
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: () => ref.read(externalUrlOpenerProvider)(AppLinks.playStoreListing),
          ),
        ],
        if (availability == ServiceAvailability.paused) ...[
          gap,
          AppBanner(key: const Key('serviceDetail.pausedBanner'), icon: AppIcons.alert, message: l10n.servicePausedBanner),
        ],
        if (availability == ServiceAvailability.unavailable) ...[
          gap,
          AppBanner(key: const Key('serviceDetail.unavailable'), icon: AppIcons.alert, message: l10n.errorServiceNotEnabled),
        ],
        if (availability == ServiceAvailability.enabled) ...[
          gap,
          Text(l10n.serviceReady, key: const Key('serviceDetail.ready'), style: context.textTheme.bodyMedium?.copyWith(color: colors.muted)),
        ],
      ],
    );
  }
}
