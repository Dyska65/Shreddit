import 'package:get_it/get_it.dart';
import 'package:shreddit/injector/usecases/add_posts_usecase.dart';

class AddPostBloc {
  Future<bool> addingPost(String title, String content) {
    return GetIt.I.get<AddPostsUsecase>().execute(title, content);
  }
}
