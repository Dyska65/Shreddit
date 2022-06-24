import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreddit/network/models/user.dart';

abstract class DataManager {
  Future<bool> saveUser(UserModel userModel);
  Future<bool> savedUpdateUser(UserModel userModel);
  Future<bool> deleteUser();
  Future<UserModel?> getUserIfExist();
  Future<UserModel> getCurrentUser();
}

class DataManagerImpl implements DataManager {
  late UserModel storedUser;

  @override
  Future<bool> saveUser(UserModel userModel) async {
    try {
      String stringUserModel = userModelToJson(userModel);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userModel', stringUserModel);
      storedUser = userModelFromJson(stringUserModel);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> savedUpdateUser(UserModel userModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var oldUser = prefs.getString('userModel');
      if (oldUser != null && oldUser.isNotEmpty) {
        var user = userModelFromJson(oldUser);
        user.gender = userModel.gender;
        user.userName = userModel.userName;
        String newUser = userModelToJson(user);
        bool isDelete = await deleteUser();
        if (!isDelete) {
          return false;
        }
        await prefs.setString('userModel', newUser);
        storedUser = user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Future<bool> deleteUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userModel');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getUserIfExist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? user = prefs.getString('userModel');
      if (user == null) {
        return null;
      }
      storedUser = userModelFromJson(user);
      return storedUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('userModel') ?? '';
      if (user == '') {
        return storedUser;
      }
      storedUser = userModelFromJson(user);
      return storedUser;
    } catch (e) {
      return storedUser;
    }
  }
}
