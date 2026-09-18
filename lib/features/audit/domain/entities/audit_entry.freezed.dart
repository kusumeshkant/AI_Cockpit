// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuditEntry {

 String get id; String get actionId; AuditEvent get event; DateTime get createdAt; String? get actionTitle; String? get agentName; AgentPlatform? get agentPlatform; String? get actorEmail; String? get decision; String? get reason; Map<String, dynamic>? get originalPayload; Map<String, dynamic>? get editedPayload;
/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryCopyWith<AuditEntry> get copyWith => _$AuditEntryCopyWithImpl<AuditEntry>(this as AuditEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.event, event) || other.event == event)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.actionTitle, actionTitle) || other.actionTitle == actionTitle)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.agentPlatform, agentPlatform) || other.agentPlatform == agentPlatform)&&(identical(other.actorEmail, actorEmail) || other.actorEmail == actorEmail)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.originalPayload, originalPayload)&&const DeepCollectionEquality().equals(other.editedPayload, editedPayload));
}


@override
int get hashCode => Object.hash(runtimeType,id,actionId,event,createdAt,actionTitle,agentName,agentPlatform,actorEmail,decision,reason,const DeepCollectionEquality().hash(originalPayload),const DeepCollectionEquality().hash(editedPayload));

@override
String toString() {
  return 'AuditEntry(id: $id, actionId: $actionId, event: $event, createdAt: $createdAt, actionTitle: $actionTitle, agentName: $agentName, agentPlatform: $agentPlatform, actorEmail: $actorEmail, decision: $decision, reason: $reason, originalPayload: $originalPayload, editedPayload: $editedPayload)';
}


}

/// @nodoc
abstract mixin class $AuditEntryCopyWith<$Res>  {
  factory $AuditEntryCopyWith(AuditEntry value, $Res Function(AuditEntry) _then) = _$AuditEntryCopyWithImpl;
@useResult
$Res call({
 String id, String actionId, AuditEvent event, DateTime createdAt, String? actionTitle, String? agentName, AgentPlatform? agentPlatform, String? actorEmail, String? decision, String? reason, Map<String, dynamic>? originalPayload, Map<String, dynamic>? editedPayload
});




}
/// @nodoc
class _$AuditEntryCopyWithImpl<$Res>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._self, this._then);

  final AuditEntry _self;
  final $Res Function(AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? actionId = null,Object? event = null,Object? createdAt = null,Object? actionTitle = freezed,Object? agentName = freezed,Object? agentPlatform = freezed,Object? actorEmail = freezed,Object? decision = freezed,Object? reason = freezed,Object? originalPayload = freezed,Object? editedPayload = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,actionId: null == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as AuditEvent,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,actionTitle: freezed == actionTitle ? _self.actionTitle : actionTitle // ignore: cast_nullable_to_non_nullable
as String?,agentName: freezed == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String?,agentPlatform: freezed == agentPlatform ? _self.agentPlatform : agentPlatform // ignore: cast_nullable_to_non_nullable
as AgentPlatform?,actorEmail: freezed == actorEmail ? _self.actorEmail : actorEmail // ignore: cast_nullable_to_non_nullable
as String?,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,originalPayload: freezed == originalPayload ? _self.originalPayload : originalPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,editedPayload: freezed == editedPayload ? _self.editedPayload : editedPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntry].
extension AuditEntryPatterns on AuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String actionId,  AuditEvent event,  DateTime createdAt,  String? actionTitle,  String? agentName,  AgentPlatform? agentPlatform,  String? actorEmail,  String? decision,  String? reason,  Map<String, dynamic>? originalPayload,  Map<String, dynamic>? editedPayload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.id,_that.actionId,_that.event,_that.createdAt,_that.actionTitle,_that.agentName,_that.agentPlatform,_that.actorEmail,_that.decision,_that.reason,_that.originalPayload,_that.editedPayload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String actionId,  AuditEvent event,  DateTime createdAt,  String? actionTitle,  String? agentName,  AgentPlatform? agentPlatform,  String? actorEmail,  String? decision,  String? reason,  Map<String, dynamic>? originalPayload,  Map<String, dynamic>? editedPayload)  $default,) {final _that = this;
switch (_that) {
case _AuditEntry():
return $default(_that.id,_that.actionId,_that.event,_that.createdAt,_that.actionTitle,_that.agentName,_that.agentPlatform,_that.actorEmail,_that.decision,_that.reason,_that.originalPayload,_that.editedPayload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String actionId,  AuditEvent event,  DateTime createdAt,  String? actionTitle,  String? agentName,  AgentPlatform? agentPlatform,  String? actorEmail,  String? decision,  String? reason,  Map<String, dynamic>? originalPayload,  Map<String, dynamic>? editedPayload)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.id,_that.actionId,_that.event,_that.createdAt,_that.actionTitle,_that.agentName,_that.agentPlatform,_that.actorEmail,_that.decision,_that.reason,_that.originalPayload,_that.editedPayload);case _:
  return null;

}
}

}

