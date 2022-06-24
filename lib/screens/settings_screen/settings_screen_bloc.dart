import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:shreddit/injector/usecases/get_user_localdb_usecase.dart';
import 'package:shreddit/injector/usecases/log_out_usecase.dart';
import 'package:shreddit/injector/usecases/permission_notify_usecase.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/utils.dart';

class SettingsScreenBloc {
  final _isLoadingLogOut = BehaviorSubject<bool>();
  Stream<bool> get isLoadingStream => _isLoadingLogOut.stream;

  final _language = BehaviorSubject<Language>();
  Stream<Language> get languageStream => _language.stream;

  final _permissionNotification = BehaviorSubject<bool>();
  Stream<bool> get permissionNotificationStream =>
      _permissionNotification.stream;

  Future<bool> logOut() async {
    _isLoadingLogOut.add(true);
    bool res = await GetIt.I.get<LogOutUsecase>().execute();
    _isLoadingLogOut.add(false);
    return res;
  }

  Future<UserModel> getUserName() async {
    UserModel userModel =
        await GetIt.I.get<GetUserLocalDBUsecase>().getCurrentUser();
    return userModel;
  }

  changeLanguage(Language language) {
    _language.add(language);
  }

  checkPermisionNotification() async {
    bool checkPermisionNotification =
        await GetIt.I.get<PermissionNotifyUsecase>().checkIfUserSubscribed();
    _permissionNotification.add(checkPermisionNotification);
  }

  userSubscribe() async {
    bool isSubscribe =
        await GetIt.I.get<PermissionNotifyUsecase>().userSubscribed();

    _permissionNotification.add(isSubscribe ? true : false);
  }

  userUnsubscribe() async {
    bool isUnsubscribe =
        await GetIt.I.get<PermissionNotifyUsecase>().userUnsubscribed();
    _permissionNotification.add(isUnsubscribe ? false : true);
  }

  void dispose() {
    _isLoadingLogOut.close();
    _language.close();
  }
}
