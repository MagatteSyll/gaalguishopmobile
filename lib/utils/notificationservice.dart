import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;





final GlobalKey<NavigatorState> navigatorKey = GlobalKey(
    debugLabel: "Main Navigator");
class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> intialize() async {
   
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/icon');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            icon: "icon");
            

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      required payload
     }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
    payload: payload  );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    return;
  }

  void onSelectNotification(String? payload) {
    print('payload $payload'); 
    navigatorKey.currentState?.pushNamed('/notification');
    
  }
}