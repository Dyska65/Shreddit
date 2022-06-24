import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shreddit/injector/usecases/delete_post_usecase.dart';
import 'package:shreddit/injector/usecases/dislike_usecase.dart';
import 'package:shreddit/injector/usecases/get_firebase_msg_usecase.dart';
import 'package:shreddit/injector/usecases/get_posts_usecase.dart';
import 'package:shreddit/injector/usecases/get_user_localdb_usecase.dart';
import 'package:shreddit/injector/usecases/like_usecase.dart';
import 'package:shreddit/network/models/post.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/utils.dart';

class HomeScreenBloc {
  final _listPostsSubject = BehaviorSubject<List<Post>>();
  Stream<List<Post>> get listPostsStream => _listPostsSubject.stream;
  late List<Post> allPosts;
  bool isLikeActive = false;
  bool isDislikeActive = false;

  void getData() async {
    allPosts = await GetIt.I.get<GetPostsUsecase>().execute();
    _listPostsSubject.add(allPosts);
  }

  void connectionToFirebaseMessaging() {
    GetIt.I.get<GetFirebaseMessagingUsecase>().execute();
  }

  Future<UserModel?> getUser() async {
    final UserModel? user =
        await GetIt.I.get<GetUserLocalDBUsecase>().execute();
    return user;
  }

  Future<bool> deletePost(String id) async {
    final bool isDelete = await GetIt.I.get<DeletePostsUsecase>().execute(id);
    return isDelete;
  }

  Future<bool> likePost(Post post) async {
    if (isLikeActive == false) {
      isLikeActive = true;
      if (post.userReaction == UserReaction.dislike) {
        post.dislikeCount--;
      }
      post.likesCount++;
      for (var element in allPosts) {
        if (element.id == post.id) {
          element.userReaction = UserReaction.like;
        }
      }
      _listPostsSubject.add(allPosts);
      final bool isLike = await GetIt.I.get<LikeUsecase>().execute(post);
      isLikeActive = false;
      return isLike;
    } else {
      return false;
    }
  }

  Future<bool> dislikePost(Post post) async {
    if (isDislikeActive == false) {
      isDislikeActive = true;
      if (post.userReaction == UserReaction.like) {
        post.likesCount--;
      }
      post.dislikeCount++;
      for (var element in allPosts) {
        if (element.id == post.id) {
          element.userReaction = UserReaction.dislike;
        }
      }
      _listPostsSubject.add(allPosts);

      final bool isDislike = await GetIt.I.get<DislikeUsecase>().execute(post);

      isDislikeActive = false;
      return isDislike;
    } else {
      return false;
    }
  }

  void dispose() {
    _listPostsSubject.close();
  }
}
