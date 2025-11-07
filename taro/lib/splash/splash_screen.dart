import 'package:taro/common/util/app_storage.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:taro/common/util/const.dart';
import 'package:taro/main.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final Widget? child;

  const SplashScreen({super.key, this.child});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showSplash = true;
  bool _isFadingOut = false;
  bool _showLottie = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _appSetting();
  }

  void _navigateToMain() {
    if (mounted) {
      setState(() {
        _isFadingOut = true;
      });
      Future.delayed(const Duration(milliseconds: 10), () {
        if (mounted) {
          setState(() {
            _showSplash = false;
          });
        }
      });
    }
  }

  //엡 전체의 광고 설정 제어
  void _appSetting() async {
    AppStorage().setAdvertisementStatus(true);
    requestATT();
    // fetchAndStoreAnalysisMethods();
    // fetchInitData();
  }

  Future<void> requestATT() async {
    // 현재 상태 확인
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    // 아직 동의 요청 안했으면 요청
    if (status == TrackingStatus.notDetermined) {
      final result =
          await AppTrackingTransparency.requestTrackingAuthorization();
      AppLogger.i("ATT 동의 상태: $result");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        if (_showSplash)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 210),
            opacity: _isFadingOut ? 0.0 : 1.0,
            child: Scaffold(
              backgroundColor: kPrimaryColor,
              body: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              child: SizedBox(
                                width: 250,
                                height: 250,
                                child: Text('Taro'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

        // 👉 Lottie 중앙에서 100px 아래로 200x200 사이즈로 표시
        if (_showLottie)
          Positioned.fill(
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, 100),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                    'assets/lottie/tarot_magic_ball.json',
                    fit: BoxFit.contain,
                    onLoaded: (composition) {
                      final duration = Duration(
                        milliseconds: (composition.duration.inMilliseconds / 3)
                            .round(),
                      );
                      Future.delayed(duration, () {
                        _navigateToMain();
                        setState(() {
                          _showLottie = false; // Lottie OFF
                        });
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        const SizedBox.shrink(),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
