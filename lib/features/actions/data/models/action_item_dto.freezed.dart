// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionItemDto {

 String get id; String get agentId; String get type; String get title; Map<String, dynamic> get payload; String get status; DateTime get createdAt; String? get agentName; String? get agentPlatform; String? get summary; List<String> get editableFields; String? get decision; DateTime? get decidedAt; DateTime? get expiresAt;
/// Create a copy of ActionItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionItemDtoCopyWith<ActionItemDto> get copyWith => _$ActionItemDtoCopyWithImpl<ActionItemDto>(this as ActionItemDto, _$identity);

  /// Serializes this ActionItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.agentPlatform, agentPlatform) || other.agentPlatform == agentPlatform)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.editableFields, editableFields)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,agentId,type,title,const DeepCollectionEquality().hash(payload),status,createdAt,agentName,agentPlatform,summary,const DeepCollectionEquality().hash(editableFields),decision,decidedAt,expiresAt);

@override
String toString() {
  return 'ActionItemDto(id: $id, agentId: $agentId, type: $type, title: $title, payload: $payload, status: $status, createdAt: $createdAt, agentName: $agentName, agentPlatform: $agentPlatform, summary: $summary, editableFields: $editableFields, decision: $decision, decidedAt: $decidedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $ActionItemDtoCopyWith<$Res>  {
  factory $ActionItemDtoCopyWith(ActionItemDto value, $Res Function(ActionItemDto) _then) = _$ActionItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String agentId, String type, String title, Map<String, dynamic> payload, String status, DateTime createdAt, String? agentName, String? agentPlatform, String? summary, List<String> editableFields, String? decision, DateTime? decidedAt, DateTime? expiresAt
});




}
/// @nodoc
class _$ActionItemDtoCopyWithImpl<$Res>
    implements $ActionItemDtoCopyWith<$Res> {
  _$ActionItemDtoCopyWithImpl(this._self, this._then);

  final ActionItemDto _self;
  final $Res Function(ActionItemDto) _then;

/// Create a copy of ActionItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? agentId = null,Object? type = null,Object? title = null,Object? payload = null,Object? status = null,Object? createdAt = null,Object? agentName = freezed,Object? agentPlatform = freezed,Object? summary = freezed,Object? editableFields = null,Object? decision = freezed,Object? decidedAt = freezed,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,agentName: freezed == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String?,agentPlatform: freezed == agentPlatform ? _self.agentPlatform : agentPlatform // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,editableFields: null == editableFields ? _self.editableFields : editableFields // ignore: cast_nullable_to_non_nullable
as List<String>,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionItemDto].
extension ActionItemDtoPatterns on ActionItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionItemDto value)  $default,){
final _that = this;
switch (_that) {
case _ActionItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ActionItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String agentId,  String type,  String title,  Map<String, dynamic> payload,  String status,  DateTime createdAt,  String? agentName,  String? agentPlatform,  String? summary,  List<String> editableFields,  String? decision,  DateTime? decidedAt,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionItemDto() when $default != null:
return $default(_that.id,_that.agentId,_that.type,_that.title,_that.payload,_that.status,_that.createdAt,_that.agentName,_that.agentPlatform,_that.summary,_that.editableFields,_that.decision,_that.decidedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String agentId,  String type,  String title,  Map<String, dynamic> payload,  String status,  DateTime createdAt,  String? agentName,  String? agentPlatform,  String? summary,  List<String> editableFields,  String? decision,  DateTime? decidedAt,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _ActionItemDto():
return $default(_that.id,_that.agentId,_that.type,_that.title,_that.payload,_that.status,_that.createdAt,_that.agentName,_that.agentPlatform,_that.summary,_that.editableFields,_that.decision,_that.decidedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String agentId,  String type,  String title,  Map<String, dynamic> payload,  String status,  DateTime createdAt,  String? agentName,  String? agentPlatform,  String? summary,  List<String> editableFields,  String? decision,  DateTime? decidedAt,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _ActionItemDto() when $default != null:
return $default(_that.id,_that.agentId,_that.type,_that.title,_that.payload,_that.status,_that.createdAt,_that.agentName,_that.agentPlatform,_that.summary,_that.editableFields,_that.decision,_that.decidedAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionItemDto extends ActionItemDto {
  const _ActionItemDto({required this.id, required this.agentId, required this.type, required this.title, required final  Map<String, dynamic> payload, required this.status, required this.createdAt, this.agentName, this.agentPlatform, this.summary, final  List<String> editableFields = const <String>[], this.decision, this.decidedAt, this.expiresAt}): _payload = payload,_editableFields = editableFields,super._();
  factory _ActionItemDto.fromJson(Map<String, dynamic> json) => _$ActionItemDtoFromJson(json);

@override final  String id;
@override final  String agentId;
@override final  String type;
@override final  String title;
 final  Map<String, dynamic> _payload;
@override Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override final  String status;
@override final  DateTime createdAt;
@override final  String? agentName;
@override final  String? agentPlatform;
@override final  String? summary;
 final  List<String> _editableFields;
@override@JsonKey() List<String> get editableFields {
  if (_editableFields is EqualUnmodifiableListView) return _editableFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_editableFields);
}

@override final  String? decision;
@override final  DateTime? decidedAt;
@override final  DateTime? expiresAt;

/// Create a copy of ActionItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionItemDtoCopyWith<_ActionItemDto> get copyWith => __$ActionItemDtoCopyWithImpl<_ActionItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.agentPlatform, agentPlatform) || other.agentPlatform == agentPlatform)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._editableFields, _editableFields)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,agentId,type,title,const DeepCollectionEquality().hash(_payload),status,createdAt,agentName,agentPlatform,summary,const DeepCollectionEquality().hash(_editableFields),decision,decidedAt,expiresAt);

@override
String toString() {
  return 'ActionItemDto(id: $id, agentId: $agentId, type: $type, title: $title, payload: $payload, status: $status, createdAt: $createdAt, agentName: $agentName, agentPlatform: $agentPlatform, summary: $summary, editableFields: $editableFields, decision: $decision, decidedAt: $decidedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ActionItemDtoCopyWith<$Res> implements $ActionItemDtoCopyWith<$Res> {
  factory _$ActionItemDtoCopyWith(_ActionItemDto value, $Res Function(_ActionItemDto) _then) = __$ActionItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String agentId, String type, String title, Map<String, dynamic> payload, String status, DateTime createdAt, String? agentName, String? agentPlatform, String? summary, List<String> editableFields, String? decision, DateTime? decidedAt, DateTime? expiresAt
});




}
/// @nodoc
class __$ActionItemDtoCopyWithImpl<$Res>
    implements _$ActionItemDtoCopyWith<$Res> {
  __$ActionItemDtoCopyWithImpl(this._self, this._then);

  final _ActionItemDto _self;
  final $Res Function(_ActionItemDto) _then;

/// Create a copy of ActionItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? agentId = null,Object? type = null,Object? title = null,Object? payload = null,Object? status = null,Object? createdAt = null,Object? agentName = freezed,Object? agentPlatform = freezed,Object? summary = freezed,Object? editableFields = null,Object? decision = freezed,Object? decidedAt = freezed,Object? expiresAt = freezed,}) {
  return _then(_ActionItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,agentName: freezed == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String?,agentPlatform: freezed == agentPlatform ? _self.agentPlatform : agentPlatform // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,editableFields: null == editableFields ? _self._editableFields : editableFields // ignore: cast_nullable_to_non_nullable
as List<String>,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
