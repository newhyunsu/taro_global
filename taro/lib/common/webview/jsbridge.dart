import 'dart:convert';
import 'dart:io';
import 'package:taro/common/advertising/google_admob_interstitial.dart';
import 'package:taro/common/advertising/google_admob_reward.dart';
import 'package:taro/common/apiservice/apiservice.dart';
import 'package:taro/common/util/app_storage.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:taro/common/util/common_popup_widget.dart';
import 'package:taro/common/util/sns_share.dart';
import 'package:taro/main.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// ✅ JS 콜백 처리를 위한 별도 클래스
class Jsbridge {
  final WebViewController _controller;
  final BuildContext context;

  Jsbridge(this.context, this._controller);
  final trigerEventString =
      "typeof triggerEvent !== 'undefined' && triggerEvent({'event':'active'});";

  final apiService = ApiService();

  /// 📌 JS에서 요청을 받았을 때 처리
  void handleJSMessage(String message) {
    AppLogger.i("Received from Web: $message");

    try {
      final Map<String, dynamic> data = jsonDecode(message);

      if (data.containsKey("function")) {
        String functionName = data["function"];
        Map<String, dynamic> params = data["params"] ?? {};
        final resultCallback = data["resultCallback"] as String?;
        _executeFunction(functionName, params, resultCallback);
      }
    } catch (e) {
      AppLogger.i("Invalid JSON format: $message");
    }
  }

