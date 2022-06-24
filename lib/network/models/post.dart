import 'package:shreddit/utils.dart';

class Post {
  String id;
  String userName;
  String title;
  String content;
  int likesCount;
  int dislikeCount;
  int publicationTime;
  UserReaction userReaction;

  int get likesDiff => likesCount - dislikeCount;
  Post(this.id, this.userName, this.title, this.content, this.likesCount,
      this.dislikeCount, this.publicationTime, this.userReaction);
}
