// 딥링크 명령어 enum 정의
import 'package:taro/common/util/applogger.dart';
import 'package:taro/router/go_router.dart';
import 'package:taro/screen/main/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:taro/screen/main/providers/main_tab_provider.dart';

enum DeeplinkCommand {
  cmd1000, //매입탭에서 subtab 이동할때,  mogllotto://cmd1000?tab=1
  cmd1001,
  cmd2000, //url 노출을 위한 deeplink
  cmd3000, //외부 채널(Other Apps)에서 유입할때 사용하는 deeplink
  unknown;

  factory DeeplinkCommand.fromHost(String host) {
    switch (host) {
      case 'cmd1000':
        return DeeplinkCommand.cmd1000;
      case 'cmd1001':
        return DeeplinkCommand.cmd1001;
      case 'cmd2000':
        return DeeplinkCommand.cmd2000;
      case 'cmd3000':
        return DeeplinkCommand.cmd3000;
      default:
        return DeeplinkCommand.unknown;
    }
  }
}

class IntentHandler {
  static void handleUri(Uri uri, WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final host = uri.host;
    final query = uri.queryParameters;
    final command = DeeplinkCommand.fromHost(host);
    switch (command) {
      //ex) mogllotto://cmd1000?tab=1&index=3
      case DeeplinkCommand.cmd1000:
        final tabString = query['tab'] ?? '0';
        int tab = int.tryParse(tabString) ?? 0; // String을 int로 변환

        final subIndex = query['index'] ?? '0';
        int index = int.tryParse(subIndex) ?? 0;

        if (tab < 0 || tab > 1) {
          tab = 0; // 유효하지 않은 값일 경우 기본값으로 설정
        }

        if (tab == 1 && subIndex.isNotEmpty) {
          // 추가적인 처리 로직
          // ref.read(selectedMethodIndexProvider.notifier).state = index;
        }
        AppLogger.i('cmd1000 딥링크 처리 - tab: $tab');

        // if (mounted && context.mounted) {
        goRouter.go('/');
        ref.read(selectedIndexProvider.notifier).state = tab;
        // }
        break;
      case DeeplinkCommand.cmd1001:
        final id = query['id'];
        if (id != null && id.isNotEmpty) {}
        break;
      case DeeplinkCommand.cmd2000:
        final url = query['url'];
        if (url != null && url.isNotEmpty) {}
        break;
      case DeeplinkCommand.cmd3000:
        final id = query['id'];
        final channel = query['channel'] ?? 'tong2x';
        final hashKey = query['hashKey'];

        break;
      case DeeplinkCommand.unknown:
        AppLogger.i('Unhandled link: $uri');
    }
  }
}
