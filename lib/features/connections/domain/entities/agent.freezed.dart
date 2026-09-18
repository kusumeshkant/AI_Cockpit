// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Agent {

 String get id; String get name; String get callbackUrl; AgentPlatform get platform; AgentStatus get status; String? get secretHint; DateTime? get lastActionAt;
/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentCopyWith<Agent> get copyWith => _$AgentCopyWithImpl<Agent>(this as Agent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Agent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.callbackUrl, callbackUrl) || other.callbackUrl == callbackUrl)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.status, status) || other.status == status)&&(identical(other.secretHint, secretHint) || other.secretHint == secretHint)&&(identical(other.lastActionAt, lastActionAt) || other.lastActionAt == lastActionAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,callbackUrl,platform,status,secretHint,lastActionAt);

@override
String toString() {
  return 'Agent(id: $id, name: $name, callbackUrl: $callbackUrl, platform: $platform, status: $status, secretHint: $secretHint, lastActionAt: $lastActionAt)';
}


}

/// @nodoc
abstract mixin class $AgentCopyWith<$Res>  {
  factory $AgentCopyWith(Agent value, $Res Function(Agent) _then) = _$AgentCopyWithImpl;
@useResult
$Res call({
 String id, String name, String callbackUrl, AgentPlatform platform, AgentStatus status, String? secretHint, DateTime? lastActionAt
});




}
/// @nodoc
class _$AgentCopyWithImpl<$Res>
    implements $AgentCopyWith<$Res> {
  _$AgentCopyWithImpl(this._self, this._then);

  final Agent _self;
  final $Res Function(Agent) _then;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? callbackUrl = null,Object? platform = null,Object? status = null,Object? secretHint = freezed,Object? lastActionAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,callbackUrl: null == callbackUrl ? _self.callbackUrl : callbackUrl // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as AgentPlatform,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AgentStatus,secretHint: freezed == secretHint ? _self.secretHint : secretHint // ignore: cast_nullable_to_non_nullable
as String?,lastActionAt: freezed == lastActionAt ? _self.lastActionAt : lastActionAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Agent].
extension AgentPatterns on Agent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Agent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Agent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Agent value)  $default,){
final _that = this;
switch (_that) {
case _Agent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Agent value)?  $default,){
final _that = this;
switch (_that) {
case _Agent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String callbackUrl,  AgentPlatform platform,  AgentStatus status,  String? secretHint,  DateTime? lastActionAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Agent() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String callbackUrl,  AgentPlatform platform,  AgentStatus status,  String? secretHint,  DateTime? lastActionAt)  $default,) {final _that = this;
switch (_that) {
case _Agent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String callbackUrl,  AgentPlatform platform,  AgentStatus status,  String? secretHint,  DateTime? lastActionAt)?  $default,) {final _that = this;
switch (_that) {
case _Agent() when $default != null:
return $default(_that.id,_that.name,_that.callbackUrl,_that.platform,_that.status,_that.secretHint,_that.lastActionAt);case _:
  return null;

}
}

}

/// @nodoc


class _Agent implements Agent {
  const _Agent({required this.id, required this.name, required this.callbackUrl, this.platform = AgentPlatform.custom, this.status = AgentStatus.active, this.secretHint, this.lastActionAt});
  

@override final  String id;
@override final  String name;
@override final  String callbackUrl;
@override@JsonKey() final  AgentPlatform platform;
@override@JsonKey() final  AgentStatus status;
@override final  String? secretHint;
@override final  DateTime? lastActionAt;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentCopyWith<_Agent> get copyWith => __$AgentCopyWithImpl<_Agent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Agent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.callbackUrl, callbackUrl) || other.callbackUrl == callbackUrl)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.status, status) || other.status == status)&&(identical(other.secretHint, secretHint) || other.secretHint == secretHint)&&(identical(other.lastActionAt, lastActionAt) || other.lastActionAt == lastActionAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,callbackUrl,platform,status,secretHint,lastActionAt);

@override
String toString() {
  return 'Agent(id: $id, name: $name, callbackUrl: $callbackUrl, platform: $platform, status: $status, secretHint: $secretHint, lastActionAt: $lastActionAt)';
}


}

/// @nodoc
abstract mixin class _$AgentCopyWith<$Res> implements $AgentCopyWith<$Res> {
  factory _$AgentCopyWith(_Agent value, $Res Function(_Agent) _then) = __$AgentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String callbackUrl, AgentPlatform platform, AgentStatus status, String? secretHint, DateTime? lastActionAt
});




}
/// @nodoc
class __$AgentCopyWithImpl<$Res>
    implements _$AgentCopyWith<$Res> {
  __$AgentCopyWithImpl(this._self, this._then);

  final _Agent _self;
  final $Res Function(_Agent) _then;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? callbackUrl = null,Object? platform = null,Object? status = null,Object? secretHint = freezed,Object? lastActionAt = freezed,}) {
  return _then(_Agent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,callbackUrl: null == callbackUrl ? _self.callbackUrl : callbackUrl // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as AgentPlatform,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AgentStatus,secretHint: freezed == secretHint ? _self.secretHint : secretHint // ignore: cast_nullable_to_non_nullable
as String?,lastActionAt: freezed == lastActionAt ? _self.lastActionAt : lastActionAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$AgentCredentials {

 Agent get agent; String get inboundUrl; String get inboundSecret;
/// Create a copy of AgentCredentials
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentCredentialsCopyWith<AgentCredentials> get copyWith => _$AgentCredentialsCopyWithImpl<AgentCredentials>(this as AgentCredentials, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentCredentials&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.inboundUrl, inboundUrl) || other.inboundUrl == inboundUrl)&&(identical(other.inboundSecret, inboundSecret) || other.inboundSecret == inboundSecret));
}


