// get_it + injectable wiring for data and domain classes. Riverpod exposes
// these to the UI; it does not construct them. Run build_runner after adding
// an @injectable / @lazySingleton class.
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/di/injection.config.dart';

/// Global service locator.
final GetIt getIt = GetIt.instance;

/// Registers all annotated dependencies. With [demo] true, in-memory demo
/// data sources replace the live Supabase ones.
@InjectableInit()
void configureDependencies({required bool demo}) => getIt.init(
      environment: demo ? AppEnvironments.demo : AppEnvironments.live,
    );
