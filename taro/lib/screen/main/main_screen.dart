import 'package:taro/common/advertising/ad_inventories.dart';
import 'package:taro/common/advertising/google_admob_banner.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:taro/common/webview/webview_widget.dart';
import 'package:taro/router/go_router.dart';
import 'package:taro/screen/main/components/main_bottom_navigation_bar.dart';
import 'package:taro/screen/main/providers/main_tab_provider.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainTabbarWidget extends ConsumerStatefulWidget {
  const MainTabbarWidget({super.key});

  @override
  ConsumerState<MainTabbarWidget> createState() => _MainTabbarWidgetState();
}

class _MainTabbarWidgetState extends ConsumerState<MainTabbarWidget>
    with WidgetsBindingObserver, RouteAware {
  // GlobalKey를 클래스 변수로 선언
  final GlobalKey<BaseWebviewState> _webviewKey = GlobalKey<BaseWebviewState>();

  // BannerAdWidget의 GlobalKey 추가
  final GlobalKey<BannerAdWidgetState> _bannerKey =
      GlobalKey<BannerAdWidgetState>();

  late final List<Widget> _screens = <Widget>[
    BaseWebview(
      key: _webviewKey, // 여기서 키 사용
      initialUrl: "https://naver.com",
      isRootView: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 앱 시작 시 알림 배지 제거
    _appBadgeRemove();

    FirebaseMessaging.instance
        .requestPermission()
        .then((settings) {
          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            AppLogger.i("✅ Firebase Messaging permission granted");
          } else {
            AppLogger.i("❌ Firebase Messaging permission denied");
          }
        })
        .catchError((error) {
          AppLogger.e(
            "❌ Error requesting Firebase Messaging permission: $error",
          );
        });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 활성화될 때 배지 제거
      _appBadgeRemove();
      // Key 변경 대신 직접 리로드
      _bannerKey.currentState?.reloadAd();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    // Key 변경 대신 직접 리로드
    _bannerKey.currentState?.reloadAd();
  }

  void _appBadgeRemove() {
    AppBadgePlus.isSupported()
        .then((isSupported) {
          if (isSupported) {
            AppBadgePlus.updateBadge(0);
          } else {
            AppLogger.w("AppBadgePlus is not supported on this device.");
          }
        })
        .catchError((error) {
          AppLogger.e("Error removing app badge: $error");
        });
  }

  void _onItemTapped(int index) {
    ref.read(selectedIndexProvider.notifier).state = index;
    // 탭 변경 시에는 리로드하지 않음
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    ref.listen<int>(selectedIndexProvider, (previous, next) {
      if (previous != next) {
        HapticFeedback.lightImpact();
      }
      if (next == 0) {
        // GlobalKey를 통해 상태에 접근
        _webviewKey.currentState?.sendActiveEvent();
      }
      switch (next) {
        case 0:
          _webviewKey.currentState?.sendActiveEvent();
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          ...List.generate(
            _screens.length,
            (i) => Offstage(
              offstage: selectedIndex != i,
              child: Padding(
                // padding: const EdgeInsets.only(bottom: 50), // 배너 광고 높이만큼 패딩
                padding: EdgeInsets.zero,
                child: Center(child: _screens[i]),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: BannerAdWidget(
          //     key: _bannerKey, // ValueKey 대신 GlobalKey 사용
          //     inventory: AdInventories.mainBanner,
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: MainBottomNavigationBar(onItemTapped: _onItemTapped),
    );
  }
}
