// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_setting_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeatureSettingDto {

 String get key; bool get enabled; String? get minAppVersion;
/// Create a copy of FeatureSettingDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureSettingDtoCopyWith<FeatureSettingDto> get copyWith => _$FeatureSettingDtoCopyWithImpl<FeatureSettingDto>(this as FeatureSettingDto, _$identity);

  /// Serializes this FeatureSettingDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureSettingDto&&(identical(other.key, key) || other.key == key)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,enabled,minAppVersion);

@override
String toString() {
  return 'FeatureSettingDto(key: $key, enabled: $enabled, minAppVersion: $minAppVersion)';
}


}

/// @nodoc
abstract mixin class $FeatureSettingDtoCopyWith<$Res>  {
  factory $FeatureSettingDtoCopyWith(FeatureSettingDto value, $Res Function(FeatureSettingDto) _then) = _$FeatureSettingDtoCopyWithImpl;
@useResult
$Res call({
 String key, bool enabled, String? minAppVersion
});




}
/// @nodoc
class _$FeatureSettingDtoCopyWithImpl<$Res>
    implements $FeatureSettingDtoCopyWith<$Res> {
  _$FeatureSettingDtoCopyWithImpl(this._self, this._then);

  final FeatureSettingDto _self;
  final $Res Function(FeatureSettingDto) _then;

/// Create a copy of FeatureSettingDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? enabled = null,Object? minAppVersion = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,minAppVersion: freezed == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureSettingDto].
extension FeatureSettingDtoPatterns on FeatureSettingDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureSettingDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureSettingDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureSettingDto value)  $default,){
final _that = this;
switch (_that) {
case _FeatureSettingDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureSettingDto value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureSettingDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  bool enabled,  String? minAppVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureSettingDto() when $default != null:
return $default(_that.key,_that.enabled,_that.minAppVersion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  bool enabled,  String? minAppVersion)  $default,) {final _that = this;
switch (_that) {
case _FeatureSettingDto():
return $default(_that.key,_that.enabled,_that.minAppVersion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  bool enabled,  String? minAppVersion)?  $default,) {final _that = this;
switch (_that) {
case _FeatureSettingDto() when $default != null:
return $default(_that.key,_that.enabled,_that.minAppVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureSettingDto extends FeatureSettingDto {
  const _FeatureSettingDto({required this.key, this.enabled = false, this.minAppVersion}): super._();
  factory _FeatureSettingDto.fromJson(Map<String, dynamic> json) => _$FeatureSettingDtoFromJson(json);

@override final  String key;
@override@JsonKey() final  bool enabled;
@override final  String? minAppVersion;

/// Create a copy of FeatureSettingDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureSettingDtoCopyWith<_FeatureSettingDto> get copyWith => __$FeatureSettingDtoCopyWithImpl<_FeatureSettingDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureSettingDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureSettingDto&&(identical(other.key, key) || other.key == key)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,enabled,minAppVersion);

@override
String toString() {
  return 'FeatureSettingDto(key: $key, enabled: $enabled, minAppVersion: $minAppVersion)';
}


}

/// @nodoc
abstract mixin class _$FeatureSettingDtoCopyWith<$Res> implements $FeatureSettingDtoCopyWith<$Res> {
  factory _$FeatureSettingDtoCopyWith(_FeatureSettingDto value, $Res Function(_FeatureSettingDto) _then) = __$FeatureSettingDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, bool enabled, String? minAppVersion
});




}
/// @nodoc
class __$FeatureSettingDtoCopyWithImpl<$Res>
    implements _$FeatureSettingDtoCopyWith<$Res> {
  __$FeatureSettingDtoCopyWithImpl(this._self, this._then);

  final _FeatureSettingDto _self;
  final $Res Function(_FeatureSettingDto) _then;

/// Create a copy of FeatureSettingDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? enabled = null,Object? minAppVersion = freezed,}) {
  return _then(_FeatureSettingDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,minAppVersion: freezed == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
