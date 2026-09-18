// Feature: actions · Layer: data
// ActionsRepository implementation.
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/actions/data/datasources/actions_remote_ds.dart';
import 'package:cockpit/features/actions/data/models/action_item_dto.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/domain/repositories/actions_repository.dart';

/// Default [ActionsRepository].
@LazySingleton(as: ActionsRepository)
class ActionsRepositoryImpl implements ActionsRepository {
  /// Creates the repository.
  const ActionsRepositoryImpl(this._remote);

  final ActionsRemoteDataSource _remote;

  @override
  Stream<Either<Failure, List<ActionItem>>> watchPendingActions() {
    return _remote.watchPending().transform(
          StreamTransformer<List<ActionItemDto>, Either<Failure, List<ActionItem>>>.fromHandlers(
            handleData: (dtos, sink) => sink.add(
              Right(dtos.map((dto) => dto.toEntity()).toList(growable: false)),
            ),
            handleError: (error, stack, sink) => sink.add(Left(mapError(error, stack))),
          ),
        );
  }

  @override
  Result<List<ActionItem>> fetchPendingActions() => guard(() async {
        final dtos = await _remote.fetchPending();
        return dtos.map((dto) => dto.toEntity()).toList(growable: false);
      });

  @override
  Result<ActionItem> getActionDetail(String id) =>
      guard(() async => (await _remote.getById(id)).toEntity());

  @override
  Result<Unit> decide(ActionDecision decision) => guard(() async {
        await _remote.postDecision(decision);
        return unit;
      });
}
