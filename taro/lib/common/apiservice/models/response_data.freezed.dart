// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResponseData {

 String get message; ResponseDetail get data;
/// Create a copy of ResponseData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResponseDataCopyWith<ResponseData> get copyWith => _$ResponseDataCopyWithImpl<ResponseData>(this as ResponseData, _$identity);

  /// Serializes this ResponseData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResponseData&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,data);

@override
String toString() {
  return 'ResponseData(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $ResponseDataCopyWith<$Res>  {
  factory $ResponseDataCopyWith(ResponseData value, $Res Function(ResponseData) _then) = _$ResponseDataCopyWithImpl;
@useResult
$Res call({
 String message, ResponseDetail data
});


$ResponseDetailCopyWith<$Res> get data;

}
/// @nodoc
class _$ResponseDataCopyWithImpl<$Res>
    implements $ResponseDataCopyWith<$Res> {
  _$ResponseDataCopyWithImpl(this._self, this._then);

  final ResponseData _self;
  final $Res Function(ResponseData) _then;

/// Create a copy of ResponseData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ResponseDetail,
  ));
}
/// Create a copy of ResponseData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResponseDetailCopyWith<$Res> get data {
  
  return $ResponseDetailCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ResponseData].
extension ResponseDataPatterns on ResponseData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResponseData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResponseData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResponseData value)  $default,){
final _that = this;
switch (_that) {
case _ResponseData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResponseData value)?  $default,){
final _that = this;
switch (_that) {
case _ResponseData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  ResponseDetail data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResponseData() when $default != null:
return $default(_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  ResponseDetail data)  $default,) {final _that = this;
switch (_that) {
case _ResponseData():
return $default(_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  ResponseDetail data)?  $default,) {final _that = this;
switch (_that) {
case _ResponseData() when $default != null:
return $default(_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResponseData implements ResponseData {
   _ResponseData({required this.message, required this.data});
  factory _ResponseData.fromJson(Map<String, dynamic> json) => _$ResponseDataFromJson(json);

@override final  String message;
@override final  ResponseDetail data;

/// Create a copy of ResponseData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResponseDataCopyWith<_ResponseData> get copyWith => __$ResponseDataCopyWithImpl<_ResponseData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResponseDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResponseData&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,data);

@override
String toString() {
  return 'ResponseData(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ResponseDataCopyWith<$Res> implements $ResponseDataCopyWith<$Res> {
  factory _$ResponseDataCopyWith(_ResponseData value, $Res Function(_ResponseData) _then) = __$ResponseDataCopyWithImpl;
@override @useResult
$Res call({
 String message, ResponseDetail data
});


@override $ResponseDetailCopyWith<$Res> get data;

}
/// @nodoc
class __$ResponseDataCopyWithImpl<$Res>
    implements _$ResponseDataCopyWith<$Res> {
  __$ResponseDataCopyWithImpl(this._self, this._then);

  final _ResponseData _self;
  final $Res Function(_ResponseData) _then;

/// Create a copy of ResponseData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? data = null,}) {
  return _then(_ResponseData(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ResponseDetail,
  ));
}

/// Create a copy of ResponseData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResponseDetailCopyWith<$Res> get data {
  
  return $ResponseDetailCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ResponseDetail {

 int get id; String get key; String get value; String get type;
/// Create a copy of ResponseDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResponseDetailCopyWith<ResponseDetail> get copyWith => _$ResponseDetailCopyWithImpl<ResponseDetail>(this as ResponseDetail, _$identity);

  /// Serializes this ResponseDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResponseDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,value,type);

@override
String toString() {
  return 'ResponseDetail(id: $id, key: $key, value: $value, type: $type)';
}


}

/// @nodoc
abstract mixin class $ResponseDetailCopyWith<$Res>  {
  factory $ResponseDetailCopyWith(ResponseDetail value, $Res Function(ResponseDetail) _then) = _$ResponseDetailCopyWithImpl;
@useResult
$Res call({
 int id, String key, String value, String type
});




}
/// @nodoc
class _$ResponseDetailCopyWithImpl<$Res>
    implements $ResponseDetailCopyWith<$Res> {
  _$ResponseDetailCopyWithImpl(this._self, this._then);

  final ResponseDetail _self;
  final $Res Function(ResponseDetail) _then;

/// Create a copy of ResponseDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? value = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResponseDetail].
extension ResponseDetailPatterns on ResponseDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResponseDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResponseDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResponseDetail value)  $default,){
final _that = this;
switch (_that) {
case _ResponseDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResponseDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ResponseDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String key,  String value,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResponseDetail() when $default != null:
return $default(_that.id,_that.key,_that.value,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String key,  String value,  String type)  $default,) {final _that = this;
switch (_that) {
case _ResponseDetail():
return $default(_that.id,_that.key,_that.value,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String key,  String value,  String type)?  $default,) {final _that = this;
switch (_that) {
case _ResponseDetail() when $default != null:
return $default(_that.id,_that.key,_that.value,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResponseDetail implements ResponseDetail {
   _ResponseDetail({required this.id, required this.key, required this.value, required this.type});
  factory _ResponseDetail.fromJson(Map<String, dynamic> json) => _$ResponseDetailFromJson(json);

@override final  int id;
@override final  String key;
@override final  String value;
@override final  String type;

/// Create a copy of ResponseDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResponseDetailCopyWith<_ResponseDetail> get copyWith => __$ResponseDetailCopyWithImpl<_ResponseDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResponseDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResponseDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,value,type);

@override
String toString() {
  return 'ResponseDetail(id: $id, key: $key, value: $value, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ResponseDetailCopyWith<$Res> implements $ResponseDetailCopyWith<$Res> {
  factory _$ResponseDetailCopyWith(_ResponseDetail value, $Res Function(_ResponseDetail) _then) = __$ResponseDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String key, String value, String type
});




}
/// @nodoc
class __$ResponseDetailCopyWithImpl<$Res>
    implements _$ResponseDetailCopyWith<$Res> {
  __$ResponseDetailCopyWithImpl(this._self, this._then);

  final _ResponseDetail _self;
  final $Res Function(_ResponseDetail) _then;

/// Create a copy of ResponseDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? value = null,Object? type = null,}) {
  return _then(_ResponseDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
