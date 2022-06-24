import 'package:get_it/get_it.dart';
import 'package:shreddit/network/firebase_manager.dart';
import 'package:shreddit/network/models/post.dart';
import 'package:shreddit/network/models/user.dart';

abstract class PostsRepository {
  Future<List<Post>> getPosts(UserModel userModel);
  Future<bool> addPost(String title, String content);
  Future<bool> deletePost(String id);
  Future<bool> likePost(Post post, UserModel userModel);
  Future<bool> dislikePost(Post post, UserModel userModel);
}

class PostsRepositoryImpl implements PostsRepository {
  final _firebaseManager = GetIt.I.get<FirebaseManager>();

  @override
  Future<List<Post>> getPosts(UserModel userModel) {
    return _firebaseManager.getPosts(userModel);
  }

  @override
  Future<bool> addPost(String title, String content) {
    return _firebaseManager.addPost(title, content);
  }

  @override
  Future<bool> deletePost(String id) {
    return _firebaseManager.deletePost(id);
  }

  @override
  Future<bool> likePost(Post post, UserModel userModel) {
    return _firebaseManager.likePost(post, userModel);
  }

  @override
  Future<bool> dislikePost(Post post, UserModel userModel) {
    return _firebaseManager.dislikePost(post, userModel);
  }
}
