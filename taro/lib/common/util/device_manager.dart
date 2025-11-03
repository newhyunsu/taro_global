import 'dart:io';

import 'package:taro/common/apiservice/apiservice.dart';
import 'package:taro/common/apiservice/models/response_data.dart';
import 'package:taro/common/util/app_storage.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:in_app_review/in_app_review.dart';

class DeviceManager {
  static Future<ResponseData?> registerToServer() async {
    final deviceId = await AppStorage().getOrCreateDeviceId();
    // final fcmToken = await FirebaseMessaging.instance.getToken();

    // if (fcmToken == null) {
    //   AppLogger.i("❌ FCM token is null");
    //   // return null;
    // } else {
    //   AppLogger.i("✅ FCM token : $fcmToken");
    // }

    final fcmToken = "test_token";
    // 여기에 서버 API 주소 입력
    final response = await ApiService().registerPushToken(deviceId, fcmToken);

    AppLogger.i("📡 Server response: ${response.message}");
    return response;
  }

  static Future<void> requestReviewIfAppropriate() async {
    if (Platform.isAndroid && await AppStorage().getHasReviewed()) {
      AppLogger.i("🎯 리뷰 요청 이미 완료됨");
      return;
    }

    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      AppLogger.i("🎯 리뷰 요청 시도");
      await inAppReview.requestReview();
      AppStorage().setHasReviewed(true);
    } else {
      AppLogger.w("🚫 리뷰 요청 불가 (지원 안됨)");
    }
  }
}
