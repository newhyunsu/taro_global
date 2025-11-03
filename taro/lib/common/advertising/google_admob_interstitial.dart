import 'dart:io';

import 'package:taro/common/advertising/ad_inventories.dart';
import 'package:taro/common/advertising/model/adinventory.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdInterstitialEvent { loaded, showed, dismissed, loadFailed, showFailed }

class AdInterstitialResult {
  final AdInterstitialEvent event;
  final dynamic error;

  AdInterstitialResult(this.event, {this.error});
}

class AdInterstitialService {
  static final _instance = AdInterstitialService._internal();

  factory AdInterstitialService() => _instance;

  AdInterstitialService._internal();

  bool autoShow = true;

  InterstitialAd? _interstitialAd;
  bool _isLoaded = false;

  // 광고 로드
  Future<void> loadInterstitialAd({
    Function(AdInterstitialResult)? onAdEvent,
  }) async {
    String adUnitId = AdInventories.interstitial.getAdUnitId();
    if (kDebugMode) {
      adUnitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          AppLogger.i('Interstitial ad loaded');
          _interstitialAd = ad;
          _isLoaded = true;

          // 광고 이벤트 설정
          _interstitialAd!
              .fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) {
              AppLogger.i('ad onAdShowedFullScreenContent');
              onAdEvent?.call(AdInterstitialResult(AdInterstitialEvent.showed));
            },
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              AppLogger.i('ad onAdDismissedFullScreenContent');
              ad.dispose();
              _interstitialAd = null;
              _isLoaded = false;
              onAdEvent?.call(
                AdInterstitialResult(AdInterstitialEvent.dismissed),
              );
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
                  AppLogger.i('ad onAdFailedToShowFullScreenContent: $error');
                  ad.dispose();
                  _interstitialAd = null;
                  _isLoaded = false;
                  onAdEvent?.call(
                    AdInterstitialResult(
                      AdInterstitialEvent.showFailed,
                      error: error,
                    ),
                  );
                },
          );
          if (autoShow) {
            showAd();
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          AppLogger.i('InterstitialAd failed to load: $error');
          _isLoaded = false;
          onAdEvent?.call(
            AdInterstitialResult(AdInterstitialEvent.loadFailed, error: error),
          );
        },
      ),
    );
  }

  // 광고 표시
  void showInterstitialAd({Function(AdInterstitialResult)? onAdEvent}) {
    if (_isLoaded && _interstitialAd != null) {
      showAd();
    } else {
      AppLogger.i('Interstitial ad is not ready yet');
      // 광고가 준비되지 않았으면 다시 로드
      loadInterstitialAd(onAdEvent: onAdEvent);
    }
  }

  void showAd() {
    if (_isLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  // 광고 해제
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoaded = false;
  }
}
