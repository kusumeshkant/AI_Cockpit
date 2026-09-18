// Feature: actions · Layer: domain
// Use case: load one action for review.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/domain/repositories/actions_repository.dart';

/// Loads an action by id.
@lazySingleton
class GetActionDetail {
  /// Creates the use case.
  const GetActionDetail(this._repository);

  final ActionsRepository _repository;

  /// Returns the action with [id].
  Result<ActionItem> call(String id) => _repository.getActionDetail(id);
}
