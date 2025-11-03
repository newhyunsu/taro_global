// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResponseData _$ResponseDataFromJson(Map<String, dynamic> json) =>
    _ResponseData(
      message: json['message'] as String,
      data: ResponseDetail.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseDataToJson(_ResponseData instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

_ResponseDetail _$ResponseDetailFromJson(Map<String, dynamic> json) =>
    _ResponseDetail(
      id: (json['id'] as num).toInt(),
      key: json['key'] as String,
      value: json['value'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ResponseDetailToJson(_ResponseDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
    };
