import 'package:get_it/get_it.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/repositories/local_data_repository.dart';

class GetUserLocalDBUsecase {
  final _localDataRepository = GetIt.I.get<LocalDataRepository>();

  Future<UserModel?> execute() async {
    UserModel? currentUser = await _localDataRepository.getIfUserExist();
    return currentUser;
  }

  Future<UserModel> getCurrentUser() async {
    UserModel currentUser = await _localDataRepository.getCurrentUser();
    return currentUser;
  }
}
