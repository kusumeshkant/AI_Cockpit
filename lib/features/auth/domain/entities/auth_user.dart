// Feature: auth · Layer: domain
// The signed-in user as seen by the domain. Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// Subscription plan of the user's workspace.
enum WorkspacePlan {
  /// $29/mo — one approver.
  solo,

  /// $59/mo — small team.
  pro,

  /// $99+/mo — resell to clients.
  consultant,
}

/// The authenticated Cockpit user.
@freezed
abstract class AuthUser with _$AuthUser {
  /// Creates an [AuthUser].
  const factory AuthUser({
    required String id,
    required String email,
    String? displayName,
    String? workspaceId,
    @Default(WorkspacePlan.solo) WorkspacePlan plan,
  }) = _AuthUser;
}
