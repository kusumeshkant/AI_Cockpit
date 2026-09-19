// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_trigger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgentTrigger {

 String get agentId; String get triggerUrl; String get secretHint; bool get enabled; int get minIntervalSecs; DateTime? get lastRunAt;
/// Create a copy of AgentTrigger
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentTriggerCopyWith<AgentTrigger> get copyWith => _$AgentTriggerCopyWithImpl<AgentTrigger>(this as AgentTrigger, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentTrigger&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.triggerUrl, triggerUrl) || other.triggerUrl == triggerUrl)&&(identical(other.secretHint, secretHint) || other.secretHint == secretHint)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.minIntervalSecs, minIntervalSecs) || other.minIntervalSecs == minIntervalSecs)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt));
}


@override
int get hashCode => Object.hash(runtimeType,agentId,triggerUrl,secretHint,enabled,minIntervalSecs,lastRunAt);

@override
String toString() {
  return 'AgentTrigger(agentId: $agentId, triggerUrl: $triggerUrl, secretHint: $secretHint, enabled: $enabled, minIntervalSecs: $minIntervalSecs, lastRunAt: $lastRunAt)';
}


}

/// @nodoc
abstract mixin class $AgentTriggerCopyWith<$Res>  {
  factory $AgentTriggerCopyWith(AgentTrigger value, $Res Function(AgentTrigger) _then) = _$AgentTriggerCopyWithImpl;
@useResult
$Res call({
 String agentId, String triggerUrl, String secretHint, bool enabled, int minIntervalSecs, DateTime? lastRunAt
});




}
/// @nodoc
class _$AgentTriggerCopyWithImpl<$Res>
    implements $AgentTriggerCopyWith<$Res> {
  _$AgentTriggerCopyWithImpl(this._self, this._then);

  final AgentTrigger _self;
  final $Res Function(AgentTrigger) _then;

/// Create a copy of AgentTrigger
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agentId = null,Object? triggerUrl = null,Object? secretHint = null,Object? enabled = null,Object? minIntervalSecs = null,Object? lastRunAt = freezed,}) {
  return _then(_self.copyWith(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,triggerUrl: null == triggerUrl ? _self.triggerUrl : triggerUrl // ignore: cast_nullable_to_non_nullable
as String,secretHint: null == secretHint ? _self.secretHint : secretHint // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,minIntervalSecs: null == minIntervalSecs ? _self.minIntervalSecs : minIntervalSecs // ignore: cast_nullable_to_non_nullable
as int,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentTrigger].
extension AgentTriggerPatterns on AgentTrigger {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentTrigger value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentTrigger() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentTrigger value)  $default,){
final _that = this;
switch (_that) {
case _AgentTrigger():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentTrigger value)?  $default,){
final _that = this;
switch (_that) {
case _AgentTrigger() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agentId,  String triggerUrl,  String secretHint,  bool enabled,  int minIntervalSecs,  DateTime? lastRunAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentTrigger() when $default != null:
return $default(_that.agentId,_that.triggerUrl,_that.secretHint,_that.enabled,_that.minIntervalSecs,_that.lastRunAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agentId,  String triggerUrl,  String secretHint,  bool enabled,  int minIntervalSecs,  DateTime? lastRunAt)  $default,) {final _that = this;
switch (_that) {
case _AgentTrigger():
return $default(_that.agentId,_that.triggerUrl,_that.secretHint,_that.enabled,_that.minIntervalSecs,_that.lastRunAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agentId,  String triggerUrl,  String secretHint,  bool enabled,  int minIntervalSecs,  DateTime? lastRunAt)?  $default,) {final _that = this;
switch (_that) {
case _AgentTrigger() when $default != null:
return $default(_that.agentId,_that.triggerUrl,_that.secretHint,_that.enabled,_that.minIntervalSecs,_that.lastRunAt);case _:
  return null;

}
}

}

/// @nodoc


class _AgentTrigger implements AgentTrigger {
  const _AgentTrigger({required this.agentId, required this.triggerUrl, required this.secretHint, required this.enabled, required this.minIntervalSecs, this.lastRunAt});
  

@override final  String agentId;
@override final  String triggerUrl;
@override final  String secretHint;
@override final  bool enabled;
@override final  int minIntervalSecs;
@override final  DateTime? lastRunAt;

/// Create a copy of AgentTrigger
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentTriggerCopyWith<_AgentTrigger> get copyWith => __$AgentTriggerCopyWithImpl<_AgentTrigger>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentTrigger&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.triggerUrl, triggerUrl) || other.triggerUrl == triggerUrl)&&(identical(other.secretHint, secretHint) || other.secretHint == secretHint)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.minIntervalSecs, minIntervalSecs) || other.minIntervalSecs == minIntervalSecs)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt));
}


