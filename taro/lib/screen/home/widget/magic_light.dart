// 배경 마법 광원 효과를 그리는 CustomPainter
import 'dart:math' as math;

import 'package:flutter/material.dart';

class MagicLightPainter extends CustomPainter {
  final double animationX;
  final double animationY;
  final double screenWidth;
  final double screenHeight;

  MagicLightPainter({
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
  bool shouldRepaint(MagicLightPainter oldDelegate) {
    return oldDelegate.animationX != animationX ||
        oldDelegate.animationY != animationY;
  }
}
