// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgentService {

 String get slug; String get displayName; String get description; String? get icon; ServiceStatus get status; String get contractVersion; String? get minAppVersion; ServiceUi get ui; int get uiSchemaVersion;
/// Create a copy of AgentService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentServiceCopyWith<AgentService> get copyWith => _$AgentServiceCopyWithImpl<AgentService>(this as AgentService, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentService&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.status, status) || other.status == status)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion)&&(identical(other.ui, ui) || other.ui == ui)&&(identical(other.uiSchemaVersion, uiSchemaVersion) || other.uiSchemaVersion == uiSchemaVersion));
}


@override
int get hashCode => Object.hash(runtimeType,slug,displayName,description,icon,status,contractVersion,minAppVersion,ui,uiSchemaVersion);

@override
String toString() {
  return 'AgentService(slug: $slug, displayName: $displayName, description: $description, icon: $icon, status: $status, contractVersion: $contractVersion, minAppVersion: $minAppVersion, ui: $ui, uiSchemaVersion: $uiSchemaVersion)';
}


}

/// @nodoc
abstract mixin class $AgentServiceCopyWith<$Res>  {
  factory $AgentServiceCopyWith(AgentService value, $Res Function(AgentService) _then) = _$AgentServiceCopyWithImpl;
@useResult
$Res call({
 String slug, String displayName, String description, String? icon, ServiceStatus status, String contractVersion, String? minAppVersion, ServiceUi ui, int uiSchemaVersion
});




}
/// @nodoc
class _$AgentServiceCopyWithImpl<$Res>
    implements $AgentServiceCopyWith<$Res> {
  _$AgentServiceCopyWithImpl(this._self, this._then);

  final AgentService _self;
  final $Res Function(AgentService) _then;

/// Create a copy of AgentService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? displayName = null,Object? description = null,Object? icon = freezed,Object? status = null,Object? contractVersion = null,Object? minAppVersion = freezed,Object? ui = null,Object? uiSchemaVersion = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ServiceStatus,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,minAppVersion: freezed == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String?,ui: null == ui ? _self.ui : ui // ignore: cast_nullable_to_non_nullable
as ServiceUi,uiSchemaVersion: null == uiSchemaVersion ? _self.uiSchemaVersion : uiSchemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentService].
extension AgentServicePatterns on AgentService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentService value)  $default,){
final _that = this;
switch (_that) {
case _AgentService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentService value)?  $default,){
final _that = this;
switch (_that) {
case _AgentService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String displayName,  String description,  String? icon,  ServiceStatus status,  String contractVersion,  String? minAppVersion,  ServiceUi ui,  int uiSchemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentService() when $default != null:
return $default(_that.slug,_that.displayName,_that.description,_that.icon,_that.status,_that.contractVersion,_that.minAppVersion,_that.ui,_that.uiSchemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String displayName,  String description,  String? icon,  ServiceStatus status,  String contractVersion,  String? minAppVersion,  ServiceUi ui,  int uiSchemaVersion)  $default,) {final _that = this;
switch (_that) {
case _AgentService():
return $default(_that.slug,_that.displayName,_that.description,_that.icon,_that.status,_that.contractVersion,_that.minAppVersion,_that.ui,_that.uiSchemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String displayName,  String description,  String? icon,  ServiceStatus status,  String contractVersion,  String? minAppVersion,  ServiceUi ui,  int uiSchemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _AgentService() when $default != null:
return $default(_that.slug,_that.displayName,_that.description,_that.icon,_that.status,_that.contractVersion,_that.minAppVersion,_that.ui,_that.uiSchemaVersion);case _:
  return null;

}
}

}

/// @nodoc


class _AgentService implements AgentService {
  const _AgentService({required this.slug, required this.displayName, this.description = '', this.icon, this.status = ServiceStatus.unknown, this.contractVersion = '1.0', this.minAppVersion, this.ui = ServiceUi.unknown, this.uiSchemaVersion = 1});
  

@override final  String slug;
@override final  String displayName;
@override@JsonKey() final  String description;
@override final  String? icon;
@override@JsonKey() final  ServiceStatus status;
@override@JsonKey() final  String contractVersion;
@override final  String? minAppVersion;
@override@JsonKey() final  ServiceUi ui;
@override@JsonKey() final  int uiSchemaVersion;

/// Create a copy of AgentService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentServiceCopyWith<_AgentService> get copyWith => __$AgentServiceCopyWithImpl<_AgentService>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentService&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.status, status) || other.status == status)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion)&&(identical(other.ui, ui) || other.ui == ui)&&(identical(other.uiSchemaVersion, uiSchemaVersion) || other.uiSchemaVersion == uiSchemaVersion));
}


@override
int get hashCode => Object.hash(runtimeType,slug,displayName,description,icon,status,contractVersion,minAppVersion,ui,uiSchemaVersion);

@override
String toString() {
  return 'AgentService(slug: $slug, displayName: $displayName, description: $description, icon: $icon, status: $status, contractVersion: $contractVersion, minAppVersion: $minAppVersion, ui: $ui, uiSchemaVersion: $uiSchemaVersion)';
}


}