@override
int get hashCode => Object.hash(runtimeType,agent,inboundUrl,inboundSecret);

@override
String toString() {
  return 'AgentCredentials(agent: $agent, inboundUrl: $inboundUrl, inboundSecret: $inboundSecret)';
}


}

/// @nodoc
abstract mixin class $AgentCredentialsCopyWith<$Res>  {
  factory $AgentCredentialsCopyWith(AgentCredentials value, $Res Function(AgentCredentials) _then) = _$AgentCredentialsCopyWithImpl;
@useResult
$Res call({
 Agent agent, String inboundUrl, String inboundSecret
});


$AgentCopyWith<$Res> get agent;

}
/// @nodoc
class _$AgentCredentialsCopyWithImpl<$Res>
    implements $AgentCredentialsCopyWith<$Res> {
  _$AgentCredentialsCopyWithImpl(this._self, this._then);

  final AgentCredentials _self;
  final $Res Function(AgentCredentials) _then;

/// Create a copy of AgentCredentials
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agent = null,Object? inboundUrl = null,Object? inboundSecret = null,}) {
  return _then(_self.copyWith(
agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as Agent,inboundUrl: null == inboundUrl ? _self.inboundUrl : inboundUrl // ignore: cast_nullable_to_non_nullable
as String,inboundSecret: null == inboundSecret ? _self.inboundSecret : inboundSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AgentCredentials
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentCopyWith<$Res> get agent {
  
  return $AgentCopyWith<$Res>(_self.agent, (value) {
    return _then(_self.copyWith(agent: value));
  });
}
}


/// Adds pattern-matching-related methods to [AgentCredentials].
extension AgentCredentialsPatterns on AgentCredentials {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentCredentials value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentCredentials() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentCredentials value)  $default,){
final _that = this;
switch (_that) {
case _AgentCredentials():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentCredentials value)?  $default,){
final _that = this;
switch (_that) {
case _AgentCredentials() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Agent agent,  String inboundUrl,  String inboundSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentCredentials() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Agent agent,  String inboundUrl,  String inboundSecret)  $default,) {final _that = this;
switch (_that) {
case _AgentCredentials():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Agent agent,  String inboundUrl,  String inboundSecret)?  $default,) {final _that = this;
switch (_that) {
case _AgentCredentials() when $default != null:
return $default(_that.agent,_that.inboundUrl,_that.inboundSecret);case _:
  return null;

}
}

}

/// @nodoc


class _AgentCredentials implements AgentCredentials {
  const _AgentCredentials({required this.agent, required this.inboundUrl, required this.inboundSecret});
  

@override final  Agent agent;
@override final  String inboundUrl;
@override final  String inboundSecret;

/// Create a copy of AgentCredentials
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentCredentialsCopyWith<_AgentCredentials> get copyWith => __$AgentCredentialsCopyWithImpl<_AgentCredentials>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentCredentials&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.inboundUrl, inboundUrl) || other.inboundUrl == inboundUrl)&&(identical(other.inboundSecret, inboundSecret) || other.inboundSecret == inboundSecret));
}


@override
int get hashCode => Object.hash(runtimeType,agent,inboundUrl,inboundSecret);

@override
String toString() {
  return 'AgentCredentials(agent: $agent, inboundUrl: $inboundUrl, inboundSecret: $inboundSecret)';
}


}

/// @nodoc
abstract mixin class _$AgentCredentialsCopyWith<$Res> implements $AgentCredentialsCopyWith<$Res> {
  factory _$AgentCredentialsCopyWith(_AgentCredentials value, $Res Function(_AgentCredentials) _then) = __$AgentCredentialsCopyWithImpl;
@override @useResult
$Res call({
 Agent agent, String inboundUrl, String inboundSecret
});


@override $AgentCopyWith<$Res> get agent;

}
/// @nodoc
class __$AgentCredentialsCopyWithImpl<$Res>
    implements _$AgentCredentialsCopyWith<$Res> {
  __$AgentCredentialsCopyWithImpl(this._self, this._then);

  final _AgentCredentials _self;
  final $Res Function(_AgentCredentials) _then;

/// Create a copy of AgentCredentials
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agent = null,Object? inboundUrl = null,Object? inboundSecret = null,}) {
  return _then(_AgentCredentials(
agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as Agent,inboundUrl: null == inboundUrl ? _self.inboundUrl : inboundUrl // ignore: cast_nullable_to_non_nullable
as String,inboundSecret: null == inboundSecret ? _self.inboundSecret : inboundSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AgentCredentials
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentCopyWith<$Res> get agent {
  
  return $AgentCopyWith<$Res>(_self.agent, (value) {
    return _then(_self.copyWith(agent: value));
  });
}
}

// dart format on
