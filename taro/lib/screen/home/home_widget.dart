import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taro/common/util/const.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late AnimationController _magicLightController;
  late Animation<double> _magicAnimationX;
  late Animation<double> _magicAnimationY;

  @override
  void initState() {
    super.initState();

    // 마법 광원 애니메이션 (불규칙한 경로로 이동)
    _magicLightController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // X축은 느리게, Y축은 빠르게 (서로 다른 주기와 커브)
    _magicAnimationX = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _magicLightController, curve: Curves.easeInOut),
    );

    // Y축은 다른 속도와 커브로 움직임
    _magicAnimationY = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _magicLightController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _magicLightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            // 배경 마법 광원 효과 레이어
            AnimatedBuilder(
              animation: _magicLightController,
              builder: (context, child) {
                return CustomPaint(
                  size: screenSize,
                  painter: _MagicLightPainter(
                    animationX: _magicAnimationX.value,
                    animationY: _magicAnimationY.value,
                    screenWidth: screenSize.width,
                    screenHeight: screenSize.height,
                  ),
                );
              },
            ),
            // 메인 컨텐츠
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // 앱 아이콘
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B46C1), // 다크 퍼플
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 20,
                            top: 25,
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 25,
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 앱 제목
                    const Text(
                      '운세? 어차피 될놈만 된다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 환영 메시지
                    const Text(
                      '그래도 너가 될놈인지 아닌지 모르니까?',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    // 오늘의 운세
                    const Text(
                      '한번 보고 가라',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    // 메인 네비게이션 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavButton(
                          icon: Icons.style_outlined,
                          label: '타로 보기',
                          onTap: () {
                            // 타로 보기 기능
                          },
                        ),
                        _buildNavButton(
                          icon: Icons.menu_book_outlined,
                          label: '나의 타로',
                          onTap: () {
                            // 나의 타로 기능
                          },
                        ),
                        _buildNavButton(
                          icon: Icons.settings_outlined,
                          label: '설정',
                          onTap: () {
                            // 설정 기능
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    // 최근 본 타로 섹션
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '최근 본 타로',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 최근 타로 카드
                    _buildRecentTarotCard(
                      title: '연애운 스프레드',
                      description: '새로운 만남의 가능성이 열려있습니다.',
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTarotCard({
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          // 썸네일
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white.withOpacity(0.5),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          // 제목과 설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 배경 마법 광원 효과를 그리는 CustomPainter
class _MagicLightPainter extends CustomPainter {
  final double animationX;
  final double animationY;
  final double screenWidth;
  final double screenHeight;

  _MagicLightPainter({
    required this.animationX,
    required this.animationY,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 화면 경계 내에서 움직이도록 계산
    // 여러 주기와 진폭을 조합하여 불규칙한 경로 생성

    // X 위치: 여러 주기 파형을 조합
    final x1 = math.sin(animationX * 2 * math.pi);
    final x2 = math.cos(animationX * 3.5 * math.pi);
    final x3 = math.sin(animationX * 1.7 * math.pi);
    final lightX =
        screenWidth * 0.3 +
        (screenWidth * 0.4) * (0.4 * x1 + 0.3 * x2 + 0.3 * x3 + 1.0) / 2.0;

    // Y 위치: 다른 주기와 진폭으로 움직임
    final y1 = math.cos(animationY * 2.3 * math.pi);
    final y2 = math.sin(animationY * 1.8 * math.pi);
    final y3 = math.cos(animationY * 3.2 * math.pi);
    final lightY =
        screenHeight * 0.2 +
        (screenHeight * 0.6) * (0.35 * y1 + 0.35 * y2 + 0.3 * y3 + 1.0) / 2.0;

    // 화면 경계 체크
    final clampedX = lightX.clamp(100.0, screenWidth - 100.0);
    final clampedY = lightY.clamp(100.0, screenHeight - 100.0);

    // 마법 광원 그리기
    _drawMagicLight(canvas, Offset(clampedX, clampedY), 280.0);
  }

  void _drawMagicLight(Canvas canvas, Offset center, double radius) {
    // 마법적인 보라색 계열 그라데이션
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0x506B46C1), // 보라색 (중앙, 더 진하게)
          const Color(0x305938B0), // 더 진한 보라색
          const Color(0x20409ED8), // 파란색 계열
          Colors.transparent,
        ],
        stops: const [0.0, 0.25, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.plus;

    canvas.drawCircle(center, radius, paint);

    // 내부 코어 효과 (더 밝은 부분)
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0x408B7FD6), // 밝은 보라색
          const Color(0x206B46C1), // 보라색
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.5))
      ..blendMode = BlendMode.plus;

    canvas.drawCircle(center, radius * 0.5, corePaint);
  }

  @override
  bool shouldRepaint(_MagicLightPainter oldDelegate) {
    return oldDelegate.animationX != animationX ||
        oldDelegate.animationY != animationY;
  }
}
