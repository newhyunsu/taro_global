import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_data.freezed.dart';
part 'response_data.g.dart';

@freezed
abstract class ResponseData with _$ResponseData {
  factory ResponseData({
    required String message,
    required ResponseDetail data,
  }) = _ResponseData;

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);
}

@freezed
abstract class ResponseDetail with _$ResponseDetail {
  factory ResponseDetail({
    required int id,
    required String key,
    required String value,
    required String type,
  }) = _ResponseDetail;

  factory ResponseDetail.fromJson(Map<String, dynamic> json) =>
      _$ResponseDetailFromJson(json);
}
