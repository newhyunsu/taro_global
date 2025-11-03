import 'package:taro/common/advertising/google_admob_interstitial.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:flutter/material.dart';

class FullScreenAdWidget extends StatefulWidget {
  const FullScreenAdWidget({super.key, required this.onDismissed});
  final Function() onDismissed;
  @override
  State<FullScreenAdWidget> createState() => _FullScreenAdWidgetState();
}

class _FullScreenAdWidgetState extends State<FullScreenAdWidget> {
  final adInterstitialService = AdInterstitialService();

  @override
  void initState() {
    super.initState();
    // 여기서 show되는 순간을 감지!
    adInterstitialService.showInterstitialAd(
      onAdEvent: (result) {
        AppLogger.i('FullScreenAdWidget이 화면에 보여짐!');
        switch (result.event) {
          case AdInterstitialEvent.loadFailed:
          case AdInterstitialEvent.showFailed:
          case AdInterstitialEvent.showed:
            widget.onDismissed();
            break;

          default:
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: Container(color: Colors.white));
  }
}
