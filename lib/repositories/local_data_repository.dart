import 'package:get_it/get_it.dart';
import 'package:shreddit/network/data_manager.dart';
import 'package:shreddit/network/models/user.dart';

abstract class LocalDataRepository {
  Future<bool> deleteUser();
  Future<bool> saveUser(UserModel userModel);
  Future<bool> updateUser(UserModel userModel);
  Future<UserModel?> getIfUserExist();
  Future<UserModel> getCurrentUser();
}

class LocalDataRepositoryImpl implements LocalDataRepository {
  final _dataManager = GetIt.I.get<DataManager>();

  @override
  Future<bool> deleteUser() {
    return _dataManager.deleteUser();
  }

  @override
  Future<bool> updateUser(UserModel userModel) async {
    bool isSavedModifyUser = await _dataManager.savedUpdateUser(userModel);
    return isSavedModifyUser;
  }

  @override
  Future<bool> saveUser(UserModel userModel) {
    return _dataManager.saveUser(userModel);
  }

  @override
  Future<UserModel?> getIfUserExist() async {
    UserModel? userModel = await _dataManager.getUserIfExist();
    return userModel;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    UserModel userModel = await _dataManager.getCurrentUser();
    return userModel;
  }
}
