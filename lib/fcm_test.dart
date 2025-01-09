// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

class FcmTest extends StatefulWidget {
  const FcmTest({super.key});

  @override
  State<FcmTest> createState() => _FcmTestState();
}

class _FcmTestState extends State<FcmTest> {

Future<void> setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 권한 요청 (iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 메시지 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received: ${message.notification?.title}');
  });
}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}