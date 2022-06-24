import 'package:get_it/get_it.dart';
import 'package:shreddit/repositories/firebase_message_repository.dart';

class GetFirebaseMessagingUsecase {
  final _firebaseMessageRepository = GetIt.I.get<FirebaseMessageRepository>();

  Future execute() async {
    _firebaseMessageRepository.connectionToFirebaseMessaging();
  }
}
