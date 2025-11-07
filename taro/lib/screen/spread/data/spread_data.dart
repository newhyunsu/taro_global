import 'package:taro/screen/spread/models/spread_item.dart';

final List<SpreadItem> spreadItems = [
  SpreadItem(
    title: '썸남/썸녀 속마음 훔쳐보기',
    description: '그 사람... 날 좋아할까? 답답한 마음을 한 장의 카드로 뻥 뚫어봐요!',
    buttonText: '훔쳐보기',
    cardCount: 1,
    onTap: () {},
  ),
  SpreadItem(
    title: '내 통장 잔고 눈 감아...',
    description: '이번 달 월급은 어디로? 텅장이 될 운명인지, 떡상할 운명인지!',
    buttonText: '잔고 확인',
    cardCount: 3,
    onTap: () {},
  ),
  SpreadItem(
    title: '이직? 존버? 인생은 실전',
    description: '퇴사할까, 버틸까... 복잡하고 어려운 고민, 속 시원하게 해결해 드립니다.',
    buttonText: '인생 상담',
    cardCount: 1,
    // imageAsset: 'assets/images/spread_life_counsel.png',
    onTap: () {},
  ),
  SpreadItem(
    title: '오늘의 운세: 대박 or 쪽박',
    description: '로또를 살까 말까? 오늘 하루 운수대통할지 미리 확인해보세요!',
    buttonText: '운세 보기',
    cardCount: 2,
    // imageAsset: 'assets/images/spread_daily_fortune.png',
    onTap: () {},
  ),
];

