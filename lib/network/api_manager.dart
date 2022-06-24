import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class APIManager {
  Future<bool> createpushNotification(
      String title, String userName, List listOfSubscribedUser);
}

class APIManagerImpl extends APIManager {
  @override
  Future<bool> createpushNotification(
      String title, String userName, List listOfSubscribedUser) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAaCLg2gk:APA91bE1eBymWsCoLhV6SBt4NBWYqx61zlylnQlubq_Cbm51upWaQGw684XXgSNzo143892O_rhZ7LZAGgxHLeaWiMpT0HT1iCgErvqVT6fUpXp-ZwV3nu6y1-yjuaKEuWNJeWDKYA3Q'
        },
        body: jsonEncode({
          "registration_ids": listOfSubscribedUser,
          "notification": {
            "body": title,
            "title": "$userName posted a new post ",
            "android_channel_id": "shredder",
            "sound": true
          }
        }),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
