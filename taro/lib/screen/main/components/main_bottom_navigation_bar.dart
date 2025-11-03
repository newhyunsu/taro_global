import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:taro/common/util/const.dart';
import 'package:taro/screen/main/components/main_tab_button.dart';
import 'package:taro/screen/main/providers/main_tab_provider.dart';

class MainBottomNavigationBar extends ConsumerWidget {
  final Function(int) onItemTapped;

  const MainBottomNavigationBar({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          elevation: 0,
          padding: EdgeInsets.zero,
          height: 60,
          color: kPrimaryColor,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 홈 탭
                MainTabButton(
                  icon: HugeIcons.strokeRoundedHome01,
                  label: '홈',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTapped(0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                ),
                // 필요시 추가 탭들을 여기에 추가할 수 있습니다
                MainTabButton(
                  icon: HugeIcons.strokeRoundedCards01,
                  label: '스프레드',
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTapped(1),
                ),
                MainTabButton(
                  icon: HugeIcons.strokeRoundedTransactionHistory,
                  label: '히스토리',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemTapped(2),
                ),
                MainTabButton(
                  icon: HugeIcons.strokeRoundedUser,
                  label: '프로필',
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
