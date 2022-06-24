import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:shreddit/injector/usecases/get_user_localdb_usecase.dart';
import 'package:shreddit/injector/usecases/update_user_usecase.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/utils.dart';

class AccountScreenBloc {
  final _gender = BehaviorSubject<Gender>();

  Stream<Gender> get genderStream => _gender.stream;

  Future<bool> updateUser(UserModel userModel) async {
    bool res = await GetIt.I.get<UpdateUserUsecase>().execute(userModel);
    return res;
  }

  Future<UserModel?> getUserName() async {
    final UserModel? userModel =
        await GetIt.I.get<GetUserLocalDBUsecase>().execute();
    _gender.add(userModel!.gender);
    return userModel;
  }

  changeGender(Gender gender) {
    _gender.add(gender);
  }

  void dispose() {
    _gender.close();
  }
}
