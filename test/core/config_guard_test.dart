// Fail-closed config (F04): a non-debug prod build without a backend must not
// start (it would otherwise run on demo data); dev and debug keep demo mode.
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/config/flavor.dart';

AppConfig _config(Flavor flavor, {String url = '', String key = ''}) => AppConfig(
      flavor: flavor,
      supabaseUrl: url,
      supabaseAnonKey: key,
      sentryDsn: '',
      posthogKey: '',
      firebaseEnabled: false,
    );

void main() {
  group('resolveFlavor', () {
    test('the native build flavor wins over the FLAVOR define', () {
      expect(AppConfig.resolveFlavor(buildFlavor: 'prod', defineFlavor: 'dev'), Flavor.prod);
      expect(AppConfig.resolveFlavor(buildFlavor: 'dev', defineFlavor: 'prod'), Flavor.dev);
    });

    test('falls back to the FLAVOR define without a build flavor', () {
      expect(AppConfig.resolveFlavor(buildFlavor: null, defineFlavor: 'prod'), Flavor.prod);
      expect(AppConfig.resolveFlavor(buildFlavor: null, defineFlavor: 'dev'), Flavor.dev);
    });
  });

  group('blocksStartup', () {
    test('prod release/profile without a backend does not start', () {
      expect(_config(Flavor.prod).blocksStartup(debugBuild: false), isTrue);
      expect(_config(Flavor.prod, url: 'https://x.example').blocksStartup(debugBuild: false), isTrue,
          reason: 'the anon key is missing');
      expect(_config(Flavor.prod, key: 'k').blocksStartup(debugBuild: false), isTrue,
          reason: 'the URL is missing');
    });

    test('prod with a backend starts', () {
      final config = _config(Flavor.prod, url: 'https://x.example', key: 'k');
      expect(config.blocksStartup(debugBuild: false), isFalse);
    });

    test('dev keeps demo mode in every build mode', () {
      expect(_config(Flavor.dev).blocksStartup(debugBuild: false), isFalse);
      expect(_config(Flavor.dev).blocksStartup(debugBuild: true), isFalse);
    });

    test('debug prod builds keep demo mode', () {
      expect(_config(Flavor.prod).blocksStartup(debugBuild: true), isFalse);
    });
  });
}
