import 'dart:async';

import 'package:taro/common/util/applogger.dart';
import 'package:taro/common/util/intent_handler.dart';
import 'package:taro/common/webview/jsbridge.dart';
import 'package:taro/router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class BaseWebview extends ConsumerStatefulWidget {
  final String initialUrl;
  final String? title;
  final bool showAppBar;
  final bool useCloseButton;
  final bool isRootView;
  final void Function(String)? onUrlChange;
  final void Function(String)? onPageFinished;

  const BaseWebview({
    super.key,
    required this.initialUrl,
    this.title,
    this.showAppBar = false,
    this.useCloseButton = false,
    this.isRootView = false,
    this.onUrlChange,
    this.onPageFinished,
  });

  @override
  ConsumerState<BaseWebview> createState() => BaseWebviewState();
}

class BaseWebviewState extends ConsumerState<BaseWebview>
    with RouteAware, WidgetsBindingObserver {
  late final WebViewController _controller;
  late final Jsbridge _jsbridge;
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  final ValueNotifier<int> progress = ValueNotifier(0); // 0~100

  String _currentUrl = '';
  bool _isError = false;
  bool _hasError = false;
  Timer? _timeoutTimer;
  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
    AppLogger.i(widget.initialUrl);
    WidgetsBinding.instance.addObserver(this);
    _initWebViewController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isRootView) {
      // RouteObserver 등록
      routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _jsbridge.sendActiveEvent();
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void setRequestTimeout() {
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (!(isLoading.value)) {
        setState(() {
          _isError = true;
          _hasError = true;
        });
      }
    });
  }

  @override
  void didPopNext() {
    _jsbridge.sendActiveEvent();
    AppLogger.d('WebView didApear');
  }

  void sendActiveEvent() {
    _jsbridge.sendActiveEvent();
  }

  void _initWebViewController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    if (controller.platform is WebKitWebViewController) {
      final platformController = controller.platform as WebKitWebViewController;
      platformController.setInspectable(true);
    }

    _controller = controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            AppLogger.i(url);
            _currentUrl = url;
            widget.onUrlChange?.call(url);
            isLoading.value = true;
            setRequestTimeout();
          },
          onProgress: (int progress) {
            this.progress.value = progress;
          },
          onPageFinished: (String url) {
            if (!_hasError) {
              // 에러가 발생하지 않은 경우에만 에러 화면 닫기
              setState(() {
                _isError = false;
              });
            }
            _timeoutTimer?.cancel();
            widget.onPageFinished?.call(url);
            isLoading.value = false;
            _controller.runJavaScript('''
(function() {
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no';
        document.getElementsByTagName('head')[0].appendChild(meta);
      })();
    ''');
            _jsbridge.sendActiveEvent();
            AppLogger.i('Page finished loading: $url');
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith("mogllotto://")) {
              // 앱 딥링크 실행
              IntentHandler.handleUri(Uri.parse(request.url), ref);

              return NavigationDecision.prevent; // WebView에서 열지 않음
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            if (error.errorType != null) {
              switch (error.errorType) {
                case WebResourceErrorType.webContentProcessTerminated:
                  controller.reload();
                  break;
                case WebResourceErrorType.connect:
                case WebResourceErrorType.timeout:
                case WebResourceErrorType.hostLookup:
                  setState(() {
                    _isError = true;
                    _hasError = true;
                  });
                  break;
                default:
                  // 기본 처리
                  break;
              }
            }
            AppLogger.i(
              'WebView error Code: ${error.errorCode}, type:${error.errorType}, descrip:${error.description}',
            );
          },
        ),
      )
      ..addJavaScriptChannel(
        "gary",
        onMessageReceived: (JavaScriptMessage message) {
          AppLogger.i('Received message from JS: ${message.message}');
          _jsbridge.handleJSMessage(message.message);
        },
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    _jsbridge = Jsbridge(context, _controller);
  }

  void _retryLoading() {
    setState(() {
      _hasError = false; // 리트라이할 때 에러 플래그 초기화
    });
    _controller.loadRequest(Uri.parse(_currentUrl));
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          const Text(
            "네트워크 오류가 발생했습니다.\n다음에 다시 시도해주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _retryLoading, child: const Text("다시 시도")),
        ],
      ),
    );
  }

  // Future<bool> _handleBackPress() async {
  //   if (await _controller.canGoBack()) {
  //     await _controller.goBack();
  //     return false;
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? _buildAppBar() : null,
      body: _isError
          ? _buildErrorScreen()
          : Stack(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, isLoading, _) {
                    return isLoading
                        ? Positioned(
                            top: widget.showAppBar
                                ? kToolbarHeight // AppBar 높이만큼 내려옴
                                : MediaQuery.of(
                                    context,
                                  ).padding.top, // SafeArea top // SafeArea top
                            left: 0,
                            right: 0,
                            child: ValueListenableBuilder<int>(
                              valueListenable: progress,
                              builder: (context, progress, _) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  height: 4,
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: progress / 100.0,
                                    child: Container(
                                      height: 4,
                                      color: Colors.green,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                SafeArea(child: WebViewWidget(controller: _controller)),
                // if (_isLoading) const AppLoadingWidget(),
              ],
            ),
      floatingActionButton: widget.useCloseButton
          ? _floatingCloseButton()
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: Text(widget.title ?? ""), actions: const []);
  }

  Widget? _floatingCloseButton() {
    return FloatingActionButton(
      heroTag: 'webview_close_button', // Hero 애니메이션 비활성화
      mini: true,
      child: const Icon(Icons.close_rounded),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

// 사용 예시
class WebViewDemo extends StatelessWidget {
  const WebViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BaseWebview(
        initialUrl: 'https://flutter.dev',
        title: 'Flutter WebView',
        onUrlChange: (String url) {
          AppLogger.i('URL changed to: $url');
        },
        onPageFinished: (String url) {
          AppLogger.i('Page finished loading: $url');
        },
      ),
    );
  }
}
