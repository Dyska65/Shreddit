import 'package:get_it/get_it.dart';
import 'package:shreddit/repositories/posts_repository.dart';

class DeletePostsUsecase {
  final _listRepository = GetIt.I.get<PostsRepository>();

  Future<bool> execute(String id) async {
    return await _listRepository.deletePost(id);
  }
}
