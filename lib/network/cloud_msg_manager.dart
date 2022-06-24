import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shreddit/services/local_notification_service.dart';

abstract class CloudMessageManager {
  void getInitialFirebaseMessage();
  Future<String> getTokenDevice();
  void listenFirebaseMessage();
  void firebaseMessageOpenedApp();
  Future<bool> userSubscribe(String tokenDevice);
  Future<bool> checkSubscribedUser(String tokenDevice);
  Future<bool> userUnsubscribe(String tokenDevice);
  Future<List> getListOfSubscribedUsers();
}

class CloudMessageManagerImpl implements CloudMessageManager {
  @override
  void getInitialFirebaseMessage() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('FirebaseMessaging.instance.getInitialMessage');
    });
  }

  @override
  Future<String> getTokenDevice() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      return token;
    }
    return '';
  }

  @override
  Future<List> getListOfSubscribedUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('subscribedUsers');
    final getListOfSubscribedUsers =
        await users.doc('ListOfSubscribedUsers').get();
    return getListOfSubscribedUsers['ListOfUsers'];
  }

  @override
  void listenFirebaseMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.ttl}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification.toString()}');
        LocalNotificationService.createAndDisplayNotification(message);
      }
    });
  }

  @override
  void firebaseMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('FirebaseMessaging.onMessageOpenedApp');
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });
  }

  @override
  Future<bool> userSubscribe(String tokenDevice) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('subscribedUsers');
    try {
      final oldListOfUser = await users.doc('ListOfSubscribedUsers').get();
      List oldListUser = oldListOfUser['ListOfUsers'];
      oldListUser.add(tokenDevice);
      await users
          .doc('ListOfSubscribedUsers')
          .update({'ListOfUsers': oldListUser});

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> userUnsubscribe(String tokenDevice) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('subscribedUsers');
    try {
      final oldListOfUser = await users.doc('ListOfSubscribedUsers').get();
      List oldListUser = oldListOfUser['ListOfUsers'];
      oldListUser.remove(tokenDevice);
      await users
          .doc('ListOfSubscribedUsers')
          .update({'ListOfUsers': oldListUser});

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> checkSubscribedUser(String tokenDevice) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('subscribedUsers');
    try {
      final getListOfSubscribedUsers =
          await users.doc('ListOfSubscribedUsers').get();
      List oldListUser = getListOfSubscribedUsers['ListOfUsers'];
      return oldListUser.contains(tokenDevice);
    } catch (_) {
      return false;
    }
  }
}
