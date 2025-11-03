import 'dart:async';

import 'package:taro/common/apiservice/apiservice.dart';
// import 'package:taro/common/database/app_database.dart';
import 'package:taro/common/util/app_storage.dart';
import 'package:taro/common/util/applogger.dart';
import 'package:taro/common/util/device_manager.dart';
import 'package:taro/common/util/intent_handler.dart';
import 'package:taro/firebase_options.dart';
import 'package:taro/router/go_router.dart';
import 'package:taro/screen/main/main_screen.dart';
import 'package:taro/splash/splash_screen.dart';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toastification/toastification.dart';

final appStorageProvider = Provider<AppStorage>((ref) {
  return AppStorage();
});
// final appDatabaseProvider = Provider<AppDatabase>((ref) {
//   return AppDatabase();
// });
final apiService = Provider<ApiService>((ref) {
  return ApiService();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  AppStorage.checkIfFirstInstallAndClearSecureData();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DeviceManager.registerToServer()
      .then((push) {
        AppLogger.i("✅ Device 등록 완료: ${push?.message}");
      })
      .catchError((e) {
        AppLogger.i("❌ 등록 중 에러: $e");
      });
  runApp(
    ProviderScope(
      // overrides: [appStorageProvider, appDatabaseProvider, apiService],
      overrides: [appStorageProvider, apiService],
      child: const App(),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  // This widget is the root of your application.
  StreamSubscription<Uri>? _sub;
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
    _checkInitialMessage();
    _initTheme();
  }

  Future<void> _initDeepLinkListener() async {
    try {
      _appLinks = AppLinks();
      await Future.delayed(const Duration(milliseconds: 300));

      _sub = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          AppLogger.i('딥링크 수신: $uri');
          IntentHandler.handleUri(uri, ref);
        },
        onError: (err) {
          debugPrint('Deep link error: $err');
        },
      );
    } catch (e) {
      debugPrint('Failed to init deep link: $e');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final deeplink = message.data['deeplink'];
      if (deeplink != null) {
        AppLogger.i('Push 딥링크: $deeplink');
        IntentHandler.handleUri(Uri.parse(deeplink), ref);
      }
    });
  }

  Future<void> _initTheme() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final themePrefix = isDarkMode ? 'dark' : 'light';
    AppLogger.i('현재 테마: $themePrefix 모드');
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _checkInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final deeplink = initialMessage.data['deeplink'];
      if (deeplink != null) {
        AppLogger.i('초기 딥링크: $deeplink');
        IntentHandler.handleUri(Uri.parse(deeplink), ref);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
        themeMode: ThemeMode.light,
        routerConfig: goRouter,
        builder: (context, child) {
          return SplashScreen(child: child);
        },
      ),
    );
  }
}
