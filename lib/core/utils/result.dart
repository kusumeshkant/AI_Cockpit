// The return type of every repository and use case. Pure Dart.
import 'package:dartz/dartz.dart';

import 'package:cockpit/core/error/failures.dart';

/// Asynchronous result: `Left(Failure)` or `Right(T)`.
typedef Result<T> = Future<Either<Failure, T>>;
