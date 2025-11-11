import 'package:flutter/material.dart';
import 'package:taro/screen/home/widget/spread_layout_widget.dart';

class SpreadSelectScreen extends StatelessWidget {
  const SpreadSelectScreen({super.key, required this.categoryTitle});

  final String categoryTitle;

  // 카테고리별 스프레드 목록
  static Map<String, List<SpreadOption>> getSpreadOptionsByCategory() {
    return {
      "Today's Fortune": [
        SpreadOption(
          title: 'Three-Card Spread',
          description: 'A quick and clear reading for a specific question.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Daily Guidance',
          description: 'Get insights for your day ahead.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Celtic Cross',
          description:
              'A deep and comprehensive reading for complex situations.',
          layoutType: SpreadLayoutType.celticCross,
        ),
      ],
      'Love': [
        SpreadOption(
          title: 'Three-Card Spread',
          description: 'A quick and clear reading for a specific question.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Relationship Spread',
          description: 'Explore the dynamics and future of your connection.',
          layoutType: SpreadLayoutType.relationship,
        ),
        SpreadOption(
          title: 'Celtic Cross',
          description:
              'A deep and comprehensive reading for complex situations.',
          layoutType: SpreadLayoutType.celticCross,
        ),
      ],
      'Money': [
        SpreadOption(
          title: 'Three-Card Spread',
          description: 'A quick and clear reading for a specific question.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Financial Guidance',
          description: 'Understand your financial future and opportunities.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Celtic Cross',
          description:
              'A deep and comprehensive reading for complex situations.',
          layoutType: SpreadLayoutType.celticCross,
        ),
      ],
      'Relationships': [
        SpreadOption(
          title: 'Three-Card Spread',
          description: 'A quick and clear reading for a specific question.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Relationship Spread',
          description: 'Explore the dynamics and future of your connection.',
          layoutType: SpreadLayoutType.relationship,
        ),
        SpreadOption(
          title: 'Celtic Cross',
          description:
              'A deep and comprehensive reading for complex situations.',
          layoutType: SpreadLayoutType.celticCross,
        ),
      ],
      'Self-discovery': [
        SpreadOption(
          title: 'Three-Card Spread',
          description: 'A quick and clear reading for a specific question.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Celtic Cross',
          description:
              'A deep and comprehensive reading for complex situations.',
          layoutType: SpreadLayoutType.celticCross,
        ),
      ],
      'Exams/Career': [
        SpreadOption(
          title: 'Three-Card Spread',
          description: 'A quick and clear reading for a specific question.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Career Path',
          description: 'Discover your professional journey and opportunities.',
          layoutType: SpreadLayoutType.threeCard,
        ),
        SpreadOption(
          title: 'Celtic Cross',
          description:
              'A deep and comprehensive reading for complex situations.',
          layoutType: SpreadLayoutType.celticCross,
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final spreadOptions =
        getSpreadOptionsByCategory()[categoryTitle] ??
        getSpreadOptionsByCategory()['Love']!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628), // 다크 블루 배경
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A0B2E), // 다크 퍼플
              const Color(0xFF0A1628), // 다크 블루
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 헤더
              _buildHeader(context),
              // 메인 컨텐츠
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // 메인 타이틀
                      const Text(
                        'Choose a Spread',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // 스프레드 옵션들
                      ...spreadOptions.map(
                        (option) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildSpreadOptionCard(context, option),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 뒤로가기 버튼
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          // 카테고리 제목
          Expanded(
            child: Text(
              '$categoryTitle Readings',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // 뒤로가기 버튼과 대칭을 위한 공간
        ],
      ),
    );
  }

  Widget _buildSpreadOptionCard(BuildContext context, SpreadOption option) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3A).withOpacity(0.6), // 약간 밝은 다크 블루
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카드 레이아웃 시각화
          SizedBox(
            height: 120,
            child: Center(
              child: SpreadLayoutWidget(layoutType: option.layoutType),
            ),
          ),
          const SizedBox(height: 20),
          // 제목
          Text(
            option.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // 설명
          Text(
            option.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          // Choose 버튼
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // 스프레드 선택 처리
                // TODO: 실제 스프레드 화면으로 이동
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD93D), // 노란색
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Choose',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpreadOption {
  const SpreadOption({
    required this.title,
    required this.description,
    required this.layoutType,
  });

  final String title;
  final String description;
  final SpreadLayoutType layoutType;
}
