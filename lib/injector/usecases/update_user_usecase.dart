import 'package:get_it/get_it.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/repositories/authentication_repository.dart';
import 'package:shreddit/repositories/local_data_repository.dart';

class UpdateUserUsecase {
  final _firebaseRepository = GetIt.I.get<AuthenticationRepository>();
  final _localDataRepository = GetIt.I.get<LocalDataRepository>();

  Future<bool> execute(UserModel userModel) async {
    bool resUpdateUser = await _firebaseRepository.updateUser(userModel);
    if (!resUpdateUser) {
      return false;
    }
    return _localDataRepository.updateUser(userModel);
  }

  Future<bool> updateFromFirebase(UserModel oldUserModel) async {
    UserModel? newUser =
        await _firebaseRepository.updateUserFromFirebase(oldUserModel);
    if (newUser == null) {
      return false;
    }
    bool res = await _localDataRepository.saveUser(newUser);
    return res;
  }
}
