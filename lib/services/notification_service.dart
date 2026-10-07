import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings: settings);
  }

  Future<void> showBorrowSuccess(int count) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'borrow_channel_id',
      'Thông báo mượn thiết bị',
      channelDescription: 'Thông báo khi mượn thiết bị thành công',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: 0,
      title: 'Mượn thành công!',
      body: 'Bạn đã mượn thành công $count thiết bị.',
      notificationDetails: platformDetails,
    );
  }
}
