// Feature: audit · Layer: data
// In-memory demo audit trail (AppEnvironments.demo), seeded with the entries
// in technical/design/Audit.dc.html.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/audit/data/datasources/audit_remote_ds.dart';
import 'package:cockpit/features/audit/data/models/audit_entry_dto.dart';

/// Demo implementation of [AuditRemoteDataSource].
@LazySingleton(as: AuditRemoteDataSource, env: [AppEnvironments.demo])
class AuditDemoDataSource implements AuditRemoteDataSource {
  /// Creates the datasource.
  AuditDemoDataSource();

  List<AuditEntryDto> _seed(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return [
      AuditEntryDto(
        id: '4',
        actionId: 'act_priya_refund',
        event: 'decision_made',
        decision: 'approved_with_edits',
        actionTitle: 'Reply to Priya',
        agentName: 'Email agent',
        agentPlatform: 'n8n',
        editedPayload: const {'subject': 'Re: Refund for order #DQ-2291'},
        createdAt: today.add(const Duration(hours: 7, minutes: 4)),
      ),
      AuditEntryDto(
        id: '3',
        actionId: 'act_delete_records',
        event: 'decision_made',
        decision: 'rejected',
        actionTitle: 'Delete 40 records',
        agentName: 'Data bot',
        agentPlatform: 'make',
        reason: 'too risky',
        createdAt: today.subtract(const Duration(hours: 6)),
      ),
      AuditEntryDto(
        id: '2',
        actionId: 'act_invoice_12300',
        event: 'decision_made',
        decision: 'approved',
        actionTitle: 'Post invoice ₹12,300',
        agentName: 'Finance bot',
        agentPlatform: 'make',
        createdAt: today.subtract(const Duration(hours: 9)),
      ),
      AuditEntryDto(
        id: '1',
        actionId: 'act_leads_5',
        event: 'decision_made',
        decision: 'approved',
        actionTitle: 'Add 5 leads',
        agentName: 'Leads bot',
        agentPlatform: 'custom',
        createdAt: today.subtract(const Duration(days: 4, hours: 3)),
      ),
    ];
  }

  @override
  Future<List<AuditEntryDto>> fetchEntries({
    required int offset,
    required int limit,
    String? agentId,
  }) async =>
      _seed(DateTime.now()).skip(offset).take(limit).toList(growable: false);
}
