import 'package:taro/common/util/applogger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class GAnalitics {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: _analytics,
  );

  /// Sends an event to Google Analytics
  /// [name] The name of the event
  /// [parameters] Optional parameters for additional event data
  static Future<void> sendLog({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters == null
            ? null
            : Map<String, Object>.from(parameters),
      );
      AppLogger.i('GA Event sent: $name with params: $parameters');
    } catch (e) {
      AppLogger.i('Failed to send GA event: $e');
    }
  }
}
