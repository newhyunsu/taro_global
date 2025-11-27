part of 'app_storage.dart'; // AppStorage 클래스를 import

enum AppStorageKey {
  accessToken('accessToken'),
  refreshToken('refreshToken'),
  communityFilter('communityFilter'),
  deviceId('device_id'),
  //광고 on/off 관리
  advertisementStatus('advertisementStatus'),
  userGuide('userGuide'),
  shareLinkUrl('shareLinkUrl'),
  fhReadPost('fh_read_post'),
  searchText('searchText'),
  swipeDirection('swipe_direction'),
  useFilter('use_filter'),
  siteSelector('siteSelector'),
  hasReviewed('hasReviewed'),
  languagePreference('languagePreference'),

  //자동로그인
  idToken('id_token'),
  oauthProvider('oauthProvider');

  final String rawValue;
  const AppStorageKey(this.rawValue);
}

extension AppStorageExtension on AppStorage {
  Future<void> setAdvertisementStatus(bool status) {
    return setBool(AppStorageKey.advertisementStatus.rawValue, status);
  }

  //true: 광고 노출, false: 광고 비노출
  //광고 노출 여부
  Future<bool> getAdvertisementStatus() async {
    final value = await getBool(AppStorageKey.advertisementStatus.rawValue);
    return value;
  }

  Future<String> getOrCreateDeviceId() async {
    _deviceIdFuture ??= _loadOrCreateDeviceId();
    // final deviceId = await _deviceIdFuture!;
    // AppLogger.i("🔑 Device ID requested: $deviceId");
    return _deviceIdFuture!;
  }

  Future<String> _loadOrCreateDeviceId() async {
    final deviceId = await get(AppStorageKey.deviceId.rawValue, secure: true);

    if (deviceId.isEmpty) {
      final newId = const Uuid().v4();
      await set(AppStorageKey.deviceId.rawValue, newId, secure: true);
      AppLogger.i("✅ Device ID created: $newId");
      return newId;
    } else {
      AppLogger.i("🔄 Device ID exists: $deviceId");
      return deviceId;
    }
  }

  Future<bool> getHasReviewed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppStorageKey.hasReviewed.rawValue) ?? false;
  }

  Future<void> setHasReviewed(bool hasReviewed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStorageKey.hasReviewed.rawValue, hasReviewed);
  }
}
