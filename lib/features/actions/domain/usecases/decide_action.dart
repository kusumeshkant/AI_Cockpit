// Feature: actions · Layer: domain
// Use case: approve, approve with edits, or reject an action.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/repositories/actions_repository.dart';

/// Submits a decision.
@lazySingleton
class DecideAction {
  /// Creates the use case.
  const DecideAction(this._repository);

  final ActionsRepository _repository;

  /// Submits [decision].
  Result<Unit> call(ActionDecision decision) {
    // TODO(feature/actions): enforce editedPayload only for approvedWithEdits
    // and reason length ≤ 500 before calling the repository.
    return _repository.decide(decision);
  }
}
