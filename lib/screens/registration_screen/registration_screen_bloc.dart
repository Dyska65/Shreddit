import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:shreddit/injector/usecases/registration_usecase.dart';
import 'package:shreddit/utils.dart';

class RegistrationScreenBloc {
  final _isLoading = BehaviorSubject<bool>();
  Stream<bool> get isLoadingStream => _isLoading.stream;

  final _gender = BehaviorSubject<Gender>();
  Stream<Gender> get genderStream => _gender.stream;

  Future<AuthorizationResult> register(
      String email, String password, String userName, Gender gender) async {
    _isLoading.add(true);
    var res = await GetIt.I
        .get<RegisterUsecase>()
        .execute(email, password, userName, gender);
    _isLoading.add(false);
    return res;
  }

  changeGender(Gender gender) {
    _gender.add(gender);
  }

  void dispose() {
    _isLoading.close();
  }
}