  /// 📌 함수명으로 분기 실행
  void _executeFunction(
    String functionName,
    Map<String, dynamic> params,
    String? resultCallback,
  ) {
    final storage = AppStorage();
    final functionMap = {
      "close": _closeWebView,
      "show": () {
        _openShorts(params["index"]);
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, "success");
        }
      },
      "setMwData": () async {
        final isSuccess = await storage.set(params["key"], params["value"]);
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, isSuccess ? "success" : "fail");
        }
      },
      "getMwData": () async {
        final value = await storage.get(params["key"]);
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, value);
        }
      },
      "openNewWebview": () {
        _openNewWebView(params["url"]);
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, "success");
        }
      },
      "showIntersitialAd": () async {
        showInterstitialAdWithCallback(resultCallback);
      },
      // window.gary.postMessage(JSON.stringify({"function":"showRewardAd", 'params': {'type':'VIDEO'}, 'resultCallback': "(function(result){ console.log(JSON.stringify(result)); })" }));
      "showRewardAd": () async {
        showRewardAdWithCallback(params["type"], resultCallback);
      },
      "shortVibration": () {
        shortVibration();
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, 'success');
        }
      },
      "getDeviceInfo": () async {
        final reponse = await getDeviceInfo();
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, reponse);
        }
      },
      "showUpdateDialog": () async {
        final serverVersion = params["serverVersion"] as String;
        final forceUpdate = params["forceUpdate"] as bool;
        await checkForUpdate(serverVersion, forceUpdate);
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, "success");
        }
      },
      "launchUrl": () async {
        final url = params["url"] as String?;
        if (url != null && await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          if (resultCallback != null) {
            _executeJSCallback(resultCallback, "success");
          }
        } else {
          AppLogger.i("Invalid URL: $url");
          if (resultCallback != null) {
            _executeJSCallback(resultCallback, "fail");
          }
        }
      },
      "setAdStatus": () async {
        final bShow = params["bShow"] as bool?;
        await storage.setAdvertisementStatus(bShow ?? true);

        if (resultCallback != null) {
          _executeJSCallback(resultCallback, "success");
        }
      },
      "showQrScanner": () {
        //window.gary.postMessage(JSON.stringify({"function":"showQrScanner", 'resultCallback': "(function(result){ console.log(JSON.stringify(result)); })" }));
        context.push("/showQrScanner");
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, "success");
        }
      },
      "snsShare": () {
        //window.gary.postMessage(JSON.stringify({"function":"snsShare","id":"aaaa", 'desc':'description', 'destUrl':'https://example.com', 'resultCallback': "(function(result){ console.log(JSON.stringify(result)); })" }));
        final id = params["id"] as String;
        final desc = params["desc"] as String;
        final destUrl = params["destUrl"] as String;
        SnsShare.shareUri(id, desc, destUrl);
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, "success");
        }
      },
    };

    if (functionMap.containsKey(functionName)) {
      functionMap[functionName]!();
    } else {
      AppLogger.i("Unknown function: $functionName");
    }
  }

  /// ✅ JS 콜백 실행
  void _executeJSCallback(String callbackFunction, dynamic response) {
    final encodedResponse = jsonEncode(response); // 안전하게 JSON 변환
    final jsCode = '$callbackFunction($encodedResponse);';
    AppLogger.i("Executing JS: $jsCode");
    _controller.runJavaScript(jsCode);
  }

  void _openNewWebView(String? url) async {
    if (url != null) {
      AppLogger.i("Opening WebView with URL: $url");
    } else {
      AppLogger.i("Invalid URL for new WebView");
      return;
    }
    context.push("/openNewWebview", extra: url);
  }

  void _openShorts(String? index) async {
    context.push("/post/$index");
  }

  void _closeWebView() {
    // Navigator.pop(context);
    context.pop();
    AppLogger.i("WebView closed");
  }

  void sendActiveEvent() {
    AppLogger.i("Sending active event to WebView");
    _controller.runJavaScript(trigerEventString);
  }

  void shortVibration() {
    HapticFeedback.lightImpact();
  }

  void showInterstitialAdWithCallback(String? resultCallback) {
    final adInterstitialService = AdInterstitialService();
    adInterstitialService.autoShow = true;
    adInterstitialService.showInterstitialAd(
      onAdEvent: (result) {
        String message = "";
        switch (result.event) {
          case AdInterstitialEvent.showed:
          case AdInterstitialEvent.dismissed:
            message = "success";
            break;
          case AdInterstitialEvent.loadFailed:
            AppLogger.i("Interstitial ad load failed: ${result.error}");
            message = "failure";
            break;
          case AdInterstitialEvent.showFailed:
            AppLogger.i("Interstitial ad show failed: ${result.error}");
            message = "failure";
            break;
          default:
            message = "failure";
            break;
        }
        final response = {
          "result": message,
          "error": {
            "code": result.error?.code,
            "message": result.error?.message,
          },
        };
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, response);
        }
      },
    );
  }

  void showRewardAdWithCallback(String? type, String? resultCallback) {
    if (type == null) {
      AppLogger.i("Invalid ad type: $type");
      if (resultCallback != null) {
        final response = {
          "result": AdRewardEvent.typeError.name,
          "error": {"code": -1, "message": "Invalid ad type"},
        };
        _executeJSCallback(resultCallback, response);
      }
      return;
    }

    AdRewardService().showAd(
      type,
      onAdEvent: (result) async {
        String message = "";
        switch (result.event) {
          case AdRewardEvent.success:
            // 🎉 보상 완료
            message = result.event.name;
            // final addPointResponse = await apiService.requestAddPoint(type);
            // if (addPointResponse.success) {
            //   if (context.mounted) {
            //     showToast(
            //       context: context,
            //       message: addPointResponse.description,
            //     );
            //   }
            // } else {
            //   AppLogger.i("Failed to add points");
            // }
            break;
          case AdRewardEvent.userCanceled:
            // 🙅 광고 보상 조건 미충족 or 취소
            message = result.event.name;
            break;
          case AdRewardEvent.loadFailed:
          case AdRewardEvent.showFailed:
            // ⚠️ 에러 처리

            break;
          default:
            break;
        }

        final response = <String, dynamic>{"result": message};

        if (result.error != null) {
          response["error"] = {
            "code": result.error?.code ?? -1,
            "message": result.error?.message ?? "Unknown error",
          };
        }
        if (resultCallback != null) {
          _executeJSCallback(resultCallback, response);
        }
      },
    );
  }

  Future<Map<String, Object>> getDeviceInfo() async {
    final os = Platform.isAndroid ? "Android" : "iOS";
    final deviceInfo = DeviceInfoPlugin();
    String osVersion = "unknown";
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      osVersion = androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      osVersion = iosInfo.systemVersion;
    }

    final appInfo = await PackageInfo.fromPlatform();
    final appVersion = appInfo.version;
    final buildNumber = appInfo.buildNumber;
    // await Permission.notification.status;
    final isNotifGranted = await Permission.notification.isGranted;
    final notificationYn = isNotifGranted ? "y" : "n";
    final deviceId = await AppStorage().getOrCreateDeviceId();

    AppLogger.i('Platform: $os');
    AppLogger.i('osVersion: $osVersion');
    AppLogger.i('App Version: $appVersion ($buildNumber)');
    AppLogger.i('Notification Permission: $notificationYn');

    // return iosInfo.systemVersion; // 예: "17.5.1"
    return {
      "Platform": os,
      "osVersion": osVersion,
      "App_Version": appVersion,
      "buildNumber": buildNumber,
      "notification": notificationYn,
      "deviceId": deviceId,
    };
  }

  // use
  // window.gary.postMessage(JSON.stringify({"function":"showUpdateDialog", 'params': {'serverVersion':'1.2.9', 'forceUpdate':false}, 'resultCallback': "(function(result){ console.log(JSON.stringify(result)); })" }));
  Future<void> checkForUpdate(String serverVersion, bool forceUpdate) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    if (_isVersionLower(currentVersion, serverVersion)) {
      final String storeUrl = Platform.isAndroid
          ? 'https://play.google.com/store/apps/details?id=com.exoplanets.funhub' // 여기에 실제 패키지명 입력
          : 'https://apps.apple.com/kr/app/%ED%8E%80%ED%97%88%EB%B8%8C/id6744699150'; // 여기에 실제 앱 ID 입력
      if (context.mounted) {
        _showUpdateDialog(context, storeUrl, forceUpdate);
      }
    }
  }

  /// 버전 비교: current < latest → true
  bool _isVersionLower(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (currentParts[i] < latestParts[i]) return true;
      if (currentParts[i] > latestParts[i]) return false;
    }
    return false;
  }

  void _showUpdateDialog(BuildContext context, String url, bool forceUpdate) {
    showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (context) => AlertDialog(
        title: const Text('업데이트 안내'),
        content: const Text('최신 버전으로 업데이트가 필요해요.'),
        actions: [
          if (!forceUpdate)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('나중에'),
            ),
          ElevatedButton(
            onPressed: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('업데이트'),
          ),
        ],
      ),
    );
  }
}
