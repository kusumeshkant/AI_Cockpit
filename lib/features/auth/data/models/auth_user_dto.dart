// Feature: auth · Layer: data
// Wire model for the signed-in user; maps to the AuthUser entity.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/features/auth/domain/entities/auth_user.dart';

part 'auth_user_dto.freezed.dart';
part 'auth_user_dto.g.dart';

/// JSON representation of `app_user` joined with its workspace plan.
@freezed
abstract class AuthUserDto with _$AuthUserDto {
  /// Creates a DTO.
  const factory AuthUserDto({
    required String id,
    required String email,
    String? displayName,
    String? workspaceId,
    @Default('solo') String plan,
  }) = _AuthUserDto;

  const AuthUserDto._();

  /// Parses JSON.
  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(json);

  /// Maps to the domain entity.
  AuthUser toEntity() => AuthUser(
        id: id,
        email: email,
        displayName: displayName,
        workspaceId: workspaceId,
        plan: WorkspacePlan.values.firstWhere(
          (p) => p.name == plan,
          orElse: () => WorkspacePlan.solo,
        ),
      );
}
