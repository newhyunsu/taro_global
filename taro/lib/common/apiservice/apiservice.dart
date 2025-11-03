import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:taro/common/apiservice/models/response_data.dart';
import 'package:taro/common/util/app_storage.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:taro/common/util/const.dart';
import 'package:dio/dio.dart';
import 'package:dio_brotli_transformer/dio_brotli_transformer.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;
  String _appVersion = '';
  String _buildNumber = '';
  String _deviceId = '';
  bool _isInitialized = false;
  final Completer<void> _initCompleter = Completer<void>();

  ApiService._internal() {
    _dio = Dio()..transformer = DioBrotliTransformer();
    _initialize();
  }

  // 비동기 초기화 메서드
  Future<void> _initialize() async {
    try {
      // 1. PackageInfo 가져오기
      final appInfo = await PackageInfo.fromPlatform();
      _appVersion = appInfo.version;
      _buildNumber = appInfo.buildNumber;

      // 2. DeviceId 가져오기
      _deviceId = await AppStorage().getOrCreateDeviceId();

      // 3. 모든 정보가 준비된 후 Dio 설정
      _setupDio();

      _isInitialized = true;
      _initCompleter.complete();

      AppLogger.i(
        'ApiService 초기화 완료 - Version: $_appVersion, Build: $_buildNumber, DeviceId: $_deviceId',
      );
    } catch (error) {
      AppLogger.e('ApiService 초기화 실패: $error');
      // 실패해도 기본값으로 설정
      _setupDio();
      _isInitialized = true;
      _initCompleter.complete();
    }
  }

  void _setupDio() {
    _dio.options.baseUrl = kBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = _getHeaders();

    // 인터셉터 추가 (선택사항)
    _dio.interceptors.clear(); // 기존 인터셉터 제거
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        logPrint: (obj) => AppLogger.i(obj.toString()),
      ),
    );
  }

  void _updateHeaders() {
    if (_isInitialized) {
      _dio.options.headers = _getHeaders();
    }
  }

  // 초기화 완료를 기다리는 메서드
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initCompleter.future;
    }
  }

  factory ApiService() {
    return _instance;
  }

  final String secret = 'cheeto12!@';

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'Cache-control': 'no-cache',
      'Authorization': 'Bearer my-secret-key-qwer1234',
      'device': Platform.isAndroid ? 'android' : 'ios',
      'appVersion': _appVersion,
      'buildNumber': _buildNumber,
      'device_id': _deviceId, // 디바이스 ID 추가
    };
  }

  Future<T> requestGet<T>(
    String url,
    T Function(dynamic) fromJson, { // Map<String, dynamic> → dynamic으로 변경
    bool bShowMessage = false,
  }) async {
    // 초기화 완료 대기
    await _ensureInitialized();

    try {
      AppLogger.i('GET Url:$url');

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        dynamic jsonData;

        // 응답 데이터 타입에 따라 처리
        if (response.data is String) {
          jsonData = json.decode(response.data);
        } else {
          jsonData = response.data;
        }

        AppLogger.i('GET Url:$url, response: $jsonData');
        return fromJson(jsonData);
      } else {
        throw Exception(
          "서버 오류: ${response.statusCode}\nBody: ${response.data}",
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("요청 시간 초과");
      }
      throw Exception("네트워크 오류: ${e.message}");
    } catch (e) {
      throw Exception("네트워크 오류: $e");
    }
  }

  Future<T> requestPost<T>(
    String url,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson, // Map<String, dynamic> → dynamic으로 변경
  ) async {
    // 초기화 완료 대기
    await _ensureInitialized();

    try {
      AppLogger.i('POST Url:$url, body: $body');
      AppLogger.i('Headers: ${_dio.options.headers}');

      // Options로 명시적으로 헤더 설정
      final response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppLogger.i('POST: $url response: ${response.statusCode}');
      AppLogger.i('POST: $url response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic jsonData;

        // 응답 데이터 타입에 따라 처리
        if (response.data is String) {
          if (response.data.isEmpty) {
            jsonData = {};
          } else {
            try {
              jsonData = json.decode(response.data);
            } catch (e) {
              AppLogger.e('JSON 파싱 실패: ${response.data}');
              // 빈 응답이거나 파싱 실패 시 기본값 반환
              jsonData = {'message': 'success', 'data': {}};
            }
          }
        } else {
          jsonData = response.data;
        }

        AppLogger.i('POST Url:$url, parsed response: $jsonData');
        return fromJson(jsonData);
      } else {
        throw Exception(
          "서버 오류: ${response.statusCode}\nBody: ${response.data}",
        );
      }
    } on DioException catch (e) {
      AppLogger.e('DioException 상세:');
      AppLogger.e('- Type: ${e.type}');
      AppLogger.e('- Message: ${e.message}');
      AppLogger.e('- Response status: ${e.response?.statusCode}');
      AppLogger.e('- Response data: ${e.response?.data}');
      AppLogger.e('- Response headers: ${e.response?.headers}');
      AppLogger.e('- Request path: ${e.requestOptions.path}');
      AppLogger.e('- Request data: ${e.requestOptions.data}');
      AppLogger.e('- Request headers: ${e.requestOptions.headers}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("요청 시간 초과");
      } else if (e.type == DioExceptionType.badResponse) {
        rethrow;
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception("연결 오류: 네트워크를 확인해주세요");
      }
      throw Exception("네트워크 오류: ${e.message}");
    } catch (e) {
      AppLogger.e('일반 예외: $e');
      throw Exception("네트워크 오류: $e");
    }
  }

  final String baseUrl = kBaseUrl;
  Future<ResponseData> registerPushToken(
    String deviceId,
    String fcmToken,
  ) async {
    String type = '';
    if (Platform.isAndroid) {
      type = 'android';
    } else if (Platform.isIOS) {
      type = 'ios';
    } else {
      type = 'unknown';
    }

    AppLogger.i(
      "Registering push token for deviceId: $deviceId, fcmToken: $fcmToken, type: $type",
    );

    // baseUrl이 이미 Dio에 설정되어 있으므로 상대 경로만 사용
    return requestPost<ResponseData>('/app/1003', {
      'secret': secret,
      'data': {'key': deviceId, 'value': fcmToken, 'type': type},
    }, (json) => ResponseData.fromJson(json));
  }
}
