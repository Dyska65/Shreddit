import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shreddit/services/local_notification_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/app.dart';
import 'package:shreddit/injector/injector.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Injector.register();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LocalNotificationService.initialize();
  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],
    path: 'assets/translations',
  ));
}
