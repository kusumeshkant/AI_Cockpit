// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeatureSetting {

 String get key; bool get enabled;/// Lowest app version (`x.y.z`) allowed to show the feature; `null` = any.
 String? get minAppVersion;
/// Create a copy of FeatureSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureSettingCopyWith<FeatureSetting> get copyWith => _$FeatureSettingCopyWithImpl<FeatureSetting>(this as FeatureSetting, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureSetting&&(identical(other.key, key) || other.key == key)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion));
}


@override
int get hashCode => Object.hash(runtimeType,key,enabled,minAppVersion);

@override
String toString() {
  return 'FeatureSetting(key: $key, enabled: $enabled, minAppVersion: $minAppVersion)';
}


}

/// @nodoc
abstract mixin class $FeatureSettingCopyWith<$Res>  {
  factory $FeatureSettingCopyWith(FeatureSetting value, $Res Function(FeatureSetting) _then) = _$FeatureSettingCopyWithImpl;
@useResult
$Res call({
 String key, bool enabled, String? minAppVersion
});




}
/// @nodoc
class _$FeatureSettingCopyWithImpl<$Res>
    implements $FeatureSettingCopyWith<$Res> {
  _$FeatureSettingCopyWithImpl(this._self, this._then);

  final FeatureSetting _self;
  final $Res Function(FeatureSetting) _then;

/// Create a copy of FeatureSetting
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


/// Adds pattern-matching-related methods to [FeatureSetting].
extension FeatureSettingPatterns on FeatureSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureSetting value)  $default,){
final _that = this;
switch (_that) {
case _FeatureSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureSetting value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureSetting() when $default != null:
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
case _FeatureSetting() when $default != null:
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
case _FeatureSetting():
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
case _FeatureSetting() when $default != null:
return $default(_that.key,_that.enabled,_that.minAppVersion);case _:
  return null;

}
}

}

/// @nodoc


class _FeatureSetting extends FeatureSetting {
  const _FeatureSetting({required this.key, required this.enabled, this.minAppVersion}): super._();
  

@override final  String key;
@override final  bool enabled;
/// Lowest app version (`x.y.z`) allowed to show the feature; `null` = any.
@override final  String? minAppVersion;

/// Create a copy of FeatureSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureSettingCopyWith<_FeatureSetting> get copyWith => __$FeatureSettingCopyWithImpl<_FeatureSetting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureSetting&&(identical(other.key, key) || other.key == key)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion));
}


@override
int get hashCode => Object.hash(runtimeType,key,enabled,minAppVersion);

@override
String toString() {
  return 'FeatureSetting(key: $key, enabled: $enabled, minAppVersion: $minAppVersion)';
}


}

/// @nodoc
abstract mixin class _$FeatureSettingCopyWith<$Res> implements $FeatureSettingCopyWith<$Res> {
  factory _$FeatureSettingCopyWith(_FeatureSetting value, $Res Function(_FeatureSetting) _then) = __$FeatureSettingCopyWithImpl;
@override @useResult
$Res call({
 String key, bool enabled, String? minAppVersion
});




}
/// @nodoc
class __$FeatureSettingCopyWithImpl<$Res>
    implements _$FeatureSettingCopyWith<$Res> {
  __$FeatureSettingCopyWithImpl(this._self, this._then);

  final _FeatureSetting _self;
  final $Res Function(_FeatureSetting) _then;

/// Create a copy of FeatureSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? enabled = null,Object? minAppVersion = freezed,}) {
  return _then(_FeatureSetting(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,minAppVersion: freezed == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
