import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInit = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iosInit = new DarwinInitializationSettings();
    var initSettings = new InitializationSettings(android: androidInit, iOS: iosInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
    tz.initializeTimeZones();
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin plugin}) async {
    NotificationDetails not = _notificationDetails();
    await plugin.show(0, title, body, not);
  }

  static NotificationDetails _notificationDetails() {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      "name",
      "channel name",
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: DarwinNotificationDetails());
    return not;
  }

  static void showScheduledNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required DateTime scheduledTime,
          }) async =>
      _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledTime, tz.local),
          _notificationDetails(),
          uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.wallClockTime,
          androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time
      );

}
