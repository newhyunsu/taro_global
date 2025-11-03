import 'package:taro/common/advertising/model/adinventory.dart';

class AdInventories {
  // 리워드 광고
  static final lottoRewardVideo = AdInventory(
    inventoryName: 'lotto_reward_video',
    aos: 'ca-app-pub-4292162097306181/8472968142',
    ios: 'ca-app-pub-4292162097306181/2805902018',
  );

  static final lottoAttendanceRewardVideo = AdInventory(
    inventoryName: 'lotto_attendance3x',
    aos: 'ca-app-pub-4292162097306181/1592445587',
    ios: 'ca-app-pub-4292162097306181/2351773739',
  );

  static final mainBanner = AdInventory(
    inventoryName: 'main_bottom_banner',
    aos: 'ca-app-pub-4292162097306181/2108231157',
    ios: 'ca-app-pub-4292162097306181/1867777756',
  );

  // 전면 광고
  static final interstitial = AdInventory(
    inventoryName: 'lotto_interstitial',
    aos: 'ca-app-pub-4292162097306181/7159886478',
    ios: 'ca-app-pub-4292162097306181/4632767819',
  );
}
