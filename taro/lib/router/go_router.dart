import 'package:taro/common/util/google_analytics_wrapper.dart';
import 'package:taro/common/webview/webview_widget.dart';
import 'package:taro/screen/home/home_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final GoRouter goRouter = GoRouter(
  observers: [routeObserver, GAnalitics.observer],
  navigatorKey: _navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        // return const MainTabbarWidget(); // 탭 또는 공통 레이아웃
        return const HomeWidget();
      },
    ),
    GoRoute(
      path: '/openNewWebview',
      pageBuilder: (context, state) {
        final url = state.extra as String;
        return CupertinoPage(
          key: state.pageKey,
          // edgeWidth: 200, // 화면 왼쪽에서 200픽셀까지 제스처 감지 영역
          child: BaseWebview(
            key: GlobalKey(),
            showAppBar: true,
            initialUrl: url,
            isRootView: false,
          ),
        );
      },
    ),
  ],
);
