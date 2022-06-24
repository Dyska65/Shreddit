import 'package:get_it/get_it.dart';
import 'package:shreddit/injector/usecases/get_user_localdb_usecase.dart';
import 'package:shreddit/injector/usecases/update_user_usecase.dart';
import 'package:shreddit/network/models/user.dart';

class SplashScreenBloc {
  Future<bool> isAuthorized() async {
    UserModel? userModel = await GetIt.I.get<GetUserLocalDBUsecase>().execute();
    if (userModel == null) {
      return false;
    }
    bool resSaveNewUser =
        await GetIt.I.get<UpdateUserUsecase>().updateFromFirebase(userModel);

    return resSaveNewUser;
  }
}
