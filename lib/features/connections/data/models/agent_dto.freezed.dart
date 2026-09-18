// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentDto {

 String get id; String get name; String get callbackUrl; String get platform; String get status; String? get secretHint; DateTime? get lastActionAt;
/// Create a copy of AgentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentDtoCopyWith<AgentDto> get copyWith => _$AgentDtoCopyWithImpl<AgentDto>(this as AgentDto, _$identity);

  /// Serializes this AgentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.callbackUrl, callbackUrl) || other.callbackUrl == callbackUrl)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.status, status) || other.status == status)&&(identical(other.secretHint, secretHint) || other.secretHint == secretHint)&&(identical(other.lastActionAt, lastActionAt) || other.lastActionAt == lastActionAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,callbackUrl,platform,status,secretHint,lastActionAt);

@override
String toString() {
  return 'AgentDto(id: $id, name: $name, callbackUrl: $callbackUrl, platform: $platform, status: $status, secretHint: $secretHint, lastActionAt: $lastActionAt)';
}


}

/// @nodoc
abstract mixin class $AgentDtoCopyWith<$Res>  {
  factory $AgentDtoCopyWith(AgentDto value, $Res Function(AgentDto) _then) = _$AgentDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String callbackUrl, String platform, String status, String? secretHint, DateTime? lastActionAt
});




}
/// @nodoc
class _$AgentDtoCopyWithImpl<$Res>
    implements $AgentDtoCopyWith<$Res> {
  _$AgentDtoCopyWithImpl(this._self, this._then);

  final AgentDto _self;
  final $Res Function(AgentDto) _then;

/// Create a copy of AgentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? callbackUrl = null,Object? platform = null,Object? status = null,Object? secretHint = freezed,Object? lastActionAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,callbackUrl: null == callbackUrl ? _self.callbackUrl : callbackUrl // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,secretHint: freezed == secretHint ? _self.secretHint : secretHint // ignore: cast_nullable_to_non_nullable
as String?,lastActionAt: freezed == lastActionAt ? _self.lastActionAt : lastActionAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentDto].
extension AgentDtoPatterns on AgentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentDto value)  $default,){
final _that = this;
switch (_that) {
case _AgentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentDto value)?  $default,){
final _that = this;
switch (_that) {
case _AgentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String callbackUrl,  String platform,  String status,  String? secretHint,  DateTime? lastActionAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentDto() when $default != null:
return $default(_that.id,_that.name,_that.callbackUrl,_that.platform,_that.status,_that.secretHint,_that.lastActionAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String callbackUrl,  String platform,  String status,  String? secretHint,  DateTime? lastActionAt)  $default,) {final _that = this;
switch (_that) {
case _AgentDto():
return $default(_that.id,_that.name,_that.callbackUrl,_that.platform,_that.status,_that.secretHint,_that.lastActionAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String callbackUrl,  String platform,  String status,  String? secretHint,  DateTime? lastActionAt)?  $default,) {final _that = this;
switch (_that) {
case _AgentDto() when $default != null:
return $default(_that.id,_that.name,_that.callbackUrl,_that.platform,_that.status,_that.secretHint,_that.lastActionAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentDto extends AgentDto {
  const _AgentDto({required this.id, required this.name, required this.callbackUrl, this.platform = 'custom', this.status = 'active', this.secretHint, this.lastActionAt}): super._();
  factory _AgentDto.fromJson(Map<String, dynamic> json) => _$AgentDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String callbackUrl;
@override@JsonKey() final  String platform;
@override@JsonKey() final  String status;
@override final  String? secretHint;
@override final  DateTime? lastActionAt;

/// Create a copy of AgentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentDtoCopyWith<_AgentDto> get copyWith => __$AgentDtoCopyWithImpl<_AgentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.callbackUrl, callbackUrl) || other.callbackUrl == callbackUrl)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.status, status) || other.status == status)&&(identical(other.secretHint, secretHint) || other.secretHint == secretHint)&&(identical(other.lastActionAt, lastActionAt) || other.lastActionAt == lastActionAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,callbackUrl,platform,status,secretHint,lastActionAt);

@override
String toString() {
  return 'AgentDto(id: $id, name: $name, callbackUrl: $callbackUrl, platform: $platform, status: $status, secretHint: $secretHint, lastActionAt: $lastActionAt)';
}


}

/// @nodoc
abstract mixin class _$AgentDtoCopyWith<$Res> implements $AgentDtoCopyWith<$Res> {
  factory _$AgentDtoCopyWith(_AgentDto value, $Res Function(_AgentDto) _then) = __$AgentDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String callbackUrl, String platform, String status, String? secretHint, DateTime? lastActionAt
});




}
/// @nodoc
class __$AgentDtoCopyWithImpl<$Res>
    implements _$AgentDtoCopyWith<$Res> {
  __$AgentDtoCopyWithImpl(this._self, this._then);

  final _AgentDto _self;
  final $Res Function(_AgentDto) _then;

/// Create a copy of AgentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? callbackUrl = null,Object? platform = null,Object? status = null,Object? secretHint = freezed,Object? lastActionAt = freezed,}) {
  return _then(_AgentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,callbackUrl: null == callbackUrl ? _self.callbackUrl : callbackUrl // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,secretHint: freezed == secretHint ? _self.secretHint : secretHint // ignore: cast_nullable_to_non_nullable
as String?,lastActionAt: freezed == lastActionAt ? _self.lastActionAt : lastActionAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AgentCredentialsDto {

 AgentDto get agent; String get inboundUrl; String get inboundSecret;
/// Create a copy of AgentCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentCredentialsDtoCopyWith<AgentCredentialsDto> get copyWith => _$AgentCredentialsDtoCopyWithImpl<AgentCredentialsDto>(this as AgentCredentialsDto, _$identity);

  /// Serializes this AgentCredentialsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentCredentialsDto&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.inboundUrl, inboundUrl) || other.inboundUrl == inboundUrl)&&(identical(other.inboundSecret, inboundSecret) || other.inboundSecret == inboundSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agent,inboundUrl,inboundSecret);

@override
String toString() {
  return 'AgentCredentialsDto(agent: $agent, inboundUrl: $inboundUrl, inboundSecret: $inboundSecret)';
}


}

/// @nodoc
abstract mixin class $AgentCredentialsDtoCopyWith<$Res>  {
  factory $AgentCredentialsDtoCopyWith(AgentCredentialsDto value, $Res Function(AgentCredentialsDto) _then) = _$AgentCredentialsDtoCopyWithImpl;
@useResult
$Res call({
 AgentDto agent, String inboundUrl, String inboundSecret
});


$AgentDtoCopyWith<$Res> get agent;

}
/// @nodoc
class _$AgentCredentialsDtoCopyWithImpl<$Res>
    implements $AgentCredentialsDtoCopyWith<$Res> {
  _$AgentCredentialsDtoCopyWithImpl(this._self, this._then);

  final AgentCredentialsDto _self;
  final $Res Function(AgentCredentialsDto) _then;

/// Create a copy of AgentCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agent = null,Object? inboundUrl = null,Object? inboundSecret = null,}) {
  return _then(_self.copyWith(
agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as AgentDto,inboundUrl: null == inboundUrl ? _self.inboundUrl : inboundUrl // ignore: cast_nullable_to_non_nullable
as String,inboundSecret: null == inboundSecret ? _self.inboundSecret : inboundSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AgentCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentDtoCopyWith<$Res> get agent {
  
  return $AgentDtoCopyWith<$Res>(_self.agent, (value) {
    return _then(_self.copyWith(agent: value));
  });
}
}


/// Adds pattern-matching-related methods to [AgentCredentialsDto].
extension AgentCredentialsDtoPatterns on AgentCredentialsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentCredentialsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentCredentialsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentCredentialsDto value)  $default,){
final _that = this;
switch (_that) {
case _AgentCredentialsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentCredentialsDto value)?  $default,){
final _that = this;
switch (_that) {
case _AgentCredentialsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AgentDto agent,  String inboundUrl,  String inboundSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentCredentialsDto() when $default != null:
return $default(_that.agent,_that.inboundUrl,_that.inboundSecret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AgentDto agent,  String inboundUrl,  String inboundSecret)  $default,) {final _that = this;
switch (_that) {
case _AgentCredentialsDto():
return $default(_that.agent,_that.inboundUrl,_that.inboundSecret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AgentDto agent,  String inboundUrl,  String inboundSecret)?  $default,) {final _that = this;
switch (_that) {
case _AgentCredentialsDto() when $default != null:
return $default(_that.agent,_that.inboundUrl,_that.inboundSecret);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentCredentialsDto extends AgentCredentialsDto {
  const _AgentCredentialsDto({required this.agent, required this.inboundUrl, required this.inboundSecret}): super._();
  factory _AgentCredentialsDto.fromJson(Map<String, dynamic> json) => _$AgentCredentialsDtoFromJson(json);

@override final  AgentDto agent;
@override final  String inboundUrl;
@override final  String inboundSecret;

/// Create a copy of AgentCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentCredentialsDtoCopyWith<_AgentCredentialsDto> get copyWith => __$AgentCredentialsDtoCopyWithImpl<_AgentCredentialsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentCredentialsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentCredentialsDto&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.inboundUrl, inboundUrl) || other.inboundUrl == inboundUrl)&&(identical(other.inboundSecret, inboundSecret) || other.inboundSecret == inboundSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agent,inboundUrl,inboundSecret);

@override
String toString() {
  return 'AgentCredentialsDto(agent: $agent, inboundUrl: $inboundUrl, inboundSecret: $inboundSecret)';
}


}

/// @nodoc
abstract mixin class _$AgentCredentialsDtoCopyWith<$Res> implements $AgentCredentialsDtoCopyWith<$Res> {
  factory _$AgentCredentialsDtoCopyWith(_AgentCredentialsDto value, $Res Function(_AgentCredentialsDto) _then) = __$AgentCredentialsDtoCopyWithImpl;
@override @useResult
$Res call({
 AgentDto agent, String inboundUrl, String inboundSecret
});


@override $AgentDtoCopyWith<$Res> get agent;

}
/// @nodoc
class __$AgentCredentialsDtoCopyWithImpl<$Res>
    implements _$AgentCredentialsDtoCopyWith<$Res> {
  __$AgentCredentialsDtoCopyWithImpl(this._self, this._then);

  final _AgentCredentialsDto _self;
  final $Res Function(_AgentCredentialsDto) _then;

/// Create a copy of AgentCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agent = null,Object? inboundUrl = null,Object? inboundSecret = null,}) {
  return _then(_AgentCredentialsDto(
agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as AgentDto,inboundUrl: null == inboundUrl ? _self.inboundUrl : inboundUrl // ignore: cast_nullable_to_non_nullable
as String,inboundSecret: null == inboundSecret ? _self.inboundSecret : inboundSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AgentCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentDtoCopyWith<$Res> get agent {
  
  return $AgentDtoCopyWith<$Res>(_self.agent, (value) {
    return _then(_self.copyWith(agent: value));
  });
}
}

// dart format on
