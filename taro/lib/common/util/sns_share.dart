import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SnsShare {
  static String _shareBaseUrl = 'https://mikeparker-81.github.io/lotto';
  static String? _appName;

  static Future<void> init() async {
    // 비동기적으로 값을 가져오기 위해 초기화 함수 호출
    await _initAppName();
  }

  static Future<void> _initAppName() async {
    if (_appName == null) {
      final packageInfo = await PackageInfo.fromPlatform();
      _appName = packageInfo.appName;
    }
  }

  static Future<String> getAppName() async {
    if (_appName == null) {
      await _initAppName();
    }
    return _appName ?? '로터리.AI'; // 기본값으로 '로터리.AI' 사용
  }

  static Future<void> shareUri(
    String referralId,
    String description,
    String? destUrl,
  ) async {
    if (_shareBaseUrl.isEmpty) {
      await init();
    }
    _shareBaseUrl = destUrl ?? _shareBaseUrl;
    final appName = await getAppName();

    if (Platform.isIOS) {
      // iOS에서는 ShareParams를 사용하여 공유
      // subject 전달이 안됨.
      SharePlus.instance.share(
        ShareParams(
          subject: '$description ($appName)',
          text:
              '$description ($appName)\n 추천인ID: $referralId 를 입력하면 500P를 받을수 있어요 \n- $_shareBaseUrl?id=$referralId',
        ),
      );
    } else {
      // Android에서는 ShareParams를 사용하여 공유
      // subject는 정상적으로 전달 잘됨.
      final uri = Uri.parse('$_shareBaseUrl?id=$referralId');
      SharePlus.instance.share(
        ShareParams(
          subject:
              '$description ($appName)\n 추천인ID: $referralId 를 입력하면 500P를 받을수 있어요',
          uri: uri,
        ),
      );
    }
    //
  }
}
