import 'dart:io';

import 'package:taro/common/advertising/ad_inventories.dart';
import 'package:taro/common/advertising/model/adinventory.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdRewardResult {
  final AdRewardEvent event;
  final dynamic error;
  final RewardItem? reward;

  AdRewardResult(this.event, {this.error, this.reward});

  // 편의 메서드 추가
  int get code => event.code;
  bool get isSuccess => event == AdRewardEvent.success;
  bool get isError =>
      event == AdRewardEvent.loadFailed ||
      event == AdRewardEvent.showFailed ||
      event == AdRewardEvent.typeError;
}

enum AdRewardEvent {
  success(0), // 보상 완료
  loaded(1000),
  showed(1001),

  typeError(2000), // 잘못된 광고 타입
  loadFailed(2001),
  showFailed(2002),
  userCanceled(2003); // 사용자 취소 (광고는 봤지만 보상 안받음)

  const AdRewardEvent(this.code);
  final int code;
}

class AdRewardService {
  static final _instance = AdRewardService._internal();

  factory AdRewardService() => _instance;

  AdRewardService._internal();

  RewardedAd? _rewardedAd;
  bool _isLoaded = false;
  bool _rewardEarned = false;
  RewardItem? _earnedReward;

  Future<void> loadAd(
    String type, {
    Function(AdRewardResult)? onAdEvent,
  }) async {
    String adUnitId = AdInventories.lottoRewardVideo.getAdUnitId();
    switch (type) {
      case 'ATTENDANCEX3':
        adUnitId = AdInventories.lottoAttendanceRewardVideo.getAdUnitId();
        break;
      default:
        AppLogger.i('Invalid rewarded ad type: $type, use default ad UnitId');
        break;
    }

    // RewardedAd 테스트 ID
    if (kDebugMode) {
      adUnitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          AppLogger.i('Rewarded ad loaded');
          _rewardedAd = ad;
          _isLoaded = true;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (Ad ad) {
              AppLogger.i('Ad showed full screen content');
              _rewardEarned = false;
              _earnedReward = null;
            },
            onAdDismissedFullScreenContent: (Ad ad) {
              AppLogger.i('Ad dismissed');
              ad.dispose();
              _rewardedAd = null;
              _isLoaded = false;

              if (_rewardEarned && _earnedReward != null) {
                // 보상을 받았을 때 바로 호출하자
                // onAdEvent?.call(
                //   AdRewardResult(AdRewardEvent.success, reward: _earnedReward),
                // );
              } else {
                // 광고를 끝까지 안 본 경우 or 보상 조건 미충족
                onAdEvent?.call(AdRewardResult(AdRewardEvent.userCanceled));
              }
            },
            onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
              AppLogger.i('Failed to show ad: $error');
              ad.dispose();
              _rewardedAd = null;
              _isLoaded = false;
              onAdEvent?.call(
                AdRewardResult(AdRewardEvent.showFailed, error: error),
              );
            },
          );
          showAd(type, onAdEvent: onAdEvent);
        },
        onAdFailedToLoad: (LoadAdError error) {
          AppLogger.i('Failed to load rewarded ad: $error');
          _isLoaded = false;
          onAdEvent?.call(
            AdRewardResult(AdRewardEvent.loadFailed, error: error),
          );
        },
      ),
    );
  }

  void showAd(String type, {Function(AdRewardResult)? onAdEvent}) {
    if (_isLoaded && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          AppLogger.i('User earned reward: ${reward.amount} ${reward.type}');
          _rewardEarned = true;
          _earnedReward = reward;
          onAdEvent?.call(
            AdRewardResult(AdRewardEvent.success, reward: _earnedReward),
          );
        },
      );
    } else {
      AppLogger.i('Rewarded ad not ready, reloading...');
      loadAd(type, onAdEvent: onAdEvent);
    }
  }

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoaded = false;
  }
}
