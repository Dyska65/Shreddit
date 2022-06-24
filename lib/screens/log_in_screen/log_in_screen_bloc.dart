import 'package:get_it/get_it.dart';
import 'package:shreddit/injector/usecases/log_in_usecase.dart';
import 'package:shreddit/utils.dart';

class LogInScreenBloc {
  Future<AuthorizationResult> logIn(String email, String password) async {
    return GetIt.I.get<LogInUsecase>().execute(email, password);
  }
}
