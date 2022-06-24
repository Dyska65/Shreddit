import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/network/models/post.dart';
import 'package:shreddit/screens/account_screen/account_screen.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/screens/home_screen/home_screen_bloc.dart';
import 'package:shreddit/widgets/bottom_bar.dart';
import 'package:shreddit/screens/home_screen/widgets/post_view.dart';
import 'package:shreddit/widgets/drawer.dart';
import 'package:snack/snack.dart' as snack;

class HomeScreen extends StatefulWidget {
  final String snackbarMessage;
  const HomeScreen({Key? key, this.snackbarMessage = ''}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bloc = HomeScreenBloc();

  @override
  void initState() {
    bloc.getData();
    bloc.connectionToFirebaseMessaging();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _onAfterBuild(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double textFieldTextSize = appBarHeight * 0.6 - 13;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
            height: appBarHeight * 0.6,
            child: TextFormField(
              style: TextStyle(
                color: AppColor.white,
                fontSize: textFieldTextSize,
              ),
              cursorColor: AppColor.white,
              decoration: InputDecoration(
                fillColor: AppColor.black,
                filled: true,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  size: textFieldTextSize,
                  color: AppColor.white,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountScreen()),
                  );
                },
                icon: const Icon(Icons.account_circle_outlined)),
          ],
          backgroundColor: AppColor.thunderColor,
        ),
        drawer: AppDrawer(),
        backgroundColor: AppColor.black,
        body: Center(
          child: StreamBuilder<List<Post>>(
            stream: bloc.listPostsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Text(tr("emptyPosts"));
                } else {
                  return RefreshIndicator(
                    onRefresh: () {
                      bloc.getData();
                      setState(() {});
                      return Future.value(null);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return HomeScreenPost(snapshot.data![index], bloc);
                      },
                    ),
                  );
                }
              } else {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        bottomNavigationBar: const BottomBar(0));
  }

  _onAfterBuild(BuildContext context) {
    if (widget.snackbarMessage.isNotEmpty) {
      var bar = SnackBar(
        content: Text(widget.snackbarMessage),
        backgroundColor: AppColor.green,
      );
      bar.show(context);
    }
    return null;
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
