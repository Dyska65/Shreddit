import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/screens/add_post/add_post_bloc.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/screens/home_screen/home_screen.dart';
import 'package:shreddit/widgets/bottom_bar.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var controllerTitle = TextEditingController();
  var controllerContent = TextEditingController();
  final _key = GlobalKey<FormState>();
  var bloc = AddPostBloc();

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double textFieldTextSize = appBarHeight * 0.6 - 13;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxLines = (screenHeight - screenHeight * 0.2 - appBarHeight) / 15;
    int a = maxLines.toInt();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            tr('newPost'),
            style: TextStyle(
              color: AppColor.white,
              fontSize: textFieldTextSize,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              size: appBarHeight * 0.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                bool result = await bloc.addingPost(
                    controllerTitle.text, controllerContent.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(snackbarMessage: tr("successPosted"))),
                );
              },
              child: Text(
                tr("post"),
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: textFieldTextSize,
                ),
              ),
            ),
          ],
          backgroundColor: AppColor.black,
        ),
        backgroundColor: AppColor.thunderColor,
        body: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  style: TextStyle(color: AppColor.grey),
                  controller: controllerTitle,
                  validator: (value) {
                    if (value != null && value.length > 20) {
                      return tr("titleDontEnough");
                    } else {
                      return '';
                    }
                  },
                  cursorColor: AppColor.grey,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: AppColor.grey),
                    hintText: tr("hintTitle"),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  maxLines: a,
                  style: TextStyle(color: AppColor.grey, fontSize: 15),
                  controller: controllerContent,
                  cursorColor: AppColor.grey,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: AppColor.grey),
                    hintText: tr("hintContent"),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(1));
  }
}
