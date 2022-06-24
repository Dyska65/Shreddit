import 'package:get_it/get_it.dart';
import 'package:shreddit/repositories/authentication_repository.dart';
import 'package:shreddit/repositories/local_data_repository.dart';

class LogOutUsecase {
  final _firebaseRepository = GetIt.I.get<AuthenticationRepository>();
  final _localDataRepository = GetIt.I.get<LocalDataRepository>();

  Future<bool> execute() async {
    bool resLogOut = await _firebaseRepository.logOut();
    if (!resLogOut) {
      return resLogOut;
    }
    bool resDeleteUser = await _localDataRepository.deleteUser();
    return resDeleteUser;
  }
}
