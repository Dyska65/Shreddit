import 'package:get_it/get_it.dart';
import 'package:shreddit/network/api_manager.dart';
import 'package:shreddit/network/cloud_msg_manager.dart';
import 'package:shreddit/network/data_manager.dart';
import 'package:shreddit/network/models/user.dart';

abstract class FirebaseMessageRepository {
  Future<bool> createMessageHTTP(String title);
  connectionToFirebaseMessaging();
  Future<bool> checkIfUserSubscribed();
  Future<bool> userSubscribe();
  Future<bool> userUnsubscribe();
}

class FirebaseMessageRepositoryImpl implements FirebaseMessageRepository {
  final _dataManager = GetIt.I.get<DataManager>();
  final _apiManager = GetIt.I.get<APIManager>();
  final _cloudMessageManager = GetIt.I.get<CloudMessageManager>();

  @override
  Future<bool> createMessageHTTP(String title) async {
    UserModel userModel = await _dataManager.getCurrentUser();
    List listOfSubscribedUser =
        await _cloudMessageManager.getListOfSubscribedUsers();
    String tokenDevice = await _cloudMessageManager.getTokenDevice();
    if (listOfSubscribedUser.contains(tokenDevice)) {
      listOfSubscribedUser.remove(tokenDevice);
    }
    return _apiManager.createpushNotification(
        title, userModel.userName, listOfSubscribedUser);
  }

  @override
  connectionToFirebaseMessaging() {
    _cloudMessageManager.getInitialFirebaseMessage();
    _cloudMessageManager.listenFirebaseMessage();
    _cloudMessageManager.firebaseMessageOpenedApp();
  }

  @override
  Future<bool> checkIfUserSubscribed() async {
    String tokenDevice = await _cloudMessageManager.getTokenDevice();
    bool checkIfUserSubscribed =
        await _cloudMessageManager.checkSubscribedUser(tokenDevice);
    return checkIfUserSubscribed;
  }

  @override
  Future<bool> userSubscribe() async {
    String tokenDevice = await _cloudMessageManager.getTokenDevice();
    return _cloudMessageManager.userSubscribe(tokenDevice);
  }

  @override
  Future<bool> userUnsubscribe() async {
    String tokenDevice = await _cloudMessageManager.getTokenDevice();
    return _cloudMessageManager.userUnsubscribe(tokenDevice);
  }
}
