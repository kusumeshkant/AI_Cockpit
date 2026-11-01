import 'package:dartz/dartz.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';
import 'package:cockpit/features/feature_settings/domain/usecases/get_feature_settings.dart';

/// Server flags answer: whatever [next] holds; counts the reads.
class FakeGetFeatureSettings implements GetFeatureSettings {
  /// Creates the fake answering [next].
  FakeGetFeatureSettings(this.next);

  /// The next answer (change it to "flip" a server flag).
  Either<Failure, List<FeatureSetting>> next;

  /// Number of reads.
  int calls = 0;

  @override
  Future<Either<Failure, List<FeatureSetting>>> call() async {
    calls++;
    return next;
  }
}

/// A successful read with both seeded flags.
Either<Failure, List<FeatureSetting>> serverFlags({bool triggers = false, bool services = false}) =>
    Right([
      FeatureSetting(key: FeatureKeys.agentTriggers, enabled: triggers),
      FeatureSetting(key: FeatureKeys.agentServices, enabled: services),
    ]);
