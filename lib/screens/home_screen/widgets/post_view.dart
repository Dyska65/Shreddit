import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/network/models/post.dart';
import 'package:share/share.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/screens/home_screen/home_screen.dart';
import 'package:shreddit/screens/home_screen/home_screen_bloc.dart';
import 'package:shreddit/utils.dart';

class HomeScreenPost extends StatefulWidget {
  const HomeScreenPost(this.post, this.bloc, {Key? key}) : super(key: key);
  final Post post;
  final HomeScreenBloc bloc;

  @override
  State<HomeScreenPost> createState() => _HomeScreenPostState();
}

class _HomeScreenPostState extends State<HomeScreenPost> {
  late final HomeScreenBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF312A2A),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.post.userName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: AppColor.white, fontSize: 12),
              ),
              IconButton(
                onPressed: () {
                  _showMyDialog(context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 36, 12, 12),
                ),
              )
            ],
          ),
          Text(
            widget.post.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Text(
            widget.post.content,
            style: TextStyle(color: AppColor.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  widget.post.userReaction == UserReaction.like
                      ? IconButton(
                          splashRadius: 1,
                          onPressed: () {},
                          icon: Icon(
                            Icons.thumb_up,
                            color: AppColor.white,
                          ),
                        )
                      : IconButton(
                          splashRadius: 1,
                          onPressed: () async {
                            bool resLike = await bloc.likePost(widget.post);
                          },
                          icon: const Icon(Icons.thumb_up)),
                  Text(widget.post.likesDiff.toString(),
                      style: TextStyle(color: AppColor.white)),
                  widget.post.userReaction == UserReaction.dislike
                      ? IconButton(
                          splashRadius: 1,
                          onPressed: () {},
                          icon: Icon(
                            Icons.thumb_down,
                            color: AppColor.white,
                          ),
                        )
                      : IconButton(
                          splashRadius: 1,
                          onPressed: () async {
                            bool resDislike =
                                await bloc.dislikePost(widget.post);
                          },
                          icon: const Icon(Icons.thumb_down),
                        ),
                ],
              ),
              TextButton.icon(
                onPressed: _onShare,
                style: TextButton.styleFrom(primary: const Color(0xFFBABABA)),
                icon: const Icon(Icons.share),
                label: Text(
                  tr("share"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onShare() {
    Share.share(
      widget.post.content,
      subject: widget.post.title,
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr("deletePost")),
          actions: <Widget>[
            TextButton(
              child: Text(tr("no")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(tr("yes")),
              onPressed: () async {
                String snackbarMessage = '';
                bool result = await bloc.deletePost(widget.post.id);
                snackbarMessage = result
                    ? snackbarMessage = tr("deleteSuccess")
                    : tr("deleteError");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(snackbarMessage: snackbarMessage),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
