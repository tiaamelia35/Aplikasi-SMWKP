import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  // ignore: lines_longer_than_80_chars
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // Initialize push notifications
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    // Request permission for iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Get and log FCM token
    final token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      if (kDebugMode) {
        print('FCM Token: $token');
      }
    }

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen to background message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen(_handleTokenRefresh);

    _initialized = true;
  }

  // Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    // Create notification channel for Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'smwkp_channel',
            'SMWKP Notifications',
            description: 'Channel for SMWKP app notifications',
            importance: Importance.max,
            enableVibration: true,
            playSound: true,
          ),
        );
  }

  // Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Foreground message: ${message.notification?.title}');
    }

    // Display local notification (fire-and-forget)
    _showLocalNotification(
      id: message.messageId?.hashCode ?? 0,
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }

  // Handle background message
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Background message: ${message.notification?.title}');
    }
  }

  // Handle message opened from background
  static void _handleMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) {
      print('Message opened app: ${message.notification?.title}');
    }
    // TODO: Navigate to appropriate screen based on message data
  }

  // Handle local notification tap
  static void _handleLocalNotificationTap(
    NotificationResponse notificationResponse,
  ) {
    if (kDebugMode) {
      print('Local notification tapped: ${notificationResponse.payload}');
    }
    // TODO: Handle navigation based on payload
  }

  // Handle token refresh
  static void _handleTokenRefresh(String token) {
    if (kDebugMode) {
      print('FCM Token refreshed: $token');
    }
    // TODO: Send new token to backend
  }

  // Show local notification
  static Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const androidDetails =
        AndroidNotificationDetails(
      'smwkp_channel',
      'SMWKP Notifications',
      channelDescription: 'Channel for SMWKP app notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails =
        DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload?.toString(),
    );
  }

  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (kDebugMode) {
        print('Failed to subscribe to topic: $e');
      }
    }
  }

  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (kDebugMode) {
        print('Failed to unsubscribe from topic: $e');
      }
    }
  }

  // Get FCM token
  static Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get FCM token: $e');
      }
      return null;
    }
  }

  // Send notification to user
  static Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    // TODO: Implement via backend API
    // This should be called from your backend, not from the app
  }

  // Subscribe user to notifications
  static Future<void> subscribeUserToNotifications(String userId) async {
    try {
      await subscribeToTopic('user_$userId');
      await subscribeToTopic('all_users');
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (kDebugMode) {
        print('Failed to subscribe to notifications: $e');
      }
    }
  }

  // Unsubscribe user from notifications
  static Future<void> unsubscribeUserFromNotifications(String userId) async {
    try {
      await unsubscribeFromTopic('user_$userId');
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (kDebugMode) {
        print('Failed to unsubscribe from notifications: $e');
      }
    }
  }

  // Send local notification immediately
  static Future<void> sendLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    await _showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: payload,
    );
  }

  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id: id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Check if app is launched from notification
  // ignore: lines_longer_than_80_chars
  static Future<RemoteMessage?> getInitialMessage() async => _firebaseMessaging.getInitialMessage();
}
