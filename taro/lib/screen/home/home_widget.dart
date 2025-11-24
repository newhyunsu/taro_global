import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taro/screen/home/widget/magic_light.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late AnimationController _magicLightController;
  late Animation<double> _magicAnimationX;
  late Animation<double> _magicAnimationY;
  late AnimationController _cardAnimationController;
  late Animation<double> _cardGlowAnimation;

  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 마법 광원 애니메이션
    _magicLightController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _magicAnimationX = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _magicLightController, curve: Curves.easeInOut),
    );

    _magicAnimationY = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _magicLightController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    // 카드 글로우 애니메이션
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _cardGlowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _magicLightController.dispose();
    _cardAnimationController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D1B4E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Ask the Tarot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // 배경 마법 광원 효과
          AnimatedBuilder(
            animation: _magicLightController,
            builder: (context, child) {
              return CustomPaint(
                size: screenSize,
                painter: MagicLightPainter(
                  animationX: _magicAnimationX.value,
                  animationY: _magicAnimationY.value,
                  screenWidth: screenSize.width,
                  screenHeight: screenSize.height,
                ),
              );
            },
          ),
          // 메인 컨텐츠
          SafeArea(
            child: Column(
              children: [
                // 타로 카드 영역
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 타로 카드
                        // 안내 텍스트
                        const Text(
                          'Awaiting Your Question',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Focus on your question and let the cards guide you. Your answer awaits.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 하단 입력 영역
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D1B4E).withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 질문 입력 필드
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A0B2E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _questionController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type your question here...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Draw a Card 버튼
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: 카드 뽑기 로직
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: const Color(0xFF1A0B2E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Draw a Card',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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

// 별 배경 효과를 그리는 CustomPainter
class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 80; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter oldDelegate) => false;
}
