import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taro/screen/home/widget/magic_light.dart';
import 'package:taro/screen/home/widget/spread_select_screen.dart';

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
      backgroundColor: const Color(0xFF1A0B2E), // 다크 퍼플 배경
      body: SafeArea(
        child: Stack(
          children: [
            // 배경 마법 광원 효과 레이어
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // 헤더: 로고 + 앱 이름
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'MysticArcade',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 메인 질문
                    const Text(
                      "What's on your mind today?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Pull of the Day 큰 카드
                    _buildPullOfTheDayCard(context),
                    const SizedBox(height: 24),
                    // 카테고리 그리드
                    _buildCategoryGrid(context),
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

  Widget _buildPullOfTheDayCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E), // 약간 밝은 다크 퍼플
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // 이미지 영역 (상단)
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF0D4A3A), // 다크 틸/그린 (별이 있는 배경)
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 별 배경 효과
                CustomPaint(size: Size.infinite, painter: _StarFieldPainter()),
                // 타로 카드를 든 손 이미지 (플레이스홀더)
                Container(
                  width: 140,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37), // 골드
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFD700), // 밝은 골드
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wb_sunny,
                          color: Color(0xFFFFD700),
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'CARD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const Text(
                        'ARCANUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 텍스트 및 버튼 영역 (하단)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pull of the Day',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Draw your daily card for guidance and insight.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Draw ...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {
        'icon': Icons.wb_sunny_outlined,
        'title': "Today's Fortune",
        'description': "What will today bring?",
      },
      {
        'icon': Icons.favorite_outline,
        'title': 'Love',
        'description': 'Is romance in the cards?',
      },
      {
        'icon': Icons.attach_money_outlined,
        'title': 'Money',
        'description': 'Cha-ching or cha-sad?',
      },
      {
        'icon': Icons.people_outline,
        'title': 'Relationships',
        'description': 'Friends, family, frenemies?',
      },
      {
        'icon': Icons.help_outline,
        'title': 'Self-discovery',
        'description': 'Who am I, really?',
      },
      {
        'icon': Icons.school_outlined,
        'title': 'Exams/Career',
        'description': 'Study hard or hardly studying?',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          icon: category['icon'] as IconData,
          title: category['title'] as String,
          description: category['description'] as String,
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SpreadSelectScreen(categoryTitle: title),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B4E), // 다크 퍼플
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 별 배경 효과를 그리는 CustomPainter
class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // 고정된 시드로 일관된 별 배치
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter oldDelegate) => false;
}
