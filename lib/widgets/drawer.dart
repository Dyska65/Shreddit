import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/screens/account_screen/account_screen.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/screens/settings_screen/settings_screen.dart';
import 'package:shreddit/screens/settings_screen/settings_screen_bloc.dart';
import 'package:shreddit/screens/welcome_screen/welcome_screen.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  final bloc = SettingsScreenBloc();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: bloc.getUserName(),
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.hasData) {
            return drawer(snapshot.data!, context);
          }
          return const CircularProgressIndicator();
        });
  }

  Widget drawer(UserModel userModel, BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: AppColor.thunderColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: AppColor.white,
                    size: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    userModel.userName,
                    style: TextStyle(color: AppColor.white),
                  ),
                ],
              ),
              Text(
                userModel.email,
                style: TextStyle(color: AppColor.white),
              ),
            ],
          ),
        ),
        ListTile(
          title: Row(
            children: [
              const Icon(Icons.settings),
              const SizedBox(
                width: 10,
              ),
              Text(tr('labelSettings')),
            ],
          ),
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
                (Route<dynamic> route) => false);
          },
        ),
        ListTile(
          title: Row(
            children: [
              const Icon(
                Icons.account_circle_outlined,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(tr('labelAccount')),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            );
          },
        ),
        const Expanded(child: SizedBox.shrink()),
        ListTile(
          title: Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Row(
                    children: [
                      const Icon(Icons.exit_to_app),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        tr('logOut'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            ],
          ),
          onTap: () async {
            bool result = await bloc.logOut();
            if (result == true) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(tr("errorLogOut")),
                backgroundColor: AppColor.red,
              ));
            }
          },
        ),
      ],
    ));
  }
}
