import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  // Khởi tạo notification
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(settings);
  }

  // Xin quyền (Android 13+)
  static Future<bool> requestPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidPlugin?.requestNotificationsPermission();
    return granted ?? false;
  }

  // Gửi notification đơn giản
  static Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'lab10_5_channel',
      'Lab 10.5 Notifications',
      channelDescription: 'Notifications for Lab 10.5',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(id, title, body, details);
  }

  // Gửi notification với big text
  static Future<void> showBigTextNotification({
    required int id,
    required String title,
    required String body,
    required String bigText,
  }) async {
    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'lab10_5_channel',
      'Lab 10.5 Notifications',
      channelDescription: 'Notifications for Lab 10.5',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(bigText),
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(id, title, body, details);
  }

  // Huỷ notification
  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  // Huỷ tất cả
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}