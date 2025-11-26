import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taro/router/go_router.dart';
import 'package:taro/screen/home/widget/magic_light.dart';
import 'package:taro/screen/home/widget/tarot_menu_drawer.dart';
import 'package:taro/screen/home/widget/home_header_widget.dart';
import 'package:taro/screen/home/widget/question_input_widget.dart';
import 'package:taro/screen/home/widget/draw_card_button.dart';
import 'package:taro/i18n/strings.g.dart';
import 'package:taro/provider/animation_provider.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget>
    with TickerProviderStateMixin {
  late AnimationController _magicLightController;
  late Animation<double> _magicAnimationX;
  late Animation<double> _magicAnimationY;
  late AnimationController _cardAnimationController;
  late Animation<double> _cardGlowAnimation;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    // Provider에 애니메이션 값 업데이트
    _magicLightController.addListener(() {
      ref
          .read(animationProvider.notifier)
          .updateMagicAnimation(_magicAnimationX.value, _magicAnimationY.value);
    });

    _cardAnimationController.addListener(() {
      ref
          .read(animationProvider.notifier)
          .updateCardGlow(_cardGlowAnimation.value);
    });
  }

  @override
  void dispose() {
    _magicLightController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _openHistory() {
    goRouter.push('/history');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final t = Translations.of(context);
    final animationState = ref.watch(animationProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF1A0B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D1B4E),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        title: Text(
          t.home.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: _openHistory,
          ),
        ],
      ),
      drawer: const TarotMenuDrawer(),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // 오른쪽으로 스와이프 (왼쪽 메뉴 열기)
          if (details.primaryVelocity! > 0) {
            _scaffoldKey.currentState?.openDrawer();
          }
          // 왼쪽으로 스와이프 (히스토리 열기)
          else if (details.primaryVelocity! < 0) {
            _openHistory();
          }
        },
        child: Stack(
          children: [
            // 배경 마법 광원 효과
            CustomPaint(
              size: screenSize,
              painter: MagicLightPainter(
                animationX: animationState.magicAnimationX,
                animationY: animationState.magicAnimationY,
                screenWidth: screenSize.width,
                screenHeight: screenSize.height,
              ),
            ),
            // 메인 컨텐츠
            SafeArea(
              child: Column(
                children: [
                  // 타로 카드 영역
                  const Expanded(child: HomeHeaderWidget()),
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
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 질문 입력 필드
                        QuestionInputWidget(),
                        SizedBox(height: 16),
                        // Draw a Card 버튼
                        DrawCardButton(),
                      ],
                    ),
                  ),
                ],
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
