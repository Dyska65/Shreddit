import 'package:get_it/get_it.dart';
import 'package:shreddit/repositories/authentication_repository.dart';
import 'package:shreddit/repositories/local_data_repository.dart';
import 'package:shreddit/repositories/result_function_model.dart';
import 'package:shreddit/utils.dart';

class LogInUsecase {
  final _firebaseRepository = GetIt.I.get<AuthenticationRepository>();
  final _localDataRepository = GetIt.I.get<LocalDataRepository>();

  Future<AuthorizationResult> execute(String email, String password) async {
    AuthResult authorizationResult =
        await _firebaseRepository.logIn(email, password);
    if (authorizationResult.result != AuthorizationResult.success ||
        authorizationResult.value == null) {
      return authorizationResult.result;
    }
    bool resSavedUser =
        await _localDataRepository.saveUser(authorizationResult.value!);
    return resSavedUser
        ? AuthorizationResult.success
        : AuthorizationResult.error;
  }
}
