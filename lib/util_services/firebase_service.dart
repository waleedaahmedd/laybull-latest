import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future getTokken() async {
    String? deviceToken = await messaging.getToken();
    log(deviceToken.toString());
  }

  Future notificatonPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
  }

  getForgruoundNotificaton() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}
