// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_decision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActionDecision {

 String get actionId; DecisionType get type; String get idempotencyKey; Map<String, dynamic>? get editedPayload; String? get reason;
/// Create a copy of ActionDecision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionDecisionCopyWith<ActionDecision> get copyWith => _$ActionDecisionCopyWithImpl<ActionDecision>(this as ActionDecision, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionDecision&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&const DeepCollectionEquality().equals(other.editedPayload, editedPayload)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,actionId,type,idempotencyKey,const DeepCollectionEquality().hash(editedPayload),reason);

@override
String toString() {
  return 'ActionDecision(actionId: $actionId, type: $type, idempotencyKey: $idempotencyKey, editedPayload: $editedPayload, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ActionDecisionCopyWith<$Res>  {
  factory $ActionDecisionCopyWith(ActionDecision value, $Res Function(ActionDecision) _then) = _$ActionDecisionCopyWithImpl;
@useResult
$Res call({
 String actionId, DecisionType type, String idempotencyKey, Map<String, dynamic>? editedPayload, String? reason
});




}
/// @nodoc
class _$ActionDecisionCopyWithImpl<$Res>
    implements $ActionDecisionCopyWith<$Res> {
  _$ActionDecisionCopyWithImpl(this._self, this._then);

  final ActionDecision _self;
  final $Res Function(ActionDecision) _then;

/// Create a copy of ActionDecision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionId = null,Object? type = null,Object? idempotencyKey = null,Object? editedPayload = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
actionId: null == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DecisionType,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,editedPayload: freezed == editedPayload ? _self.editedPayload : editedPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionDecision].
extension ActionDecisionPatterns on ActionDecision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionDecision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionDecision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionDecision value)  $default,){
final _that = this;
switch (_that) {
case _ActionDecision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionDecision value)?  $default,){
final _that = this;
switch (_that) {
case _ActionDecision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String actionId,  DecisionType type,  String idempotencyKey,  Map<String, dynamic>? editedPayload,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionDecision() when $default != null:
return $default(_that.actionId,_that.type,_that.idempotencyKey,_that.editedPayload,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String actionId,  DecisionType type,  String idempotencyKey,  Map<String, dynamic>? editedPayload,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _ActionDecision():
return $default(_that.actionId,_that.type,_that.idempotencyKey,_that.editedPayload,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String actionId,  DecisionType type,  String idempotencyKey,  Map<String, dynamic>? editedPayload,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _ActionDecision() when $default != null:
return $default(_that.actionId,_that.type,_that.idempotencyKey,_that.editedPayload,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _ActionDecision implements ActionDecision {
  const _ActionDecision({required this.actionId, required this.type, required this.idempotencyKey, final  Map<String, dynamic>? editedPayload, this.reason}): _editedPayload = editedPayload;
  

@override final  String actionId;
@override final  DecisionType type;
@override final  String idempotencyKey;
 final  Map<String, dynamic>? _editedPayload;
@override Map<String, dynamic>? get editedPayload {
  final value = _editedPayload;
  if (value == null) return null;
  if (_editedPayload is EqualUnmodifiableMapView) return _editedPayload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? reason;

/// Create a copy of ActionDecision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionDecisionCopyWith<_ActionDecision> get copyWith => __$ActionDecisionCopyWithImpl<_ActionDecision>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionDecision&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&const DeepCollectionEquality().equals(other._editedPayload, _editedPayload)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,actionId,type,idempotencyKey,const DeepCollectionEquality().hash(_editedPayload),reason);

@override
String toString() {
  return 'ActionDecision(actionId: $actionId, type: $type, idempotencyKey: $idempotencyKey, editedPayload: $editedPayload, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ActionDecisionCopyWith<$Res> implements $ActionDecisionCopyWith<$Res> {
  factory _$ActionDecisionCopyWith(_ActionDecision value, $Res Function(_ActionDecision) _then) = __$ActionDecisionCopyWithImpl;
@override @useResult
$Res call({
 String actionId, DecisionType type, String idempotencyKey, Map<String, dynamic>? editedPayload, String? reason
});




}
/// @nodoc
class __$ActionDecisionCopyWithImpl<$Res>
    implements _$ActionDecisionCopyWith<$Res> {
  __$ActionDecisionCopyWithImpl(this._self, this._then);

  final _ActionDecision _self;
  final $Res Function(_ActionDecision) _then;

/// Create a copy of ActionDecision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionId = null,Object? type = null,Object? idempotencyKey = null,Object? editedPayload = freezed,Object? reason = freezed,}) {
  return _then(_ActionDecision(
actionId: null == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DecisionType,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,editedPayload: freezed == editedPayload ? _self._editedPayload : editedPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
