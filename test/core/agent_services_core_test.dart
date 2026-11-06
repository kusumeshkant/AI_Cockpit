import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/config/app_version.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/utils/request_id.dart';
import 'package:cockpit/core/utils/semver.dart';

import '../helpers/pump_app.dart';

void main() {
  test('newRequestId: UUID v4 format, unique', () {
    final ids = {for (var i = 0; i < 200; i++) newRequestId()};
    expect(ids, hasLength(200));
    for (final id in ids) {
      expect(isRequestId(id), isTrue, reason: id);
    }
    expect(isRequestId('not-a-uuid'), isFalse);
  });

  test('version compare: numeric, suffix ignored, fail closed on garbage', () {
    expect(isVersionBelow('0.1.1', null), isFalse);
    expect(isVersionBelow('0.1.1', '0.2.0'), isTrue);
    expect(isVersionBelow('0.2.0', '0.2.0'), isFalse);
    expect(isVersionBelow('0.10.0', '0.9.9'), isFalse);
    expect(isVersionBelow('1.0.0+12', '1.0.0'), isFalse);
    expect(isVersionBelow('dev', '0.1.0'), isTrue);
    expect(isVersionBelow('1.0.0', 'garbage'), isFalse, reason: 'an unreadable minimum gates nothing');
  });

  test('appVersionProvider: falls back to APP_VERSION without a version source; overridable', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(installedAppVersionProvider.future);
    expect(container.read(appVersionProvider), AppConfig.appVersion);

    final overridden = ProviderContainer(overrides: [appVersionProvider.overrideWithValue('9.9.9')]);
    addTearDown(overridden.dispose);
    expect(overridden.read(appVersionProvider), '9.9.9');
  });

  test('demo version source is fixed', () async {
    expect(await const DemoAppVersionSource().version(), DemoAppVersionSource.demoVersion);
  });

  test('package version source never throws (falls back without a platform)', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final version = await PackageAppVersionSource().version();
    expect(version, isNotEmpty);
  });

  test('ARB parity: en and hi have the same keys, with the same placeholders', () {
    Map<String, dynamic> load(String lang) =>
        jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync()) as Map<String, dynamic>;
    final en = load('en');
    final hi = load('hi');
    Set<String> keys(Map<String, dynamic> m) => {for (final k in m.keys) if (!k.startsWith('@')) k};
    expect(keys(hi), keys(en));
    final placeholder = RegExp(r'\{(\w+)\}');
    for (final key in keys(en)) {
      final want = {for (final m in placeholder.allMatches(en[key] as String)) m.group(1)};
      final have = {for (final m in placeholder.allMatches(hi[key] as String)) m.group(1)};
      expect(have, want, reason: key);
      expect((hi[key] as String).trim(), isNotEmpty, reason: key);
    }
  });

  testWidgets('every gateway failure has its own calm message (en + hi), never the raw code', (tester) async {
    const failures = <Failure>[
      AgentUnavailableFailure(), AgentTimeoutFailure(), AgentErrorFailure(), AgentPausedFailure(),
      TrialEndedFailure(), QuotaReachedFailure(), ApprovalBlockedFailure(), UnsupportedOpFailure(),
      AppUpdateRequiredFailure(), ServiceNotFoundFailure(), ServiceNotEnabledFailure(), IdeaFinalFailure(),
    ];
    for (final locale in const [Locale('en'), Locale('hi')]) {
      late List<String> messages;
      late String generic;
      await pumpApp(
        tester,
        Builder(builder: (context) {
          messages = [for (final f in failures) context.failureMessage(f)];
          generic = context.failureMessage(Object());
          return const SizedBox();
        }),
        locale: locale,
      );
      expect(messages.toSet(), hasLength(failures.length), reason: '$locale: one message each');
      for (var i = 0; i < failures.length; i++) {
        expect(messages[i], isNot(generic), reason: '$locale ${failures[i]}');
        expect(messages[i], isNot(contains('_')), reason: 'no raw code: ${messages[i]}');
      }
    }
  });
}
