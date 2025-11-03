import 'dart:convert';

import 'package:taro/common/util/applogger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
part 'package:taro/common/util/app_storage_extension.dart';

class AppStorage {
  static final AppStorage _instance = AppStorage._internal();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  factory AppStorage() => _instance;

  AppStorage._internal();

  Future<String>? _deviceIdFuture;

  // 안전한 암호화 영역 사용을 위해 token, password 등을 위한 secure storage 기능 추가
  Future<bool> set(String key, String value, {bool secure = false}) async {
    if (secure) {
      await _secureStorage.write(key: key, value: value);
      return true;
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setString(key, value);
    }
  }

  Future<String> get(String key, {bool secure = false}) async {
    if (secure) {
      return await _secureStorage.read(key: key) ?? '';
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key) ?? '';
    }
  }

  Future<void> remove(String key, {bool secure = false}) async {
    if (secure) {
      await _secureStorage.delete(key: key);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    }
  }

  Future<void> clearAll({bool secure = false}) async {
    if (secure) {
      await _secureStorage.deleteAll();
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }

  Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true; // 기본값을 true로 설정
  }

  //set object
  Future<bool> setObject(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, jsonEncode(value));
  }

  //get object
  Future<Map<String, dynamic>> getObject(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return {};
  }

  // 앱이 새로 설치된 상태인지 확인하고, 최초 실행 시 secure storage 초기화
  static Future<void> checkIfFirstInstallAndClearSecureData() async {
    final storage = AppStorage();

    String hasLaunchedBefore = await storage.get('has_launched_before');
    if (hasLaunchedBefore.isEmpty) {
      hasLaunchedBefore = 'false';
    }

    if (hasLaunchedBefore != 'true') {
      // 🔥 앱이 새로 설치된 상태
      // await storage.clearAll(secure: true); // Keychain 초기화
      await storage.set(
        'has_launched_before',
        'true',
      ); // 최초 실행 기록 (SharedPreferences에 저장)
    }
  }
}
