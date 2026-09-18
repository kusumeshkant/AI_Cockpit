// Feature: actions · Layer: presentation
// Loads one action and submits decisions. A decision attempt keeps the same
// idempotency key until it succeeds, so retries never double-decide (TR-3).
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/domain/usecases/decide_action.dart';
import 'package:cockpit/features/actions/domain/usecases/get_action_detail.dart';

/// Action detail controller, keyed by action id.
class ActionDetailController extends AsyncNotifier<ActionItem> {
  /// Creates the controller for [actionId].
  ActionDetailController(this.actionId);

  /// The action being reviewed.
  final String actionId;

  String? _attemptKey;

  @override
  Future<ActionItem> build() async {
    final result = await getIt<GetActionDetail>()(actionId);
    return result.fold((failure) => throw failure, (item) => item);
  }

  /// Submits a decision. Returns `null` on success or the [Failure].
  Future<Failure?> decide(
    DecisionType type, {
    Map<String, dynamic>? editedPayload,
    String? reason,
  }) async {
    _attemptKey ??= _newIdempotencyKey();
    final result = await getIt<DecideAction>()(
      ActionDecision(
        actionId: actionId,
        type: type,
        idempotencyKey: _attemptKey!,
        editedPayload: editedPayload,
        reason: reason,
      ),
    );
    return result.fold((failure) => failure, (_) {
      _attemptKey = null;
      ref.invalidateSelf();
      return null;
    });
  }

  static String _newIdempotencyKey() {
    final random = Random.secure();
    return List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }
}

/// Detail state for a given action id.
final actionDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<ActionDetailController, ActionItem, String>(
  ActionDetailController.new,
);
