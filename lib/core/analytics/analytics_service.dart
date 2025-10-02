import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsService {
  Future<void> logEvent(String name, Map<String, dynamic>? parameters);
  Future<void> logScreenView(String screenName, String screenClass);
  Future<void> setUserProperty(String name, String? value);
  Future<void> setUserId(String? id);
  Future<void> logError(String error, String? stackTrace);
}

class AnalyticsServiceImpl implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logEvent(String name, Map<String, dynamic>? parameters) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      // Handle analytics error silently
      print('Analytics error: $e');
    }
  }

  @override
  Future<void> logScreenView(String screenName, String screenClass) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      print('Analytics screen view error: $e');
    }
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      print('Analytics user property error: $e');
    }
  }

  @override
  Future<void> setUserId(String? id) async {
    try {
      await _analytics.setUserId(id: id);
    } catch (e) {
      print('Analytics user ID error: $e');
    }
  }

  @override
  Future<void> logError(String error, String? stackTrace) async {
    try {
      await _analytics.logEvent(
        name: 'app_error',
        parameters: {
          'error': error,
          'stack_trace': stackTrace,
        },
      );
    } catch (e) {
      print('Analytics error logging error: $e');
    }
  }
}