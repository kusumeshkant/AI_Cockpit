// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cockpit/core/di/supabase_module.dart' as _i868;
import 'package:cockpit/core/network/auth_interceptor.dart' as _i476;
import 'package:cockpit/core/network/dio_client.dart' as _i846;
import 'package:cockpit/core/network/network_info.dart' as _i194;
import 'package:cockpit/features/actions/data/datasources/action_change_source.dart'
    as _i69;
import 'package:cockpit/features/actions/data/datasources/actions_demo_ds.dart'
    as _i602;
import 'package:cockpit/features/actions/data/datasources/actions_remote_ds.dart'
    as _i854;
import 'package:cockpit/features/actions/data/repositories/actions_repository_impl.dart'
    as _i487;
import 'package:cockpit/features/actions/domain/repositories/actions_repository.dart'
    as _i878;
import 'package:cockpit/features/actions/domain/usecases/decide_action.dart'
    as _i508;
import 'package:cockpit/features/actions/domain/usecases/get_action_detail.dart'
    as _i357;
import 'package:cockpit/features/actions/domain/usecases/watch_pending_actions.dart'
    as _i61;
import 'package:cockpit/features/audit/data/datasources/audit_demo_ds.dart'
    as _i595;
import 'package:cockpit/features/audit/data/datasources/audit_remote_ds.dart'
    as _i850;
import 'package:cockpit/features/audit/data/repositories/audit_repository_impl.dart'
    as _i520;
import 'package:cockpit/features/audit/domain/repositories/audit_repository.dart'
    as _i280;
import 'package:cockpit/features/audit/domain/usecases/get_audit_entries.dart'
    as _i282;
import 'package:cockpit/features/auth/data/datasources/auth_demo_ds.dart'
    as _i898;
import 'package:cockpit/features/auth/data/datasources/auth_remote_ds.dart'
    as _i539;
import 'package:cockpit/features/auth/data/repositories/auth_repository_impl.dart'
    as _i295;
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart'
    as _i90;
import 'package:cockpit/features/auth/domain/usecases/sign_in.dart' as _i238;
import 'package:cockpit/features/auth/domain/usecases/sign_out.dart' as _i1004;
import 'package:cockpit/features/auth/domain/usecases/verify_otp.dart' as _i477;
import 'package:cockpit/features/auth/domain/usecases/watch_auth_state.dart'
    as _i815;
import 'package:cockpit/features/connections/data/datasources/connections_demo_ds.dart'
    as _i1070;
import 'package:cockpit/features/connections/data/datasources/connections_remote_ds.dart'
    as _i941;
import 'package:cockpit/features/connections/data/repositories/connections_repository_impl.dart'
    as _i470;
import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart'
    as _i1045;
import 'package:cockpit/features/connections/domain/usecases/create_agent.dart'
    as _i1045;
import 'package:cockpit/features/connections/domain/usecases/list_agents.dart'
    as _i206;
import 'package:cockpit/features/connections/domain/usecases/send_test_action.dart'
    as _i947;
import 'package:cockpit/features/notifications/data/datasources/fcm_message_ds.dart'
    as _i445;
import 'package:cockpit/features/notifications/data/datasources/fcm_token_ds.dart'
    as _i861;
import 'package:cockpit/features/notifications/data/datasources/push_demo_ds.dart'
    as _i937;
import 'package:cockpit/features/notifications/data/repositories/push_repository_impl.dart'
    as _i440;
import 'package:cockpit/features/notifications/domain/repositories/push_repository.dart'
    as _i56;
import 'package:cockpit/features/notifications/domain/usecases/register_device.dart'
    as _i1053;
import 'package:cockpit/features/notifications/domain/usecases/unregister_device.dart'
    as _i302;
import 'package:cockpit/features/notifications/presentation/local_notifier.dart'
    as _i195;
import 'package:cockpit/features/notifications/presentation/notification_service.dart'
    as _i555;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

