import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taro/common/util/const.dart';

class TarotCard extends StatelessWidget {
  const TarotCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kSecondaryColor, // 골드 색상
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 카드 패턴 (데코레이션)
          CustomPaint(
            size: const Size(100, 160),
            painter: TarotCardPainter(),
          ),
          // 카드 내용 (플레이스홀더)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: kSecondaryColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: kSecondaryColor.withOpacity(0.7),
                    size: 20,
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

class TarotCards extends StatelessWidget {
  const TarotCards({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 1) {
      // 단일 카드
      return const Center(child: TarotCard());
    } else {
      // 여러 카드
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) => Padding(
            padding: EdgeInsets.only(right: index < count - 1 ? 12 : 0),
            child: const TarotCard(),
          ),
        ),
      );
    }
  }
}

// 타로 카드 데코레이션을 그리는 CustomPainter
class TarotCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kSecondaryColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 상단 장식
    final topPath = Path();
    topPath.moveTo(size.width * 0.2, size.height * 0.1);
    topPath.lineTo(size.width * 0.8, size.height * 0.1);
    canvas.drawPath(topPath, paint);

    // 중앙 원형 장식
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.15,
      paint,
    );

    // 하단 장식
    final bottomPath = Path();
    bottomPath.moveTo(size.width * 0.2, size.height * 0.9);
    bottomPath.lineTo(size.width * 0.8, size.height * 0.9);
    canvas.drawPath(bottomPath, paint);

    // 모서리 장식 (별 모양)
    final starPaint = Paint()
      ..color = kSecondaryColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    _drawStar(
      canvas,
      Offset(size.width * 0.2, size.height * 0.2),
      4,
      starPaint,
    );
    _drawStar(
      canvas,
      Offset(size.width * 0.8, size.height * 0.2),
      4,
      starPaint,
    );
    _drawStar(
      canvas,
      Offset(size.width * 0.2, size.height * 0.8),
      4,
      starPaint,
    );
    _drawStar(
      canvas,
      Offset(size.width * 0.8, size.height * 0.8),
      4,
      starPaint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi) / 5 - math.pi / 2;
      final isOuter = i.isEven;
      final r = isOuter ? radius : radius * 0.5;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TarotCardPainter oldDelegate) => false;
}