/// @nodoc


class _AuditEntry extends AuditEntry {
  const _AuditEntry({required this.id, required this.actionId, required this.event, required this.createdAt, this.actionTitle, this.agentName, this.agentPlatform, this.actorEmail, this.decision, this.reason, final  Map<String, dynamic>? originalPayload, final  Map<String, dynamic>? editedPayload}): _originalPayload = originalPayload,_editedPayload = editedPayload,super._();
  

@override final  String id;
@override final  String actionId;
@override final  AuditEvent event;
@override final  DateTime createdAt;
@override final  String? actionTitle;
@override final  String? agentName;
@override final  AgentPlatform? agentPlatform;
@override final  String? actorEmail;
@override final  String? decision;
@override final  String? reason;
 final  Map<String, dynamic>? _originalPayload;
@override Map<String, dynamic>? get originalPayload {
  final value = _originalPayload;
  if (value == null) return null;
  if (_originalPayload is EqualUnmodifiableMapView) return _originalPayload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _editedPayload;
@override Map<String, dynamic>? get editedPayload {
  final value = _editedPayload;
  if (value == null) return null;
  if (_editedPayload is EqualUnmodifiableMapView) return _editedPayload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryCopyWith<_AuditEntry> get copyWith => __$AuditEntryCopyWithImpl<_AuditEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.event, event) || other.event == event)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.actionTitle, actionTitle) || other.actionTitle == actionTitle)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.agentPlatform, agentPlatform) || other.agentPlatform == agentPlatform)&&(identical(other.actorEmail, actorEmail) || other.actorEmail == actorEmail)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other._originalPayload, _originalPayload)&&const DeepCollectionEquality().equals(other._editedPayload, _editedPayload));
}


@override
int get hashCode => Object.hash(runtimeType,id,actionId,event,createdAt,actionTitle,agentName,agentPlatform,actorEmail,decision,reason,const DeepCollectionEquality().hash(_originalPayload),const DeepCollectionEquality().hash(_editedPayload));

@override
String toString() {
  return 'AuditEntry(id: $id, actionId: $actionId, event: $event, createdAt: $createdAt, actionTitle: $actionTitle, agentName: $agentName, agentPlatform: $agentPlatform, actorEmail: $actorEmail, decision: $decision, reason: $reason, originalPayload: $originalPayload, editedPayload: $editedPayload)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryCopyWith<$Res> implements $AuditEntryCopyWith<$Res> {
  factory _$AuditEntryCopyWith(_AuditEntry value, $Res Function(_AuditEntry) _then) = __$AuditEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String actionId, AuditEvent event, DateTime createdAt, String? actionTitle, String? agentName, AgentPlatform? agentPlatform, String? actorEmail, String? decision, String? reason, Map<String, dynamic>? originalPayload, Map<String, dynamic>? editedPayload
});




}
/// @nodoc
class __$AuditEntryCopyWithImpl<$Res>
    implements _$AuditEntryCopyWith<$Res> {
  __$AuditEntryCopyWithImpl(this._self, this._then);

  final _AuditEntry _self;
  final $Res Function(_AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? actionId = null,Object? event = null,Object? createdAt = null,Object? actionTitle = freezed,Object? agentName = freezed,Object? agentPlatform = freezed,Object? actorEmail = freezed,Object? decision = freezed,Object? reason = freezed,Object? originalPayload = freezed,Object? editedPayload = freezed,}) {
  return _then(_AuditEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,actionId: null == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as AuditEvent,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,actionTitle: freezed == actionTitle ? _self.actionTitle : actionTitle // ignore: cast_nullable_to_non_nullable
as String?,agentName: freezed == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String?,agentPlatform: freezed == agentPlatform ? _self.agentPlatform : agentPlatform // ignore: cast_nullable_to_non_nullable
as AgentPlatform?,actorEmail: freezed == actorEmail ? _self.actorEmail : actorEmail // ignore: cast_nullable_to_non_nullable
as String?,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,originalPayload: freezed == originalPayload ? _self._originalPayload : originalPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,editedPayload: freezed == editedPayload ? _self._editedPayload : editedPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
