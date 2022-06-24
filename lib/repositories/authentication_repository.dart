import 'package:get_it/get_it.dart';
import 'package:shreddit/network/firebase_manager.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/repositories/result_function_model.dart';
import 'package:shreddit/utils.dart';

abstract class AuthenticationRepository {
  Future<AuthResult> logIn(String email, String password);
  Future<AuthResult> registration(
      String email, String password, String userName, Gender gender);
  Future<bool> logOut();
  Future<bool> updateUser(UserModel userModel);
  Future<UserModel?> updateUserFromFirebase(UserModel oldUserModel);
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final _firebaseManager = GetIt.I.get<FirebaseManager>();

  @override
  Future<AuthResult> logIn(String email, String password) async {
    AuthorizationResult logIn = await _firebaseManager.logIn(email, password);
    if (logIn != AuthorizationResult.success) {
      return AuthResult(result: logIn, value: null);
    }
    UserModel? foundUser = await _firebaseManager.findUser(email);
    if (foundUser == null) {
      return AuthResult(result: AuthorizationResult.error, value: null);
    }

    return AuthResult(result: logIn, value: foundUser);
  }

  @override
  Future<AuthResult> registration(
      String email, String password, String userName, Gender gender) async {
    AuthorizationResult registration =
        await _firebaseManager.registration(email, password, userName, gender);
    if (registration != AuthorizationResult.success) {
      return AuthResult(result: registration, value: null);
    }
    UserModel? foundUser = await _firebaseManager.findUser(email);
    if (foundUser == null) {
      return AuthResult(result: AuthorizationResult.error, value: null);
    }
    return AuthResult(result: registration, value: foundUser);
  }

  @override
  Future<bool> logOut() async {
    bool resultlogOut = await _firebaseManager.logOut();
    return resultlogOut;
  }

  @override
  Future<bool> updateUser(UserModel userModel) async {
    bool resultUpdateUser =
        await _firebaseManager.updateUser(userModel.userName, userModel.gender);
    return resultUpdateUser;
  }

  @override
  Future<UserModel?> updateUserFromFirebase(UserModel oldUserModel) async {
    UserModel? newUser = await _firebaseManager.findUser(oldUserModel.email);
    return newUser;
  }
}
