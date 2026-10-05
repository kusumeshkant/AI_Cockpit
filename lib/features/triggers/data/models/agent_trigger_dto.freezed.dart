// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_trigger_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentTriggerDto {

 String get agentId; String get triggerUrl; String get secretHint; bool get enabled; int get minIntervalSecs;
/// Create a copy of AgentTriggerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentTriggerDtoCopyWith<AgentTriggerDto> get copyWith => _$AgentTriggerDtoCopyWithImpl<AgentTriggerDto>(this as AgentTriggerDto, _$identity);

  /// Serializes this AgentTriggerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentTriggerDto&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.triggerUrl, triggerUrl) || other.triggerUrl == triggerUrl)&&(identical(other.secretHint, secretHint) || other.secretHint == secretHint)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.minIntervalSecs, minIntervalSecs) || other.minIntervalSecs == minIntervalSecs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentId,triggerUrl,secretHint,enabled,minIntervalSecs);

@override
String toString() {
  return 'AgentTriggerDto(agentId: $agentId, triggerUrl: $triggerUrl, secretHint: $secretHint, enabled: $enabled, minIntervalSecs: $minIntervalSecs)';
}


}

/// @nodoc
abstract mixin class $AgentTriggerDtoCopyWith<$Res>  {
  factory $AgentTriggerDtoCopyWith(AgentTriggerDto value, $Res Function(AgentTriggerDto) _then) = _$AgentTriggerDtoCopyWithImpl;
@useResult
$Res call({
 String agentId, String triggerUrl, String secretHint, bool enabled, int minIntervalSecs
});




}
/// @nodoc
class _$AgentTriggerDtoCopyWithImpl<$Res>
    implements $AgentTriggerDtoCopyWith<$Res> {
  _$AgentTriggerDtoCopyWithImpl(this._self, this._then);

  final AgentTriggerDto _self;
  final $Res Function(AgentTriggerDto) _then;

/// Create a copy of AgentTriggerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agentId = null,Object? triggerUrl = null,Object? secretHint = null,Object? enabled = null,Object? minIntervalSecs = null,}) {
  return _then(_self.copyWith(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,triggerUrl: null == triggerUrl ? _self.triggerUrl : triggerUrl // ignore: cast_nullable_to_non_nullable
as String,secretHint: null == secretHint ? _self.secretHint : secretHint // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,minIntervalSecs: null == minIntervalSecs ? _self.minIntervalSecs : minIntervalSecs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentTriggerDto].
extension AgentTriggerDtoPatterns on AgentTriggerDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentTriggerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentTriggerDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentTriggerDto value)  $default,){
final _that = this;
switch (_that) {
case _AgentTriggerDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentTriggerDto value)?  $default,){
final _that = this;
switch (_that) {
case _AgentTriggerDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agentId,  String triggerUrl,  String secretHint,  bool enabled,  int minIntervalSecs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentTriggerDto() when $default != null:
return $default(_that.agentId,_that.triggerUrl,_that.secretHint,_that.enabled,_that.minIntervalSecs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agentId,  String triggerUrl,  String secretHint,  bool enabled,  int minIntervalSecs)  $default,) {final _that = this;
switch (_that) {
case _AgentTriggerDto():
return $default(_that.agentId,_that.triggerUrl,_that.secretHint,_that.enabled,_that.minIntervalSecs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agentId,  String triggerUrl,  String secretHint,  bool enabled,  int minIntervalSecs)?  $default,) {final _that = this;
switch (_that) {
case _AgentTriggerDto() when $default != null:
return $default(_that.agentId,_that.triggerUrl,_that.secretHint,_that.enabled,_that.minIntervalSecs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentTriggerDto extends AgentTriggerDto {
  const _AgentTriggerDto({required this.agentId, required this.triggerUrl, required this.secretHint, this.enabled = true, this.minIntervalSecs = 30}): super._();
  factory _AgentTriggerDto.fromJson(Map<String, dynamic> json) => _$AgentTriggerDtoFromJson(json);

@override final  String agentId;
@override final  String triggerUrl;
@override final  String secretHint;
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  int minIntervalSecs;

/// Create a copy of AgentTriggerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentTriggerDtoCopyWith<_AgentTriggerDto> get copyWith => __$AgentTriggerDtoCopyWithImpl<_AgentTriggerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentTriggerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentTriggerDto&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.triggerUrl, triggerUrl) || other.triggerUrl == triggerUrl)&&(identical(other.secretHint, secretHint) || other.secretHint == secretHint)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.minIntervalSecs, minIntervalSecs) || other.minIntervalSecs == minIntervalSecs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentId,triggerUrl,secretHint,enabled,minIntervalSecs);

@override
String toString() {
  return 'AgentTriggerDto(agentId: $agentId, triggerUrl: $triggerUrl, secretHint: $secretHint, enabled: $enabled, minIntervalSecs: $minIntervalSecs)';
}


}

/// @nodoc
abstract mixin class _$AgentTriggerDtoCopyWith<$Res> implements $AgentTriggerDtoCopyWith<$Res> {
  factory _$AgentTriggerDtoCopyWith(_AgentTriggerDto value, $Res Function(_AgentTriggerDto) _then) = __$AgentTriggerDtoCopyWithImpl;
@override @useResult
$Res call({
 String agentId, String triggerUrl, String secretHint, bool enabled, int minIntervalSecs
});




}
/// @nodoc
class __$AgentTriggerDtoCopyWithImpl<$Res>
    implements _$AgentTriggerDtoCopyWith<$Res> {
  __$AgentTriggerDtoCopyWithImpl(this._self, this._then);

  final _AgentTriggerDto _self;
  final $Res Function(_AgentTriggerDto) _then;

/// Create a copy of AgentTriggerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agentId = null,Object? triggerUrl = null,Object? secretHint = null,Object? enabled = null,Object? minIntervalSecs = null,}) {
  return _then(_AgentTriggerDto(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,triggerUrl: null == triggerUrl ? _self.triggerUrl : triggerUrl // ignore: cast_nullable_to_non_nullable
as String,secretHint: null == secretHint ? _self.secretHint : secretHint // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,minIntervalSecs: null == minIntervalSecs ? _self.minIntervalSecs : minIntervalSecs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TriggerRunDto {

 String get runId; bool get delivered; String get detail;
/// Create a copy of TriggerRunDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerRunDtoCopyWith<TriggerRunDto> get copyWith => _$TriggerRunDtoCopyWithImpl<TriggerRunDto>(this as TriggerRunDto, _$identity);

  /// Serializes this TriggerRunDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerRunDto&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.delivered, delivered) || other.delivered == delivered)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,delivered,detail);

@override
String toString() {
  return 'TriggerRunDto(runId: $runId, delivered: $delivered, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $TriggerRunDtoCopyWith<$Res>  {
  factory $TriggerRunDtoCopyWith(TriggerRunDto value, $Res Function(TriggerRunDto) _then) = _$TriggerRunDtoCopyWithImpl;
@useResult
$Res call({
 String runId, bool delivered, String detail
});




}
/// @nodoc
class _$TriggerRunDtoCopyWithImpl<$Res>
    implements $TriggerRunDtoCopyWith<$Res> {
  _$TriggerRunDtoCopyWithImpl(this._self, this._then);

  final TriggerRunDto _self;
  final $Res Function(TriggerRunDto) _then;

/// Create a copy of TriggerRunDto
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


/// Adds pattern-matching-related methods to [TriggerRunDto].
extension TriggerRunDtoPatterns on TriggerRunDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerRunDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerRunDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerRunDto value)  $default,){
final _that = this;
switch (_that) {
case _TriggerRunDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerRunDto value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerRunDto() when $default != null:
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
case _TriggerRunDto() when $default != null:
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
case _TriggerRunDto():
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
case _TriggerRunDto() when $default != null:
return $default(_that.runId,_that.delivered,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerRunDto extends TriggerRunDto {
  const _TriggerRunDto({required this.runId, required this.delivered, this.detail = ''}): super._();
  factory _TriggerRunDto.fromJson(Map<String, dynamic> json) => _$TriggerRunDtoFromJson(json);

@override final  String runId;
@override final  bool delivered;
@override@JsonKey() final  String detail;

/// Create a copy of TriggerRunDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerRunDtoCopyWith<_TriggerRunDto> get copyWith => __$TriggerRunDtoCopyWithImpl<_TriggerRunDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerRunDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerRunDto&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.delivered, delivered) || other.delivered == delivered)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,delivered,detail);

@override
String toString() {
  return 'TriggerRunDto(runId: $runId, delivered: $delivered, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$TriggerRunDtoCopyWith<$Res> implements $TriggerRunDtoCopyWith<$Res> {
  factory _$TriggerRunDtoCopyWith(_TriggerRunDto value, $Res Function(_TriggerRunDto) _then) = __$TriggerRunDtoCopyWithImpl;
@override @useResult
$Res call({
 String runId, bool delivered, String detail
});




}
/// @nodoc
class __$TriggerRunDtoCopyWithImpl<$Res>
    implements _$TriggerRunDtoCopyWith<$Res> {
  __$TriggerRunDtoCopyWithImpl(this._self, this._then);

  final _TriggerRunDto _self;
  final $Res Function(_TriggerRunDto) _then;

/// Create a copy of TriggerRunDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? delivered = null,Object? detail = null,}) {
  return _then(_TriggerRunDto(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,delivered: null == delivered ? _self.delivered : delivered // ignore: cast_nullable_to_non_nullable
as bool,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TriggerCredentialsDto {

 AgentTriggerDto get trigger; String get triggerSecret;
/// Create a copy of TriggerCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerCredentialsDtoCopyWith<TriggerCredentialsDto> get copyWith => _$TriggerCredentialsDtoCopyWithImpl<TriggerCredentialsDto>(this as TriggerCredentialsDto, _$identity);

  /// Serializes this TriggerCredentialsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerCredentialsDto&&(identical(other.trigger, trigger) || other.trigger == trigger)&&(identical(other.triggerSecret, triggerSecret) || other.triggerSecret == triggerSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trigger,triggerSecret);

@override
String toString() {
  return 'TriggerCredentialsDto(trigger: $trigger, triggerSecret: $triggerSecret)';
}


}

/// @nodoc
abstract mixin class $TriggerCredentialsDtoCopyWith<$Res>  {
  factory $TriggerCredentialsDtoCopyWith(TriggerCredentialsDto value, $Res Function(TriggerCredentialsDto) _then) = _$TriggerCredentialsDtoCopyWithImpl;
@useResult
$Res call({
 AgentTriggerDto trigger, String triggerSecret
});


$AgentTriggerDtoCopyWith<$Res> get trigger;

}
/// @nodoc
class _$TriggerCredentialsDtoCopyWithImpl<$Res>
    implements $TriggerCredentialsDtoCopyWith<$Res> {
  _$TriggerCredentialsDtoCopyWithImpl(this._self, this._then);

  final TriggerCredentialsDto _self;
  final $Res Function(TriggerCredentialsDto) _then;

/// Create a copy of TriggerCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trigger = null,Object? triggerSecret = null,}) {
  return _then(_self.copyWith(
trigger: null == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as AgentTriggerDto,triggerSecret: null == triggerSecret ? _self.triggerSecret : triggerSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of TriggerCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentTriggerDtoCopyWith<$Res> get trigger {
  
  return $AgentTriggerDtoCopyWith<$Res>(_self.trigger, (value) {
    return _then(_self.copyWith(trigger: value));
  });
}
}


/// Adds pattern-matching-related methods to [TriggerCredentialsDto].
extension TriggerCredentialsDtoPatterns on TriggerCredentialsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerCredentialsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerCredentialsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerCredentialsDto value)  $default,){
final _that = this;
switch (_that) {
case _TriggerCredentialsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerCredentialsDto value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerCredentialsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AgentTriggerDto trigger,  String triggerSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerCredentialsDto() when $default != null:
return $default(_that.trigger,_that.triggerSecret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AgentTriggerDto trigger,  String triggerSecret)  $default,) {final _that = this;
switch (_that) {
case _TriggerCredentialsDto():
return $default(_that.trigger,_that.triggerSecret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AgentTriggerDto trigger,  String triggerSecret)?  $default,) {final _that = this;
switch (_that) {
case _TriggerCredentialsDto() when $default != null:
return $default(_that.trigger,_that.triggerSecret);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerCredentialsDto extends TriggerCredentialsDto {
  const _TriggerCredentialsDto({required this.trigger, required this.triggerSecret}): super._();
  factory _TriggerCredentialsDto.fromJson(Map<String, dynamic> json) => _$TriggerCredentialsDtoFromJson(json);

@override final  AgentTriggerDto trigger;
@override final  String triggerSecret;

/// Create a copy of TriggerCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerCredentialsDtoCopyWith<_TriggerCredentialsDto> get copyWith => __$TriggerCredentialsDtoCopyWithImpl<_TriggerCredentialsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerCredentialsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerCredentialsDto&&(identical(other.trigger, trigger) || other.trigger == trigger)&&(identical(other.triggerSecret, triggerSecret) || other.triggerSecret == triggerSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trigger,triggerSecret);

@override
String toString() {
  return 'TriggerCredentialsDto(trigger: $trigger, triggerSecret: $triggerSecret)';
}


}

/// @nodoc
abstract mixin class _$TriggerCredentialsDtoCopyWith<$Res> implements $TriggerCredentialsDtoCopyWith<$Res> {
  factory _$TriggerCredentialsDtoCopyWith(_TriggerCredentialsDto value, $Res Function(_TriggerCredentialsDto) _then) = __$TriggerCredentialsDtoCopyWithImpl;
@override @useResult
$Res call({
 AgentTriggerDto trigger, String triggerSecret
});


@override $AgentTriggerDtoCopyWith<$Res> get trigger;

}
/// @nodoc
class __$TriggerCredentialsDtoCopyWithImpl<$Res>
    implements _$TriggerCredentialsDtoCopyWith<$Res> {
  __$TriggerCredentialsDtoCopyWithImpl(this._self, this._then);

  final _TriggerCredentialsDto _self;
  final $Res Function(_TriggerCredentialsDto) _then;

/// Create a copy of TriggerCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trigger = null,Object? triggerSecret = null,}) {
  return _then(_TriggerCredentialsDto(
trigger: null == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as AgentTriggerDto,triggerSecret: null == triggerSecret ? _self.triggerSecret : triggerSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of TriggerCredentialsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentTriggerDtoCopyWith<$Res> get trigger {
  
  return $AgentTriggerDtoCopyWith<$Res>(_self.trigger, (value) {
    return _then(_self.copyWith(trigger: value));
  });
}
}

// dart format on