@override
int get hashCode => Object.hash(runtimeType,agentId,triggerUrl,secretHint,enabled,minIntervalSecs,lastRunAt);

@override
String toString() {
  return 'AgentTrigger(agentId: $agentId, triggerUrl: $triggerUrl, secretHint: $secretHint, enabled: $enabled, minIntervalSecs: $minIntervalSecs, lastRunAt: $lastRunAt)';
}


}

/// @nodoc
abstract mixin class _$AgentTriggerCopyWith<$Res> implements $AgentTriggerCopyWith<$Res> {
  factory _$AgentTriggerCopyWith(_AgentTrigger value, $Res Function(_AgentTrigger) _then) = __$AgentTriggerCopyWithImpl;
@override @useResult
$Res call({
 String agentId, String triggerUrl, String secretHint, bool enabled, int minIntervalSecs, DateTime? lastRunAt
});




}
/// @nodoc
class __$AgentTriggerCopyWithImpl<$Res>
    implements _$AgentTriggerCopyWith<$Res> {
  __$AgentTriggerCopyWithImpl(this._self, this._then);

  final _AgentTrigger _self;
  final $Res Function(_AgentTrigger) _then;

/// Create a copy of AgentTrigger
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agentId = null,Object? triggerUrl = null,Object? secretHint = null,Object? enabled = null,Object? minIntervalSecs = null,Object? lastRunAt = freezed,}) {
  return _then(_AgentTrigger(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,triggerUrl: null == triggerUrl ? _self.triggerUrl : triggerUrl // ignore: cast_nullable_to_non_nullable
as String,secretHint: null == secretHint ? _self.secretHint : secretHint // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,minIntervalSecs: null == minIntervalSecs ? _self.minIntervalSecs : minIntervalSecs // ignore: cast_nullable_to_non_nullable
as int,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$TriggerRun {

 String get runId; bool get delivered; String get detail;
/// Create a copy of TriggerRun
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerRunCopyWith<TriggerRun> get copyWith => _$TriggerRunCopyWithImpl<TriggerRun>(this as TriggerRun, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerRun&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.delivered, delivered) || other.delivered == delivered)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,runId,delivered,detail);

@override
String toString() {
  return 'TriggerRun(runId: $runId, delivered: $delivered, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $TriggerRunCopyWith<$Res>  {
  factory $TriggerRunCopyWith(TriggerRun value, $Res Function(TriggerRun) _then) = _$TriggerRunCopyWithImpl;
@useResult
$Res call({
 String runId, bool delivered, String detail
});




}
/// @nodoc
class _$TriggerRunCopyWithImpl<$Res>
    implements $TriggerRunCopyWith<$Res> {
  _$TriggerRunCopyWithImpl(this._self, this._then);

  final TriggerRun _self;
  final $Res Function(TriggerRun) _then;

/// Create a copy of TriggerRun
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? delivered = null,Object? detail = null,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,delivered: null == delivered ? _self.delivered : delivered // ignore: cast_nullable_to_non_nullable
as bool,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerRun].
extension TriggerRunPatterns on TriggerRun {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerRun value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerRun() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerRun value)  $default,){
final _that = this;
switch (_that) {
case _TriggerRun():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerRun value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerRun() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  bool delivered,  String detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerRun() when $default != null:
return $default(_that.runId,_that.delivered,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  bool delivered,  String detail)  $default,) {final _that = this;
switch (_that) {
case _TriggerRun():
return $default(_that.runId,_that.delivered,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  bool delivered,  String detail)?  $default,) {final _that = this;
switch (_that) {
case _TriggerRun() when $default != null:
return $default(_that.runId,_that.delivered,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _TriggerRun implements TriggerRun {
  const _TriggerRun({required this.runId, required this.delivered, required this.detail});
  

@override final  String runId;
@override final  bool delivered;
@override final  String detail;

/// Create a copy of TriggerRun
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerRunCopyWith<_TriggerRun> get copyWith => __$TriggerRunCopyWithImpl<_TriggerRun>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerRun&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.delivered, delivered) || other.delivered == delivered)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,runId,delivered,detail);

@override
String toString() {
  return 'TriggerRun(runId: $runId, delivered: $delivered, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$TriggerRunCopyWith<$Res> implements $TriggerRunCopyWith<$Res> {
  factory _$TriggerRunCopyWith(_TriggerRun value, $Res Function(_TriggerRun) _then) = __$TriggerRunCopyWithImpl;
@override @useResult
$Res call({
 String runId, bool delivered, String detail
});




}
/// @nodoc
class __$TriggerRunCopyWithImpl<$Res>
    implements _$TriggerRunCopyWith<$Res> {
  __$TriggerRunCopyWithImpl(this._self, this._then);

  final _TriggerRun _self;
  final $Res Function(_TriggerRun) _then;

/// Create a copy of TriggerRun
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? delivered = null,Object? detail = null,}) {
  return _then(_TriggerRun(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,delivered: null == delivered ? _self.delivered : delivered // ignore: cast_nullable_to_non_nullable
as bool,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TriggerCredentials {

 AgentTrigger get trigger; String get secret;
/// Create a copy of TriggerCredentials
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerCredentialsCopyWith<TriggerCredentials> get copyWith => _$TriggerCredentialsCopyWithImpl<TriggerCredentials>(this as TriggerCredentials, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerCredentials&&(identical(other.trigger, trigger) || other.trigger == trigger)&&(identical(other.secret, secret) || other.secret == secret));
}


@override
int get hashCode => Object.hash(runtimeType,trigger,secret);

@override
String toString() {
  return 'TriggerCredentials(trigger: $trigger, secret: $secret)';
}


}

/// @nodoc
abstract mixin class $TriggerCredentialsCopyWith<$Res>  {
  factory $TriggerCredentialsCopyWith(TriggerCredentials value, $Res Function(TriggerCredentials) _then) = _$TriggerCredentialsCopyWithImpl;
@useResult
$Res call({
 AgentTrigger trigger, String secret
});


$AgentTriggerCopyWith<$Res> get trigger;

}
/// @nodoc
class _$TriggerCredentialsCopyWithImpl<$Res>
    implements $TriggerCredentialsCopyWith<$Res> {
  _$TriggerCredentialsCopyWithImpl(this._self, this._then);

  final TriggerCredentials _self;
  final $Res Function(TriggerCredentials) _then;

/// Create a copy of TriggerCredentials
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trigger = null,Object? secret = null,}) {
  return _then(_self.copyWith(
trigger: null == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as AgentTrigger,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of TriggerCredentials
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentTriggerCopyWith<$Res> get trigger {
  
  return $AgentTriggerCopyWith<$Res>(_self.trigger, (value) {
    return _then(_self.copyWith(trigger: value));
  });
}
}


/// Adds pattern-matching-related methods to [TriggerCredentials].
extension TriggerCredentialsPatterns on TriggerCredentials {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerCredentials value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerCredentials() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerCredentials value)  $default,){
final _that = this;
switch (_that) {
case _TriggerCredentials():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerCredentials value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerCredentials() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AgentTrigger trigger,  String secret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerCredentials() when $default != null:
return $default(_that.trigger,_that.secret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AgentTrigger trigger,  String secret)  $default,) {final _that = this;
switch (_that) {
case _TriggerCredentials():
return $default(_that.trigger,_that.secret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AgentTrigger trigger,  String secret)?  $default,) {final _that = this;
switch (_that) {
case _TriggerCredentials() when $default != null:
return $default(_that.trigger,_that.secret);case _:
  return null;

}
}

}

/// @nodoc


class _TriggerCredentials implements TriggerCredentials {
  const _TriggerCredentials({required this.trigger, required this.secret});
  

@override final  AgentTrigger trigger;
@override final  String secret;

/// Create a copy of TriggerCredentials
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerCredentialsCopyWith<_TriggerCredentials> get copyWith => __$TriggerCredentialsCopyWithImpl<_TriggerCredentials>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerCredentials&&(identical(other.trigger, trigger) || other.trigger == trigger)&&(identical(other.secret, secret) || other.secret == secret));
}


@override
int get hashCode => Object.hash(runtimeType,trigger,secret);

@override
String toString() {
  return 'TriggerCredentials(trigger: $trigger, secret: $secret)';
}


}

/// @nodoc
abstract mixin class _$TriggerCredentialsCopyWith<$Res> implements $TriggerCredentialsCopyWith<$Res> {
  factory _$TriggerCredentialsCopyWith(_TriggerCredentials value, $Res Function(_TriggerCredentials) _then) = __$TriggerCredentialsCopyWithImpl;
@override @useResult
$Res call({
 AgentTrigger trigger, String secret
});


@override $AgentTriggerCopyWith<$Res> get trigger;

}
/// @nodoc
class __$TriggerCredentialsCopyWithImpl<$Res>
    implements _$TriggerCredentialsCopyWith<$Res> {
  __$TriggerCredentialsCopyWithImpl(this._self, this._then);

  final _TriggerCredentials _self;
  final $Res Function(_TriggerCredentials) _then;

/// Create a copy of TriggerCredentials
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trigger = null,Object? secret = null,}) {
  return _then(_TriggerCredentials(
trigger: null == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as AgentTrigger,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of TriggerCredentials
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentTriggerCopyWith<$Res> get trigger {
  
  return $AgentTriggerCopyWith<$Res>(_self.trigger, (value) {
    return _then(_self.copyWith(trigger: value));
  });
}
}

// dart format on
