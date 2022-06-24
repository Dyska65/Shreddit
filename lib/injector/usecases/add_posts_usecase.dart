import 'package:get_it/get_it.dart';
import 'package:shreddit/repositories/firebase_message_repository.dart';
import 'package:shreddit/repositories/posts_repository.dart';

class AddPostsUsecase {
  final _listRepository = GetIt.I.get<PostsRepository>();
  final _firebaseMessageRepository = GetIt.I.get<FirebaseMessageRepository>();

  Future<bool> execute(String title, String content) async {
    bool isAddedPost = await _listRepository.addPost(title, content);
    if (isAddedPost) {
      return _firebaseMessageRepository.createMessageHTTP(title);
    }
    return false;
  }
}