/// @nodoc
abstract mixin class _$AgentServiceCopyWith<$Res> implements $AgentServiceCopyWith<$Res> {
  factory _$AgentServiceCopyWith(_AgentService value, $Res Function(_AgentService) _then) = __$AgentServiceCopyWithImpl;
@override @useResult
$Res call({
 String slug, String displayName, String description, String? icon, ServiceStatus status, String contractVersion, String? minAppVersion, ServiceUi ui, int uiSchemaVersion
});




}
/// @nodoc
class __$AgentServiceCopyWithImpl<$Res>
    implements _$AgentServiceCopyWith<$Res> {
  __$AgentServiceCopyWithImpl(this._self, this._then);

  final _AgentService _self;
  final $Res Function(_AgentService) _then;

/// Create a copy of AgentService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? displayName = null,Object? description = null,Object? icon = freezed,Object? status = null,Object? contractVersion = null,Object? minAppVersion = freezed,Object? ui = null,Object? uiSchemaVersion = null,}) {
  return _then(_AgentService(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ServiceStatus,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,minAppVersion: freezed == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String?,ui: null == ui ? _self.ui : ui // ignore: cast_nullable_to_non_nullable
as ServiceUi,uiSchemaVersion: null == uiSchemaVersion ? _self.uiSchemaVersion : uiSchemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ServiceAccess {

 String get serviceSlug; AccessState get state; String? get consentVersion; DateTime? get consentedAt; DateTime? get firstUsedAt;
/// Create a copy of ServiceAccess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceAccessCopyWith<ServiceAccess> get copyWith => _$ServiceAccessCopyWithImpl<ServiceAccess>(this as ServiceAccess, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceAccess&&(identical(other.serviceSlug, serviceSlug) || other.serviceSlug == serviceSlug)&&(identical(other.state, state) || other.state == state)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion)&&(identical(other.consentedAt, consentedAt) || other.consentedAt == consentedAt)&&(identical(other.firstUsedAt, firstUsedAt) || other.firstUsedAt == firstUsedAt));
}


@override
int get hashCode => Object.hash(runtimeType,serviceSlug,state,consentVersion,consentedAt,firstUsedAt);

@override
String toString() {
  return 'ServiceAccess(serviceSlug: $serviceSlug, state: $state, consentVersion: $consentVersion, consentedAt: $consentedAt, firstUsedAt: $firstUsedAt)';
}


}

/// @nodoc
abstract mixin class $ServiceAccessCopyWith<$Res>  {
  factory $ServiceAccessCopyWith(ServiceAccess value, $Res Function(ServiceAccess) _then) = _$ServiceAccessCopyWithImpl;
@useResult
$Res call({
 String serviceSlug, AccessState state, String? consentVersion, DateTime? consentedAt, DateTime? firstUsedAt
});




}
/// @nodoc
class _$ServiceAccessCopyWithImpl<$Res>
    implements $ServiceAccessCopyWith<$Res> {
  _$ServiceAccessCopyWithImpl(this._self, this._then);

  final ServiceAccess _self;
  final $Res Function(ServiceAccess) _then;

/// Create a copy of ServiceAccess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceSlug = null,Object? state = null,Object? consentVersion = freezed,Object? consentedAt = freezed,Object? firstUsedAt = freezed,}) {
  return _then(_self.copyWith(
serviceSlug: null == serviceSlug ? _self.serviceSlug : serviceSlug // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AccessState,consentVersion: freezed == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String?,consentedAt: freezed == consentedAt ? _self.consentedAt : consentedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,firstUsedAt: freezed == firstUsedAt ? _self.firstUsedAt : firstUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceAccess].
extension ServiceAccessPatterns on ServiceAccess {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceAccess value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceAccess() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceAccess value)  $default,){
final _that = this;
switch (_that) {
case _ServiceAccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceAccess value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceAccess() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceSlug,  AccessState state,  String? consentVersion,  DateTime? consentedAt,  DateTime? firstUsedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceAccess() when $default != null:
return $default(_that.serviceSlug,_that.state,_that.consentVersion,_that.consentedAt,_that.firstUsedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceSlug,  AccessState state,  String? consentVersion,  DateTime? consentedAt,  DateTime? firstUsedAt)  $default,) {final _that = this;
switch (_that) {
case _ServiceAccess():
return $default(_that.serviceSlug,_that.state,_that.consentVersion,_that.consentedAt,_that.firstUsedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceSlug,  AccessState state,  String? consentVersion,  DateTime? consentedAt,  DateTime? firstUsedAt)?  $default,) {final _that = this;
switch (_that) {
case _ServiceAccess() when $default != null:
return $default(_that.serviceSlug,_that.state,_that.consentVersion,_that.consentedAt,_that.firstUsedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceAccess implements ServiceAccess {
  const _ServiceAccess({required this.serviceSlug, this.state = AccessState.unknown, this.consentVersion, this.consentedAt, this.firstUsedAt});
  

@override final  String serviceSlug;
@override@JsonKey() final  AccessState state;
@override final  String? consentVersion;
@override final  DateTime? consentedAt;
@override final  DateTime? firstUsedAt;

/// Create a copy of ServiceAccess
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceAccessCopyWith<_ServiceAccess> get copyWith => __$ServiceAccessCopyWithImpl<_ServiceAccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceAccess&&(identical(other.serviceSlug, serviceSlug) || other.serviceSlug == serviceSlug)&&(identical(other.state, state) || other.state == state)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion)&&(identical(other.consentedAt, consentedAt) || other.consentedAt == consentedAt)&&(identical(other.firstUsedAt, firstUsedAt) || other.firstUsedAt == firstUsedAt));
}


@override
int get hashCode => Object.hash(runtimeType,serviceSlug,state,consentVersion,consentedAt,firstUsedAt);

@override
String toString() {
  return 'ServiceAccess(serviceSlug: $serviceSlug, state: $state, consentVersion: $consentVersion, consentedAt: $consentedAt, firstUsedAt: $firstUsedAt)';
}


}

/// @nodoc
abstract mixin class _$ServiceAccessCopyWith<$Res> implements $ServiceAccessCopyWith<$Res> {
  factory _$ServiceAccessCopyWith(_ServiceAccess value, $Res Function(_ServiceAccess) _then) = __$ServiceAccessCopyWithImpl;
@override @useResult
$Res call({
 String serviceSlug, AccessState state, String? consentVersion, DateTime? consentedAt, DateTime? firstUsedAt
});




}
/// @nodoc
class __$ServiceAccessCopyWithImpl<$Res>
    implements _$ServiceAccessCopyWith<$Res> {
  __$ServiceAccessCopyWithImpl(this._self, this._then);

  final _ServiceAccess _self;
  final $Res Function(_ServiceAccess) _then;

/// Create a copy of ServiceAccess
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceSlug = null,Object? state = null,Object? consentVersion = freezed,Object? consentedAt = freezed,Object? firstUsedAt = freezed,}) {
  return _then(_ServiceAccess(
serviceSlug: null == serviceSlug ? _self.serviceSlug : serviceSlug // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AccessState,consentVersion: freezed == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String?,consentedAt: freezed == consentedAt ? _self.consentedAt : consentedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,firstUsedAt: freezed == firstUsedAt ? _self.firstUsedAt : firstUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ServiceListing {

 AgentService get service; ServiceAccess? get access;
/// Create a copy of ServiceListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceListingCopyWith<ServiceListing> get copyWith => _$ServiceListingCopyWithImpl<ServiceListing>(this as ServiceListing, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceListing&&(identical(other.service, service) || other.service == service)&&(identical(other.access, access) || other.access == access));
}


@override
int get hashCode => Object.hash(runtimeType,service,access);

@override
String toString() {
  return 'ServiceListing(service: $service, access: $access)';
}


}

/// @nodoc
abstract mixin class $ServiceListingCopyWith<$Res>  {
  factory $ServiceListingCopyWith(ServiceListing value, $Res Function(ServiceListing) _then) = _$ServiceListingCopyWithImpl;
@useResult
$Res call({
 AgentService service, ServiceAccess? access
});


$AgentServiceCopyWith<$Res> get service;$ServiceAccessCopyWith<$Res>? get access;

}
/// @nodoc
class _$ServiceListingCopyWithImpl<$Res>
    implements $ServiceListingCopyWith<$Res> {
  _$ServiceListingCopyWithImpl(this._self, this._then);

  final ServiceListing _self;
  final $Res Function(ServiceListing) _then;

/// Create a copy of ServiceListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? service = null,Object? access = freezed,}) {
  return _then(_self.copyWith(
service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as AgentService,access: freezed == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as ServiceAccess?,
  ));
}
/// Create a copy of ServiceListing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentServiceCopyWith<$Res> get service {
  
  return $AgentServiceCopyWith<$Res>(_self.service, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of ServiceListing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceAccessCopyWith<$Res>? get access {
    if (_self.access == null) {
    return null;
  }

  return $ServiceAccessCopyWith<$Res>(_self.access!, (value) {
    return _then(_self.copyWith(access: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServiceListing].
extension ServiceListingPatterns on ServiceListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceListing value)  $default,){
final _that = this;
switch (_that) {
case _ServiceListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceListing value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AgentService service,  ServiceAccess? access)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceListing() when $default != null:
return $default(_that.service,_that.access);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AgentService service,  ServiceAccess? access)  $default,) {final _that = this;
switch (_that) {
case _ServiceListing():
return $default(_that.service,_that.access);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AgentService service,  ServiceAccess? access)?  $default,) {final _that = this;
switch (_that) {
case _ServiceListing() when $default != null:
return $default(_that.service,_that.access);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceListing extends ServiceListing {
  const _ServiceListing({required this.service, this.access}): super._();
  

@override final  AgentService service;
@override final  ServiceAccess? access;

/// Create a copy of ServiceListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceListingCopyWith<_ServiceListing> get copyWith => __$ServiceListingCopyWithImpl<_ServiceListing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceListing&&(identical(other.service, service) || other.service == service)&&(identical(other.access, access) || other.access == access));
}


@override
int get hashCode => Object.hash(runtimeType,service,access);

@override
String toString() {
  return 'ServiceListing(service: $service, access: $access)';
}


}

/// @nodoc
abstract mixin class _$ServiceListingCopyWith<$Res> implements $ServiceListingCopyWith<$Res> {
  factory _$ServiceListingCopyWith(_ServiceListing value, $Res Function(_ServiceListing) _then) = __$ServiceListingCopyWithImpl;
@override @useResult
$Res call({
 AgentService service, ServiceAccess? access
});


@override $AgentServiceCopyWith<$Res> get service;@override $ServiceAccessCopyWith<$Res>? get access;

}
/// @nodoc
class __$ServiceListingCopyWithImpl<$Res>
    implements _$ServiceListingCopyWith<$Res> {
  __$ServiceListingCopyWithImpl(this._self, this._then);

  final _ServiceListing _self;
  final $Res Function(_ServiceListing) _then;

/// Create a copy of ServiceListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? service = null,Object? access = freezed,}) {
  return _then(_ServiceListing(
service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as AgentService,access: freezed == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as ServiceAccess?,
  ));
}

/// Create a copy of ServiceListing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentServiceCopyWith<$Res> get service {
  
  return $AgentServiceCopyWith<$Res>(_self.service, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of ServiceListing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceAccessCopyWith<$Res>? get access {
    if (_self.access == null) {
    return null;
  }

  return $ServiceAccessCopyWith<$Res>(_self.access!, (value) {
    return _then(_self.copyWith(access: value));
  });
}
}

/// @nodoc
mixin _$ServiceUsage {

 int get used; int? get limit; DateTime? get trialEndsAt;
/// Create a copy of ServiceUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceUsageCopyWith<ServiceUsage> get copyWith => _$ServiceUsageCopyWithImpl<ServiceUsage>(this as ServiceUsage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceUsage&&(identical(other.used, used) || other.used == used)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.trialEndsAt, trialEndsAt) || other.trialEndsAt == trialEndsAt));
}


@override
int get hashCode => Object.hash(runtimeType,used,limit,trialEndsAt);

@override
String toString() {
  return 'ServiceUsage(used: $used, limit: $limit, trialEndsAt: $trialEndsAt)';
}


}

/// @nodoc
abstract mixin class $ServiceUsageCopyWith<$Res>  {
  factory $ServiceUsageCopyWith(ServiceUsage value, $Res Function(ServiceUsage) _then) = _$ServiceUsageCopyWithImpl;
@useResult
$Res call({
 int used, int? limit, DateTime? trialEndsAt
});




}
/// @nodoc
class _$ServiceUsageCopyWithImpl<$Res>
    implements $ServiceUsageCopyWith<$Res> {
  _$ServiceUsageCopyWithImpl(this._self, this._then);

  final ServiceUsage _self;
  final $Res Function(ServiceUsage) _then;

/// Create a copy of ServiceUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? used = null,Object? limit = freezed,Object? trialEndsAt = freezed,}) {
  return _then(_self.copyWith(
used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,trialEndsAt: freezed == trialEndsAt ? _self.trialEndsAt : trialEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceUsage].
extension ServiceUsagePatterns on ServiceUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceUsage value)  $default,){
final _that = this;
switch (_that) {
case _ServiceUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceUsage value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int used,  int? limit,  DateTime? trialEndsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceUsage() when $default != null:
return $default(_that.used,_that.limit,_that.trialEndsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int used,  int? limit,  DateTime? trialEndsAt)  $default,) {final _that = this;
switch (_that) {
case _ServiceUsage():
return $default(_that.used,_that.limit,_that.trialEndsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int used,  int? limit,  DateTime? trialEndsAt)?  $default,) {final _that = this;
switch (_that) {
case _ServiceUsage() when $default != null:
return $default(_that.used,_that.limit,_that.trialEndsAt);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceUsage implements ServiceUsage {
  const _ServiceUsage({required this.used, this.limit, this.trialEndsAt});
  

@override final  int used;
@override final  int? limit;
@override final  DateTime? trialEndsAt;

/// Create a copy of ServiceUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceUsageCopyWith<_ServiceUsage> get copyWith => __$ServiceUsageCopyWithImpl<_ServiceUsage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceUsage&&(identical(other.used, used) || other.used == used)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.trialEndsAt, trialEndsAt) || other.trialEndsAt == trialEndsAt));
}


@override
int get hashCode => Object.hash(runtimeType,used,limit,trialEndsAt);

@override
String toString() {
  return 'ServiceUsage(used: $used, limit: $limit, trialEndsAt: $trialEndsAt)';
}


}

/// @nodoc
abstract mixin class _$ServiceUsageCopyWith<$Res> implements $ServiceUsageCopyWith<$Res> {
  factory _$ServiceUsageCopyWith(_ServiceUsage value, $Res Function(_ServiceUsage) _then) = __$ServiceUsageCopyWithImpl;
@override @useResult
$Res call({
 int used, int? limit, DateTime? trialEndsAt
});




}
/// @nodoc
class __$ServiceUsageCopyWithImpl<$Res>
    implements _$ServiceUsageCopyWith<$Res> {
  __$ServiceUsageCopyWithImpl(this._self, this._then);

  final _ServiceUsage _self;
  final $Res Function(_ServiceUsage) _then;

/// Create a copy of ServiceUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? used = null,Object? limit = freezed,Object? trialEndsAt = freezed,}) {
  return _then(_ServiceUsage(
used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,trialEndsAt: freezed == trialEndsAt ? _self.trialEndsAt : trialEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$GatewayMeta {

 String get requestId; ServiceUsage? get usage; Duration? get pollAfter; String? get version;
/// Create a copy of GatewayMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GatewayMetaCopyWith<GatewayMeta> get copyWith => _$GatewayMetaCopyWithImpl<GatewayMeta>(this as GatewayMeta, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GatewayMeta&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.pollAfter, pollAfter) || other.pollAfter == pollAfter)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,usage,pollAfter,version);

@override
String toString() {
  return 'GatewayMeta(requestId: $requestId, usage: $usage, pollAfter: $pollAfter, version: $version)';
}


}

/// @nodoc
abstract mixin class $GatewayMetaCopyWith<$Res>  {
  factory $GatewayMetaCopyWith(GatewayMeta value, $Res Function(GatewayMeta) _then) = _$GatewayMetaCopyWithImpl;
@useResult
$Res call({
 String requestId, ServiceUsage? usage, Duration? pollAfter, String? version
});


$ServiceUsageCopyWith<$Res>? get usage;

}
/// @nodoc
class _$GatewayMetaCopyWithImpl<$Res>
    implements $GatewayMetaCopyWith<$Res> {
  _$GatewayMetaCopyWithImpl(this._self, this._then);

  final GatewayMeta _self;
  final $Res Function(GatewayMeta) _then;

/// Create a copy of GatewayMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? usage = freezed,Object? pollAfter = freezed,Object? version = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as ServiceUsage?,pollAfter: freezed == pollAfter ? _self.pollAfter : pollAfter // ignore: cast_nullable_to_non_nullable
as Duration?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of GatewayMeta
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceUsageCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $ServiceUsageCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}


/// Adds pattern-matching-related methods to [GatewayMeta].
extension GatewayMetaPatterns on GatewayMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GatewayMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GatewayMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GatewayMeta value)  $default,){
final _that = this;
switch (_that) {
case _GatewayMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GatewayMeta value)?  $default,){
final _that = this;
switch (_that) {
case _GatewayMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  ServiceUsage? usage,  Duration? pollAfter,  String? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GatewayMeta() when $default != null:
return $default(_that.requestId,_that.usage,_that.pollAfter,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  ServiceUsage? usage,  Duration? pollAfter,  String? version)  $default,) {final _that = this;
switch (_that) {
case _GatewayMeta():
return $default(_that.requestId,_that.usage,_that.pollAfter,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  ServiceUsage? usage,  Duration? pollAfter,  String? version)?  $default,) {final _that = this;
switch (_that) {
case _GatewayMeta() when $default != null:
return $default(_that.requestId,_that.usage,_that.pollAfter,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _GatewayMeta implements GatewayMeta {
  const _GatewayMeta({required this.requestId, this.usage, this.pollAfter, this.version});
  

@override final  String requestId;
@override final  ServiceUsage? usage;
@override final  Duration? pollAfter;
@override final  String? version;

/// Create a copy of GatewayMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GatewayMetaCopyWith<_GatewayMeta> get copyWith => __$GatewayMetaCopyWithImpl<_GatewayMeta>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GatewayMeta&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.pollAfter, pollAfter) || other.pollAfter == pollAfter)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,usage,pollAfter,version);

@override
String toString() {
  return 'GatewayMeta(requestId: $requestId, usage: $usage, pollAfter: $pollAfter, version: $version)';
}


}

/// @nodoc
abstract mixin class _$GatewayMetaCopyWith<$Res> implements $GatewayMetaCopyWith<$Res> {
  factory _$GatewayMetaCopyWith(_GatewayMeta value, $Res Function(_GatewayMeta) _then) = __$GatewayMetaCopyWithImpl;
@override @useResult
$Res call({
 String requestId, ServiceUsage? usage, Duration? pollAfter, String? version
});


@override $ServiceUsageCopyWith<$Res>? get usage;

}
/// @nodoc
class __$GatewayMetaCopyWithImpl<$Res>
    implements _$GatewayMetaCopyWith<$Res> {
  __$GatewayMetaCopyWithImpl(this._self, this._then);

  final _GatewayMeta _self;
  final $Res Function(_GatewayMeta) _then;

/// Create a copy of GatewayMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? usage = freezed,Object? pollAfter = freezed,Object? version = freezed,}) {
  return _then(_GatewayMeta(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as ServiceUsage?,pollAfter: freezed == pollAfter ? _self.pollAfter : pollAfter // ignore: cast_nullable_to_non_nullable
as Duration?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of GatewayMeta
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceUsageCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $ServiceUsageCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}

/// @nodoc
mixin _$GatewayResponse {

 Object? get result; GatewayMeta get meta; bool get accepted;
/// Create a copy of GatewayResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GatewayResponseCopyWith<GatewayResponse> get copyWith => _$GatewayResponseCopyWithImpl<GatewayResponse>(this as GatewayResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GatewayResponse&&const DeepCollectionEquality().equals(other.result, result)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.accepted, accepted) || other.accepted == accepted));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(result),meta,accepted);

@override
String toString() {
  return 'GatewayResponse(result: $result, meta: $meta, accepted: $accepted)';
}


}

/// @nodoc
abstract mixin class $GatewayResponseCopyWith<$Res>  {
  factory $GatewayResponseCopyWith(GatewayResponse value, $Res Function(GatewayResponse) _then) = _$GatewayResponseCopyWithImpl;
@useResult
$Res call({
 Object? result, GatewayMeta meta, bool accepted
});


$GatewayMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$GatewayResponseCopyWithImpl<$Res>
    implements $GatewayResponseCopyWith<$Res> {
  _$GatewayResponseCopyWithImpl(this._self, this._then);

  final GatewayResponse _self;
  final $Res Function(GatewayResponse) _then;

/// Create a copy of GatewayResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = freezed,Object? meta = null,Object? accepted = null,}) {
  return _then(_self.copyWith(
result: freezed == result ? _self.result : result ,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as GatewayMeta,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of GatewayResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GatewayMetaCopyWith<$Res> get meta {
  
  return $GatewayMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [GatewayResponse].
extension GatewayResponsePatterns on GatewayResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GatewayResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GatewayResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GatewayResponse value)  $default,){
final _that = this;
switch (_that) {
case _GatewayResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GatewayResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GatewayResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Object? result,  GatewayMeta meta,  bool accepted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GatewayResponse() when $default != null:
return $default(_that.result,_that.meta,_that.accepted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Object? result,  GatewayMeta meta,  bool accepted)  $default,) {final _that = this;
switch (_that) {
case _GatewayResponse():
return $default(_that.result,_that.meta,_that.accepted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Object? result,  GatewayMeta meta,  bool accepted)?  $default,) {final _that = this;
switch (_that) {
case _GatewayResponse() when $default != null:
return $default(_that.result,_that.meta,_that.accepted);case _:
  return null;

}
}

}

/// @nodoc


class _GatewayResponse implements GatewayResponse {
  const _GatewayResponse({required this.result, required this.meta, this.accepted = false});
  

@override final  Object? result;
@override final  GatewayMeta meta;
@override@JsonKey() final  bool accepted;

/// Create a copy of GatewayResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GatewayResponseCopyWith<_GatewayResponse> get copyWith => __$GatewayResponseCopyWithImpl<_GatewayResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GatewayResponse&&const DeepCollectionEquality().equals(other.result, result)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.accepted, accepted) || other.accepted == accepted));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(result),meta,accepted);

@override
String toString() {
  return 'GatewayResponse(result: $result, meta: $meta, accepted: $accepted)';
}


}

/// @nodoc
abstract mixin class _$GatewayResponseCopyWith<$Res> implements $GatewayResponseCopyWith<$Res> {
  factory _$GatewayResponseCopyWith(_GatewayResponse value, $Res Function(_GatewayResponse) _then) = __$GatewayResponseCopyWithImpl;
@override @useResult
$Res call({
 Object? result, GatewayMeta meta, bool accepted
});


@override $GatewayMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$GatewayResponseCopyWithImpl<$Res>
    implements _$GatewayResponseCopyWith<$Res> {
  __$GatewayResponseCopyWithImpl(this._self, this._then);

  final _GatewayResponse _self;
  final $Res Function(_GatewayResponse) _then;

/// Create a copy of GatewayResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = freezed,Object? meta = null,Object? accepted = null,}) {
  return _then(_GatewayResponse(
result: freezed == result ? _self.result : result ,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as GatewayMeta,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of GatewayResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GatewayMetaCopyWith<$Res> get meta {
  
  return $GatewayMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
