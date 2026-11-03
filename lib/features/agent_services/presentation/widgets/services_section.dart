// Feature: agent_services · Layer: presentation
// "Services" section of Connections (owner, server flag on, ≥ 1 service): one
// row per service with its status. Only built while servicesVisibleProvider
// is true, so with the flag off Connections renders exactly as before.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/section_label.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/presentation/controllers/agent_services_controller.dart';

/// The icon for a service's `icon` name (unknown names → a neutral tile).
AppIcons serviceIcon(String? name) => switch (name) {
      'mail' => AppIcons.mail,
      'list' => AppIcons.list,
      'pencil' => AppIcons.pencil,
      _ => AppIcons.grid,
    };

/// Label + tone of an availability.
(String, StatusTone) serviceStatus(BuildContext context, ServiceAvailability availability) {
  final l10n = context.l10n;
  return switch (availability) {
    ServiceAvailability.enabled => (l10n.serviceStatusEnabled, StatusTone.go),
    ServiceAvailability.paused => (l10n.serviceStatusPaused, StatusTone.pending),
    ServiceAvailability.notEnabled => (l10n.serviceStatusNotEnabled, StatusTone.neutral),
    ServiceAvailability.unavailable => (l10n.serviceStatusUnavailable, StatusTone.stop),
  };
}

/// The Services section.
class ServicesSection extends ConsumerWidget {
  /// Creates the section.
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final listings = ref.watch(agentServicesControllerProvider).value ?? const <ServiceListing>[];
    return Column(
      key: const Key('services.section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(context.l10n.servicesSectionTitle),
        SizedBox(height: spacing.sm),
        for (final listing in listings) ...[
          ServiceRow(key: ValueKey('service.${listing.service.slug}'), listing: listing),
          SizedBox(height: spacing.cardGap),
        ],
      ],
    );
  }
}

/// One service row; opens its detail.
class ServiceRow extends StatelessWidget {
  /// Creates the row.
  const ServiceRow({required this.listing, super.key});

  /// The service shown.
  final ServiceListing listing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final service = listing.service;
    final (label, tone) = serviceStatus(context, listing.availability);
    final on = listing.availability == ServiceAvailability.enabled;

    return RepaintBoundary(
      child: Semantics(
        button: true,
        label: context.l10n.serviceRowSemantics(service.displayName, label),
        excludeSemantics: true,
        child: AppCard(
          onTap: () => context.goNamed(RouteNames.serviceDetail, pathParameters: {'slug': service.slug}),
          child: Row(
            children: [
              Container(
                width: spacing.tileSize,
                height: spacing.tileSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: on ? colors.accentWash : colors.paper,
                  borderRadius: BorderRadius.circular(spacing.radiusButton),
                ),
                child: AppIcon(serviceIcon(service.icon), size: spacing.iconMd, color: on ? colors.accent : colors.muted),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.textTheme.titleSmall),
                    if (service.description.isNotEmpty)
                      Text(
                        service.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(color: colors.muted),
                      ),
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              StatusPill.bare(label: label, tone: tone),
            ],
          ),
        ),
      ),
    );
  }
}
