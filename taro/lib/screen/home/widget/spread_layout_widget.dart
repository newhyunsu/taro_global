import 'package:flutter/material.dart';

class SpreadLayoutWidget extends StatelessWidget {
  const SpreadLayoutWidget({
    super.key,
    required this.layoutType,
  });

  final SpreadLayoutType layoutType;

  @override
  Widget build(BuildContext context) {
    switch (layoutType) {
      case SpreadLayoutType.threeCard:
        return _buildThreeCardLayout();
      case SpreadLayoutType.relationship:
        return _buildRelationshipLayout();
      case SpreadLayoutType.celticCross:
        return _buildCelticCrossLayout();
    }
  }

  Widget _buildThreeCardLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCardOutline(),
        const SizedBox(width: 12),
        _buildCardOutline(),
        const SizedBox(width: 12),
        _buildCardOutline(),
      ],
    );
  }

  Widget _buildRelationshipLayout() {
    return SizedBox(
      width: 220,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 중앙 가로 2개 카드 (약간 겹침)
          Positioned(
            left: 50,
            top: 35,
            child: Transform.rotate(
              angle: -0.08,
              child: _buildCardOutline(),
            ),
          ),
          Positioned(
            right: 50,
            top: 35,
            child: Transform.rotate(
              angle: 0.08,
              child: _buildCardOutline(),
            ),
          ),
          // 위쪽 카드 (왼쪽 중앙 카드 위)
          Positioned(
            left: 50,
            top: 5,
            child: Transform.rotate(
              angle: -0.08,
              child: _buildCardOutline(),
            ),
          ),
          // 아래쪽 카드 (오른쪽 중앙 카드 아래)
          Positioned(
            right: 50,
            bottom: 5,
            child: Transform.rotate(
              angle: 0.08,
              child: _buildCardOutline(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelticCrossLayout() {
    return SizedBox(
      width: 300,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 십자 형태 (5개 카드)
          // 중앙 카드
          Positioned(
            left: 100,
            top: 25,
            child: _buildCardOutline(),
          ),
          // 위쪽 카드
          Positioned(
            left: 100,
            top: 0,
            child: _buildCardOutline(),
          ),
          // 아래쪽 카드
          Positioned(
            left: 100,
            bottom: 0,
            child: _buildCardOutline(),
          ),
          // 왼쪽 카드 (가로로 누워있음)
          Positioned(
            left: 70,
            top: 25,
            child: Transform.rotate(
              angle: -1.57, // 90도 회전 (세로 -> 가로)
              child: _buildCardOutline(),
            ),
          ),
          // 오른쪽 카드 (가로로 누워있음)
          Positioned(
            left: 130,
            top: 25,
            child: Transform.rotate(
              angle: -1.57, // 90도 회전 (세로 -> 가로)
              child: _buildCardOutline(),
            ),
          ),
          // 오른쪽 세로 스태프 (2개 카드, 약간 겹침)
          Positioned(
            right: 25,
            top: 15,
            child: Transform.rotate(
              angle: 0.05,
              child: _buildCardOutline(),
            ),
          ),
          Positioned(
            right: 25,
            bottom: 15,
            child: Transform.rotate(
              angle: -0.05,
              child: _buildCardOutline(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardOutline() {
    return Container(
      width: 50,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 2,
        ),
      ),
    );
  }
}

enum SpreadLayoutType {
  threeCard,
  relationship,
  celticCross,
}

