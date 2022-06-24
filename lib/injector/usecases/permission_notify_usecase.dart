import 'package:get_it/get_it.dart';
import 'package:shreddit/repositories/firebase_message_repository.dart';

class PermissionNotifyUsecase {
  final _firebaseMessageRepository = GetIt.I.get<FirebaseMessageRepository>();

  Future<bool> checkIfUserSubscribed() {
    return _firebaseMessageRepository.checkIfUserSubscribed();
  }

  Future<bool> userSubscribed() {
    return _firebaseMessageRepository.userSubscribe();
  }

  Future<bool> userUnsubscribed() {
    return _firebaseMessageRepository.userUnsubscribe();
  }
}
