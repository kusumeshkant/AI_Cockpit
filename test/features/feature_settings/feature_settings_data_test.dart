import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/feature_settings/data/datasources/feature_settings_ds.dart';
import 'package:cockpit/features/feature_settings/data/models/feature_setting_dto.dart';
import 'package:cockpit/features/feature_settings/data/repositories/feature_settings_repository_impl.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';
import 'package:cockpit/features/feature_settings/domain/repositories/feature_settings_repository.dart';
import 'package:cockpit/features/feature_settings/domain/usecases/get_feature_settings.dart';

class _MockSource extends Mock implements FeatureSettingsDataSource {}

class _MockRepository extends Mock implements FeatureSettingsRepository {}

void main() {
  group('FeatureSettingDto', () {
    test('parses a feature_setting row (snake_case, nullable min version)', () {
      final dto = FeatureSettingDto.fromJson(const {
        'key': 'agent_triggers',
        'enabled': true,
        'min_app_version': '0.2.0',
      });
      expect(
        dto.toEntity(),
        const FeatureSetting(key: 'agent_triggers', enabled: true, minAppVersion: '0.2.0'),
      );
      expect(
        FeatureSettingDto.fromJson(const {'key': 'agent_services', 'enabled': false}).toEntity(),
        const FeatureSetting(key: 'agent_services', enabled: false),
      );
    });
  });

  group('FeatureSettingsRepositoryImpl', () {
    late _MockSource source;
    late FeatureSettingsRepositoryImpl repository;

    setUp(() {
      source = _MockSource();
      repository = FeatureSettingsRepositoryImpl(source);
    });

    test('success → the rows as entities', () async {
      when(() => source.fetchAll()).thenAnswer(
        (_) async => const [
          FeatureSettingDto(key: 'agent_triggers', enabled: true),
          FeatureSettingDto(key: 'agent_services', minAppVersion: '1.0.0'),
        ],
      );
      final result = await repository.fetchFeatureSettings();
      expect(result.getOrElse(() => const []), const [
        FeatureSetting(key: 'agent_triggers', enabled: true),
        FeatureSetting(key: 'agent_services', enabled: false, minAppVersion: '1.0.0'),
      ]);
    });

    test('a Postgrest error (e.g. signed out: 42501) → Failure, never throws', () async {
      when(() => source.fetchAll()).thenThrow(
        const PostgrestException(message: 'permission denied', code: '42501'),
      );
      final result = await repository.fetchFeatureSettings();
      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<Failure>());
    });
  });

  test('demo datasource: Agent Triggers on, agent services off', () async {
    final rows = await const FeatureSettingsDemoDataSource().fetchAll();
    expect({for (final r in rows) r.key: r.enabled}, {
      FeatureKeys.agentTriggers: true,
      FeatureKeys.agentServices: false,
    });
  });

  test('GetFeatureSettings delegates to the repository', () async {
    final repository = _MockRepository();
    const settings = [FeatureSetting(key: 'agent_triggers', enabled: true)];
    when(repository.fetchFeatureSettings).thenAnswer((_) async => const Right(settings));
    final result = await GetFeatureSettings(repository)();
    expect(result, const Right<Failure, List<FeatureSetting>>(settings));
    verify(repository.fetchFeatureSettings).called(1);
  });

  group('FeatureSetting.isOnFor', () {
    const on = FeatureSetting(key: 'k', enabled: true);
    test('disabled is off whatever the version', () {
      expect(const FeatureSetting(key: 'k', enabled: false).isOnFor('9.9.9'), isFalse);
    });
    test('no min version → on', () => expect(on.isOnFor('0.1.0'), isTrue));
    test('min version compares numerically (x.y.z)', () {
      final gated = on.copyWith(minAppVersion: '0.10.0');
      expect(gated.isOnFor('0.9.9'), isFalse);
      expect(gated.isOnFor('0.10.0'), isTrue);
      expect(gated.isOnFor('0.10.1+5'), isTrue, reason: 'build suffix ignored');
      expect(gated.isOnFor('1.0.0'), isTrue);
    });
    test('unparseable versions fail closed', () {
      expect(on.copyWith(minAppVersion: '0.1.0').isOnFor('dev'), isFalse);
      expect(on.copyWith(minAppVersion: 'x').isOnFor('1.0.0'), isFalse);
    });
  });
}
