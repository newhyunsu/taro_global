import 'package:flutter/material.dart';
import 'package:taro/common/util/const.dart';
import 'package:taro/screen/spread/components/spread_card.dart';
import 'package:taro/screen/spread/data/spread_data.dart';

class SpreadScreen extends StatelessWidget {
  const SpreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF6B46C1), // 보라색
              const Color(0xFF4C1D95), // 진한 보라색
              kPrimaryColor, // 다크 네이비
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 AppBar
              _buildAppBar(context),
              // 메인 컨텐츠
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // 메인 타이틀
                      const Text(
                        '어떤 미래를 훔쳐볼까요?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // 스프레드 카드들
                      ...spreadItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SpreadCard(item: item),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 제목
          const Text(
            '스프레드를 선택하세요',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
