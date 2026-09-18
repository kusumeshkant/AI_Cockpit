// Feature: actions · Layer: domain
// Contract for reading pending actions and submitting decisions.
import 'package:dartz/dartz.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';

/// Action operations.
abstract interface class ActionsRepository {
  /// Live pending actions: realtime updates reconciled with polling (TR-4).
  Stream<Either<Failure, List<ActionItem>>> watchPendingActions();

  /// One-off fetch of pending actions (pull-to-refresh / resume).
  Result<List<ActionItem>> fetchPendingActions();

  /// Loads a single action by [id].
  Result<ActionItem> getActionDetail(String id);

  /// Submits [decision] idempotently (TR-3).
  Result<Unit> decide(ActionDecision decision);
}
