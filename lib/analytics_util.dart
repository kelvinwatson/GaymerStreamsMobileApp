import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';

class AnalyticsUtil {
  FirebaseAnalytics _analytics;

  AnalyticsUtil() {
    _analytics = new FirebaseAnalytics();
  }

  trackEvent({@required String eventName, Map<String, dynamic> parameters}) {
    if (_analytics != null){
      _analytics.logEvent(name: eventName, parameters: parameters);
    }
  }
}
