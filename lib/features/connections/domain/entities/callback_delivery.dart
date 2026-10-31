// Feature: connections · Layer: domain
// The latest callback delivery to an agent (agent detail): derived from the
// audit trail's callback events (TR-6 / TR-7). Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'callback_delivery.freezed.dart';

/// Outcome of the latest callback attempt.
enum CallbackDeliveryState {
  /// The agent's callback URL accepted the decision.
  delivered,

  /// The attempt failed and another one is scheduled (TR-7 backoff).
  retrying,

  /// Delivery failed.
  failed,
}

/// The latest callback delivery to an agent.
@freezed
abstract class CallbackDelivery with _$CallbackDelivery {
  /// Creates a [CallbackDelivery].
  const factory CallbackDelivery({
    required CallbackDeliveryState state,
    required DateTime at,
  }) = _CallbackDelivery;
}
