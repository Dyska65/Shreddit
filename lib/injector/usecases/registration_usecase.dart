import 'package:get_it/get_it.dart';
import 'package:shreddit/repositories/authentication_repository.dart';
import 'package:shreddit/repositories/local_data_repository.dart';
import 'package:shreddit/repositories/result_function_model.dart';
import 'package:shreddit/utils.dart';

class RegisterUsecase {
  final _firebaseRepository = GetIt.I.get<AuthenticationRepository>();
  final _localDataRepository = GetIt.I.get<LocalDataRepository>();

  Future<AuthorizationResult> execute(
      String email, String password, String userName, Gender gender) async {
    AuthResult registration = await _firebaseRepository.registration(
        email, password, userName, gender);
    if (registration.result != AuthorizationResult.success ||
        registration.value == null) {
      return registration.result;
    }
    bool isSavedUser = await _localDataRepository.saveUser(registration.value!);
    return isSavedUser
        ? AuthorizationResult.success
        : AuthorizationResult.error;
  }
}
