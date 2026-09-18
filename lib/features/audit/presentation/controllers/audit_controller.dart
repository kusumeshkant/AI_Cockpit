// Feature: audit · Layer: presentation
// Audit timeline: decision entries, filterable by outcome.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/audit/domain/usecases/get_audit_entries.dart';

/// Outcome filter for the timeline.
enum AuditFilter {
  /// Every decision.
  all,

  /// Approved (with or without edits).
  approved,

  /// Rejected.
  rejected,
}

/// Loads decision entries (newest first).
class AuditController extends AsyncNotifier<List<AuditEntry>> {
  @override
  Future<List<AuditEntry>> build() async {
    // Reload for a different signed-in user (tabs stay alive in the shell).
    ref.watch(authControllerProvider.select((auth) => auth.value?.id));
    final result = await getIt<GetAuditEntries>()();
    // TODO(feature/audit): paging (loadMore), agent filter, callback events.
    return result.fold(
      (failure) => throw failure,
      (entries) => entries
          .where((entry) => entry.event == AuditEvent.decisionMade)
          .toList(growable: false),
    );
  }
}

/// All decision entries.
final auditControllerProvider =
    AsyncNotifierProvider<AuditController, List<AuditEntry>>(
  AuditController.new,
);

/// Selected outcome filter.
class AuditFilterController extends Notifier<AuditFilter> {
  @override
  AuditFilter build() => AuditFilter.all;

  /// Selects [filter].
  void choose(AuditFilter filter) => state = filter;
}

/// Current audit filter.
final auditFilterProvider =
    NotifierProvider<AuditFilterController, AuditFilter>(
  AuditFilterController.new,
);

/// Entries matching the current filter.
final filteredAuditEntriesProvider = Provider<AsyncValue<List<AuditEntry>>>((ref) {
  final filter = ref.watch(auditFilterProvider);
  return ref.watch(auditControllerProvider).whenData(
        (entries) => switch (filter) {
          AuditFilter.all => entries,
          AuditFilter.approved =>
            entries.where((entry) => !entry.isRejection).toList(growable: false),
          AuditFilter.rejected =>
            entries.where((entry) => entry.isRejection).toList(growable: false),
        },
      );
});
