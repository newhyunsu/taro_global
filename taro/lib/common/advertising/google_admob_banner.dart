import 'dart:io';

import 'package:taro/common/advertising/model/adinventory.dart';
import 'package:taro/common/util/app_storage.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:taro/common/util/const.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key, required this.inventory});
  final AdInventory inventory;

  @override
  State<BannerAdWidget> createState() => BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _showPointLabel = false; // 50P 라벨 표시 여부

  // 하루 횟수 제한은 현재 2회
  final maxDailyClicks = 2;

  late String adUnitId;
  final AppStorage _storage = AppStorage();

  @override
  void initState() {
    super.initState();
    adUnitId = widget.inventory.getAdUnitId();
    _checkDailyPointLimit(); // 일일 포인트 제한 확인
    _storage.getAdvertisementStatus().then((value) {
      if (value) {
        _loadAd();
      }
    });
  }

  // 하루 3번 제한 및 시간 간격 확인
  Future<void> _checkDailyPointLimit() async {
    final storageKey = '${widget.inventory.inventoryName}_count';
    final lastClickKey = '${widget.inventory.inventoryName}_last_click';
    final today = DateTime.now().toString().substring(0, 10); // YYYY-MM-DD 형식
    final now = DateTime.now();

    final storedData = await _storage.get(storageKey);
    final lastClickData = await _storage.get(lastClickKey);

    // 일일 클릭 횟수 확인
    int todayCount = 0;
    final parts = storedData.split('|');
    if (parts.length == 2) {
      final storedDate = parts[0];
      final storedCount = int.tryParse(parts[1]) ?? 0;
      todayCount = (storedDate == today) ? storedCount : 0;
    }

    // 시간 간격 확인
    bool canShowLabel = true;
    if (lastClickData.isNotEmpty && todayCount > 0) {
      try {
        final lastClickTime = DateTime.parse(lastClickData);
        final hoursSinceLastClick = now.difference(lastClickTime).inHours;
        canShowLabel = hoursSinceLastClick >= 1; // 1시간 간격
      } catch (e) {
        AppLogger.d('Error parsing last click time: $e');
      }
    }

    setState(() {
      _showPointLabel = todayCount < maxDailyClicks && canShowLabel;
    });
  }

  void _loadAd() {
    if (kDebugMode) {
      // 테스트용 광고 ID
      adUnitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/9214589741'
          : 'ca-app-pub-3940256099942544/2435281174';
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          AppLogger.d('BannerAd failed to load: $error');
          ad.dispose();
        },
        onAdClicked: (ad) {
          AppLogger.d('Banner ad clicked');
          // 50P 라벨이 표시될 때만 포인트 지급
          if (_showPointLabel) {
            _handleAdClick();
          }
        },
        onAdImpression: (ad) {
          AppLogger.d('Banner ad impression recorded');
          // 광고 노출 이벤트 처리
        },
        onAdOpened: (ad) {
          AppLogger.d('Banner ad opened');
          // 광고가 전체 화면으로 열렸을 때
        },
        onAdClosed: (ad) {
          AppLogger.d('Banner ad closed');
          // 광고가 닫혔을 때
        },
      ),
    );

    _bannerAd?.load();
  }

  // 광고 새로고침 메서드 추가
  void reloadAd() {
    AppLogger.d('Reloading banner ad...');

    // 기존 광고 dispose
    _bannerAd?.dispose();
    _bannerAd = null;

    // 로딩 상태로 변경
    if (mounted) {
      setState(() {
        _isAdLoaded = false;
      });
    }

    // 새 광고 로드
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? Container(
            height: _bannerAd!.size.height.toDouble(),
            width: double.infinity, // 전체 너비 사용
            color: kPrimaryColor, // 배경색 설정
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: _bannerAd!.size.height.toDouble(),
                    width: _bannerAd!.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                  // 하루 3번 제한 내에서만 50P 라벨 표시
                ),
                if (_showPointLabel)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Text(
                        '50P',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> _handleAdClick() async {
    final today = DateTime.now().toString().substring(0, 10); // YYYY-MM-DD 형식

    final storageKey = '${widget.inventory.inventoryName}_count';
    final lastClickKey = '${widget.inventory.inventoryName}_last_click';
    final storedData = await _storage.get(storageKey);
    int todayCount = 0;

    final parts = storedData.split('|');
    if (parts.length == 2) {
      final storedDate = parts[0];
      final storedCount = int.tryParse(parts[1]) ?? 0;

      // 같은 날이면 저장된 카운트 사용, 다른 날이면 0으로 초기화
      todayCount = (storedDate == today) ? storedCount : 0;
    }

    if (todayCount < maxDailyClicks) {
      // 포인트 지급
      // final response = await ApiService().requestAddPoint('ADS_CLICK');
      // if (!response.success) {
      //   AppLogger.e(
      //     'Failed to award points for ad click: ${response.description}',
      //   );
      //   return;
      // } else {
      //   // mounted 체크를 await 직후에 수행
      //   if (mounted) {
      //     showToast(context: context, message: response.description);
      //   }
      // }

      // 오늘 카운트 증가
      todayCount++;

      // 새로운 데이터 저장 (날짜|카운트 형식)
      await _storage.set(storageKey, '$today|$todayCount');

      // 3번째 클릭이면 라벨 숨기기
      if (todayCount >= maxDailyClicks) {
        setState(() {
          _showPointLabel = false;
        });
      }

      // 마지막 클릭 시간 업데이트
      await _storage.set(lastClickKey, DateTime.now().toString());

      AppLogger.d('Ad point awarded. Today count: ${todayCount + 1}/3');
    }
  }
}
