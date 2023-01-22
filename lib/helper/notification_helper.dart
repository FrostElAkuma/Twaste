import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/auth_controller.dart';

class NotificationHelper {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    //Need to update my code to latest version of the plugins
    var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    //The payload is the data that we sent from our backend code
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      try {
        if (payload != null && payload.isNotEmpty) {
        } else {
          // Get.toNamed(RouteHelper.getNotificationRoute());
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
      return;
    });
    //This I need for IOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    //If the messages are coming from firebase we listen to them
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("..................onMessage..............");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");

      //After we got the msgs from firebase we call the below method that will actaulyl show the notification
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin);
      if (Get.find<AuthController>().userLoggedIn()) {
        //Get.find<OrderController>().getRunningOrders(1);
        //Get.find<OrderController>().getHistoryOrders(1);
        //Get.find<NotificationController>().getNotificationList(true);
      }
    });
    //This for when app is in background or app is terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //These just for testing purposees
      print(
          "onOpenApp: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
      try {
        if (message.notification?.titleLocKey != null) {
          // Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(message.notification!.titleLocKey!)));
        } else {
          // Get.toNamed(RouteHelper.getNotificationRoute());
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  static Future<void> showNotification(
      RemoteMessage msg, FlutterLocalNotificationsPlugin fln) async {
    //Styling for the message that will be shown to the user
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      msg.notification!.body!,
      htmlFormatBigText: true,
      contentTitle: msg.notification!.title!,
      htmlFormatContent: true,
    );
    //IF sound does not work try to change channel_id name
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id_1', 'wtvName 2', importance: Importance.high,
      styleInformation: bigTextStyleInformation, priority: Priority.high,
      playSound: true,
      // sound: RawResourceAndroidNotificationSoind('eloo'),
    );
    //This is the important part in this function
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const IOSNotificationDetails(),
    );
    await fln.show(0, msg.notification!.title, msg.notification!.body,
        platformChannelSpecifics);
  }
}
