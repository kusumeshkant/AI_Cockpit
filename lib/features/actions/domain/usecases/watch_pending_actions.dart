// Feature: actions · Layer: domain
// Use case: observe the pending actions feed.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/domain/repositories/actions_repository.dart';

/// Streams pending actions.
@lazySingleton
class WatchPendingActions {
  /// Creates the use case.
  const WatchPendingActions(this._repository);

  final ActionsRepository _repository;

  /// Emits the pending list whenever it changes.
  Stream<Either<Failure, List<ActionItem>>> call() {
    // TODO(feature/actions): sort newest first; drop expired items.
    return _repository.watchPendingActions();
  }
}
