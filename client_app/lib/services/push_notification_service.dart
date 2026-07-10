import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  // Singleton pattern
  static final PushNotificationService _instance = PushNotificationService._internal();

  factory PushNotificationService() {
    return _instance;
  }

  PushNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission from the user
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('PushNotificationService: User granted permission');
      }
      // Get the FCM device token
      String? token = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        print('PushNotificationService FCM Token: $token');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('PushNotificationService: User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('PushNotificationService: User declined or has not accepted permission');
      }
    }
  }
}
