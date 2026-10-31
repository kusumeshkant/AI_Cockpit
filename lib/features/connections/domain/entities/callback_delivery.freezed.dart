// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'callback_delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallbackDelivery {

 CallbackDeliveryState get state; DateTime get at;
/// Create a copy of CallbackDelivery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallbackDeliveryCopyWith<CallbackDelivery> get copyWith => _$CallbackDeliveryCopyWithImpl<CallbackDelivery>(this as CallbackDelivery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallbackDelivery&&(identical(other.state, state) || other.state == state)&&(identical(other.at, at) || other.at == at));
}


@override
int get hashCode => Object.hash(runtimeType,state,at);

@override
String toString() {
  return 'CallbackDelivery(state: $state, at: $at)';
}


}

/// @nodoc
abstract mixin class $CallbackDeliveryCopyWith<$Res>  {
  factory $CallbackDeliveryCopyWith(CallbackDelivery value, $Res Function(CallbackDelivery) _then) = _$CallbackDeliveryCopyWithImpl;
@useResult
$Res call({
 CallbackDeliveryState state, DateTime at
});




}
/// @nodoc
class _$CallbackDeliveryCopyWithImpl<$Res>
    implements $CallbackDeliveryCopyWith<$Res> {
  _$CallbackDeliveryCopyWithImpl(this._self, this._then);

  final CallbackDelivery _self;
  final $Res Function(CallbackDelivery) _then;

/// Create a copy of CallbackDelivery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? at = null,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as CallbackDeliveryState,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CallbackDelivery].
extension CallbackDeliveryPatterns on CallbackDelivery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallbackDelivery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallbackDelivery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallbackDelivery value)  $default,){
final _that = this;
switch (_that) {
case _CallbackDelivery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallbackDelivery value)?  $default,){
final _that = this;
switch (_that) {
case _CallbackDelivery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallbackDeliveryState state,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallbackDelivery() when $default != null:
return $default(_that.state,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallbackDeliveryState state,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _CallbackDelivery():
return $default(_that.state,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallbackDeliveryState state,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _CallbackDelivery() when $default != null:
return $default(_that.state,_that.at);case _:
  return null;

}
}

}

/// @nodoc


class _CallbackDelivery implements CallbackDelivery {
  const _CallbackDelivery({required this.state, required this.at});
  

@override final  CallbackDeliveryState state;
@override final  DateTime at;

/// Create a copy of CallbackDelivery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallbackDeliveryCopyWith<_CallbackDelivery> get copyWith => __$CallbackDeliveryCopyWithImpl<_CallbackDelivery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallbackDelivery&&(identical(other.state, state) || other.state == state)&&(identical(other.at, at) || other.at == at));
}


@override
int get hashCode => Object.hash(runtimeType,state,at);

@override
String toString() {
  return 'CallbackDelivery(state: $state, at: $at)';
}


}

/// @nodoc
abstract mixin class _$CallbackDeliveryCopyWith<$Res> implements $CallbackDeliveryCopyWith<$Res> {
  factory _$CallbackDeliveryCopyWith(_CallbackDelivery value, $Res Function(_CallbackDelivery) _then) = __$CallbackDeliveryCopyWithImpl;
@override @useResult
$Res call({
 CallbackDeliveryState state, DateTime at
});




}
/// @nodoc
class __$CallbackDeliveryCopyWithImpl<$Res>
    implements _$CallbackDeliveryCopyWith<$Res> {
  __$CallbackDeliveryCopyWithImpl(this._self, this._then);

  final _CallbackDelivery _self;
  final $Res Function(_CallbackDelivery) _then;

/// Create a copy of CallbackDelivery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? at = null,}) {
  return _then(_CallbackDelivery(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as CallbackDeliveryState,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
