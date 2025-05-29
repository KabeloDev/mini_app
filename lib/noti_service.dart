import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true; // ✅ Moved here so it's set after initialization
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> showNotification(int id, String title, String body) async {
    if (!_isInitialized) {
      await requestNotificationPermission();
      await initNotification(); // Will set _isInitialized internally
    }

    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }
}