const String _demo = 'demo';
const String _live = 'live';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final supabaseModule = _$SupabaseModule();
    gh.lazySingleton<_i850.AuditRemoteDataSource>(
      () => _i595.AuditDemoDataSource(),
      registerFor: {_demo},
    );
    gh.lazySingleton<_i195.LocalNotifier>(
      () => const _i195.NoopLocalNotifier(),
      registerFor: {_demo},
    );
    gh.lazySingleton<_i854.ActionsRemoteDataSource>(
      () => _i602.ActionsDemoDataSource(),
      registerFor: {_demo},
    );
    gh.lazySingleton<_i861.FcmTokenDataSource>(
      () => const _i937.FcmTokenDemoDataSource(),
      registerFor: {_demo},
    );
    gh.lazySingleton<_i539.AuthRemoteDataSource>(
      () => _i898.AuthDemoDataSource(),
      registerFor: {_demo},
    );
    gh.lazySingleton<_i941.ConnectionsRemoteDataSource>(
      () => _i1070.ConnectionsDemoDataSource(),
      registerFor: {_demo},
    );
    gh.lazySingleton<_i445.FcmMessageDataSource>(
      () => const _i937.FcmMessageDemoDataSource(),
      registerFor: {_demo},
    );
    gh.lazySingleton<_i194.NetworkInfo>(() => const _i194.NetworkInfoImpl());
    gh.lazySingleton<_i454.SupabaseClient>(
      () => supabaseModule.supabaseClient,
      registerFor: {_live},
    );
    gh.lazySingleton<_i195.LocalNotifier>(
      () => _i195.FlutterLocalNotifier(),
      registerFor: {_live},
    );
    gh.lazySingleton<_i445.FcmMessageDataSource>(
      () => const _i445.FcmMessageDataSourceImpl(),
      registerFor: {_live},
    );
    gh.lazySingleton<_i476.AuthInterceptor>(
      () => _i476.AuthInterceptor(gh<_i454.SupabaseClient>()),
      registerFor: {_live},
    );
    gh.lazySingleton<_i850.AuditRemoteDataSource>(
      () => _i850.AuditRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
      registerFor: {_live},
    );
    gh.lazySingleton<_i846.DioClient>(
      () => _i846.DioClient(gh<_i476.AuthInterceptor>()),
      registerFor: {_live},
    );
    gh.lazySingleton<_i861.FcmTokenDataSource>(
      () => _i861.FcmTokenDataSourceImpl(gh<_i454.SupabaseClient>()),
      registerFor: {_live},
    );
    gh.lazySingleton<_i69.ActionChangeSource>(
      () => _i69.RealtimeActionChangeSource(gh<_i454.SupabaseClient>()),
      registerFor: {_live},
    );
    gh.lazySingleton<_i539.AuthRemoteDataSource>(
      () => _i539.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
      registerFor: {_live},
    );
    gh.lazySingleton<_i854.ActionsRemoteDataSource>(
      () => _i854.ActionsRemoteDataSourceImpl(
        gh<_i454.SupabaseClient>(),
        gh<_i846.DioClient>(),
        gh<_i69.ActionChangeSource>(),
      ),
      registerFor: {_live},
    );
    gh.lazySingleton<_i878.ActionsRepository>(
      () => _i487.ActionsRepositoryImpl(gh<_i854.ActionsRemoteDataSource>()),
    );
    gh.lazySingleton<_i941.ConnectionsRemoteDataSource>(
      () => _i941.ConnectionsRemoteDataSourceImpl(
        gh<_i454.SupabaseClient>(),
        gh<_i846.DioClient>(),
      ),
      registerFor: {_live},
    );
    gh.lazySingleton<_i280.AuditRepository>(
      () => _i520.AuditRepositoryImpl(gh<_i850.AuditRemoteDataSource>()),
    );
    gh.lazySingleton<_i90.AuthRepository>(
      () => _i295.AuthRepositoryImpl(gh<_i539.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i56.PushRepository>(
      () => _i440.PushRepositoryImpl(
        gh<_i861.FcmTokenDataSource>(),
        gh<_i445.FcmMessageDataSource>(),
      ),
    );
    gh.lazySingleton<_i1045.ConnectionsRepository>(
      () => _i470.ConnectionsRepositoryImpl(
        gh<_i941.ConnectionsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i238.SignIn>(
      () => _i238.SignIn(gh<_i90.AuthRepository>()),
    );
    gh.lazySingleton<_i477.VerifyOtp>(
      () => _i477.VerifyOtp(gh<_i90.AuthRepository>()),
    );
    gh.lazySingleton<_i815.WatchAuthState>(
      () => _i815.WatchAuthState(gh<_i90.AuthRepository>()),
    );
    gh.lazySingleton<_i282.GetAuditEntries>(
      () => _i282.GetAuditEntries(gh<_i280.AuditRepository>()),
    );
    gh.lazySingleton<_i508.DecideAction>(
      () => _i508.DecideAction(gh<_i878.ActionsRepository>()),
    );
    gh.lazySingleton<_i357.GetActionDetail>(
      () => _i357.GetActionDetail(gh<_i878.ActionsRepository>()),
    );
    gh.lazySingleton<_i61.WatchPendingActions>(
      () => _i61.WatchPendingActions(gh<_i878.ActionsRepository>()),
    );
    gh.lazySingleton<_i1053.RegisterDevice>(
      () => _i1053.RegisterDevice(gh<_i56.PushRepository>()),
    );
    gh.lazySingleton<_i302.UnregisterDevice>(
      () => _i302.UnregisterDevice(gh<_i56.PushRepository>()),
    );
    gh.lazySingleton<_i555.NotificationService>(
      () => _i555.NotificationService(
        gh<_i56.PushRepository>(),
        gh<_i1053.RegisterDevice>(),
        gh<_i195.LocalNotifier>(),
      ),
    );
    gh.lazySingleton<_i1045.CreateAgent>(
      () => _i1045.CreateAgent(gh<_i1045.ConnectionsRepository>()),
    );
    gh.lazySingleton<_i206.ListAgents>(
      () => _i206.ListAgents(gh<_i1045.ConnectionsRepository>()),
    );
    gh.lazySingleton<_i947.SendTestAction>(
      () => _i947.SendTestAction(gh<_i1045.ConnectionsRepository>()),
    );
    gh.lazySingleton<_i1004.SignOut>(
      () => _i1004.SignOut(
        gh<_i90.AuthRepository>(),
        gh<_i302.UnregisterDevice>(),
      ),
    );
    return this;
  }
}

class _$SupabaseModule extends _i868.SupabaseModule {}
