// Feature: connections · Layer: data
// Wire model for the latest `audit_entry` callback event of an agent.
import 'package:cockpit/features/connections/domain/entities/callback_delivery.dart';

/// A `callback_*` audit row (event + time only).
class CallbackEventDto {
  /// Creates a DTO.
  const CallbackEventDto({required this.event, required this.createdAt});

  /// Parses a REST row.
  factory CallbackEventDto.fromJson(Map<String, dynamic> json) => CallbackEventDto(
        event: json['event'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  /// The callback was accepted.
  static const String delivered = 'callback_delivered';

  /// The callback failed; a retry is scheduled.
  static const String attempted = 'callback_attempted';

  /// The callback failed.
  static const String failed = 'callback_failed';

  /// Every callback event, for the REST filter.
  static const List<String> events = [delivered, attempted, failed];

  /// Audit event name.
  final String event;

  /// When the attempt was recorded.
  final DateTime createdAt;

  /// Maps to the domain entity.
  CallbackDelivery toEntity() => CallbackDelivery(
        state: switch (event) {
          delivered => CallbackDeliveryState.delivered,
          attempted => CallbackDeliveryState.retrying,
          _ => CallbackDeliveryState.failed,
        },
        at: createdAt,
      );
}
