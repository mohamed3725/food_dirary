import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:js' as js;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      // 1. Request Permission
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted notification permission');
      }

      // 2. Initialize Local Notifications (Mobile only for now)
      if (!kIsWeb) {
        const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
        const iosSettings = DarwinInitializationSettings();
        const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

        await _localNotifications.initialize(
          initSettings,
          onDidReceiveNotificationResponse: (details) {
            // Handle notification tap
          },
        );
      }

      // 3. Handle Foreground Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Received foreground message: ${message.notification?.title}');
        if (message.notification != null) {
          showLocalNotification(
            title: message.notification!.title ?? 'Update',
            body: message.notification!.body ?? 'Something changed!',
          );
        }
      });
    } catch (e) {
      debugPrint('Notification Service initialization error: $e');
    }
  }

  Future<void> showLocalNotification({required String title, required String body}) async {
    if (kIsWeb) {
      // Check for browser notification permission
      if (js.context.hasProperty('Notification')) {
        var permission = js.context['Notification']['permission'];
        if (permission == 'granted') {
          _showWebNotification(title, body);
        } else if (permission != 'denied') {
          js.context['Notification'].callMethod('requestPermission', [
            (String status) {
              if (status == 'granted') {
                _showWebNotification(title, body);
              }
            }
          ]);
        }
      }
      return;
    }
    const androidDetails = AndroidNotificationDetails(
      'food_diary_channel',
      'Food Diary Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      platformDetails,
    );
  }

  void _showWebNotification(String title, String body) {
    debugPrint('Web Notification Triggered: $title - $body');
    try {
      if (js.context.hasProperty('Notification')) {
        js.JsObject(js.context['Notification'], [
          title,
          js.JsObject.jsify({'body': body})
        ]);
      }
    } catch (e) {
      debugPrint('JS Notification Error: $e');
    }
  }
}
