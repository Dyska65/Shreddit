import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? id) async {
      print('onSelectNotification');
      if (id!.isNotEmpty) {
        print('Router Value1234 $id');
      }
    });
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final int id = DateTime.now().microsecondsSinceEpoch ~/ 1000000000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('shredder', 'shredderchannel',
            importance: Importance.max, priority: Priority.high),
      );

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data['_id']);
    } on Exception catch (e) {
      print(e);
    }
  }
}
