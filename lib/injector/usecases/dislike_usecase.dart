import 'package:get_it/get_it.dart';
import 'package:shreddit/network/models/post.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/repositories/local_data_repository.dart';
import 'package:shreddit/repositories/posts_repository.dart';

class DislikeUsecase {
  final _postRepository = GetIt.I.get<PostsRepository>();
  final _localDataRepository = GetIt.I.get<LocalDataRepository>();

  Future<bool> execute(Post post) async {
    UserModel userModel = await _localDataRepository.getCurrentUser();
    return await _postRepository.dislikePost(post, userModel);
  }
}
