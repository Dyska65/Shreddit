import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/screens/settings_screen/settings_screen_bloc.dart';
import 'package:shreddit/screens/welcome_screen/welcome_screen.dart';
import 'package:shreddit/utils.dart';
import 'package:shreddit/widgets/bottom_bar.dart';
import 'package:package_info/package_info.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final bloc = SettingsScreenBloc();
  ValueNotifier<bool> buttonPermissionNotifier = ValueNotifier(false);

  Future<String> getVersionBuild() async {
    var packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    return versionName;
  }

  @override
  void initState() {
    super.initState();
    bloc.checkPermisionNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(tr('settings')),
          backgroundColor: AppColor.thunderColor,
        ),
        backgroundColor: AppColor.thunderColor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<String>(
            future: getVersionBuild(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                String language = context.locale.languageCode;
                bloc.changeLanguage(languageCodeToLanguage(language));
                return Stack(
                  children: [
                    StreamBuilder(
                      stream: bloc.isLoadingStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: AppColor.black,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColor.white,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    listOfSettings(snapshot.data!)
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
        bottomNavigationBar: const BottomBar(2));
  }

  Widget chooseLanguage(Language dropdownValue) {
    return DropdownButton<Language>(
      style: TextStyle(color: AppColor.white),
      dropdownColor: AppColor.black,
      borderRadius: BorderRadius.circular(10),
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: (Language? newValue) {
        dropdownValue = newValue!;
        if (newValue == Language.english) {
          context.setLocale(const Locale('en', 'US'));
        }
        if (newValue == Language.russian) {
          context.setLocale(const Locale('ru', 'RU'));
        }
        bloc.changeLanguage(dropdownValue);
      },
      items: Language.values.map<DropdownMenuItem<Language>>(
        (Language value) {
          return DropdownMenuItem<Language>(
            value: value,
            child: Text(tr(value.name)),
          );
        },
      ).toList(),
    );
  }

  Widget listOfSettings(String version) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColor.black),
          ),
          tileColor: AppColor.black,
          onTap: () {},
          leading: Icon(Icons.language, color: AppColor.white),
          title: Text(
            tr("language"),
            style: TextStyle(color: AppColor.white),
          ),
          trailing: StreamBuilder<Language>(
            stream: bloc.languageStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return chooseLanguage(snapshot.data!);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tr("about"),
            textAlign: TextAlign.start,
            style: TextStyle(color: AppColor.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColor.black),
            ),
            tileColor: AppColor.black,
            onTap: () {},
            leading: Icon(Icons.warning, color: AppColor.white),
            title: Text(
              tr("terms"),
              style: TextStyle(color: AppColor.white),
            ),
            trailing: Icon(Icons.arrow_forward, color: AppColor.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColor.black),
            ),
            tileColor: AppColor.black,
            onTap: () {},
            leading: Icon(Icons.security, color: AppColor.white),
            title: Text(
              tr("policy"),
              style: TextStyle(color: AppColor.white),
            ),
            trailing: Icon(Icons.arrow_forward, color: AppColor.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColor.black),
            ),
            tileColor: AppColor.black,
            onTap: () {},
            leading: Icon(Icons.notifications, color: AppColor.white),
            title: Text(
              tr("notify"),
              style: TextStyle(color: AppColor.white),
            ),
            trailing: StreamBuilder<bool>(
              stream: bloc.permissionNotificationStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  buttonPermissionNotifier.value = snapshot.data!;
                  return ValueListenableBuilder<bool>(
                    valueListenable: buttonPermissionNotifier,
                    builder: (context, value, child) {
                      return checkedBox();
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                tr("infoBuild") + version,
                textAlign: TextAlign.end,
                style: TextStyle(color: AppColor.white),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            bool result = await bloc.logOut();
            if (result == true) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr("errorLogOut")),
                  backgroundColor: AppColor.red,
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: AppColor.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 25, color: AppColor.white),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  tr("logOut"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColor.white),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget checkedBox() {
    return GestureDetector(
      onTap: () {
        buttonPermissionNotifier.value = !buttonPermissionNotifier.value;
        buttonPermissionNotifier.value
            ? bloc.userSubscribe()
            : bloc.userUnsubscribe();
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: AppColor.white)),
        child: Icon(
          Icons.done,
          color: buttonPermissionNotifier.value
              ? AppColor.white
              : Colors.transparent,
        ),
      ),
    );
  }
}
