import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/screens/home_screen/home_screen.dart';
import 'package:shreddit/screens/log_in_screen/log_in_screen_bloc.dart';
import 'package:shreddit/utils.dart';
import 'package:shreddit/widgets/button.dart';
import 'package:shreddit/widgets/input_form.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  var controllerEmail = TextEditingController();
  var controllerPassword = TextEditingController();
  final _key = GlobalKey<FormState>();
  var bloc = LogInScreenBloc();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.1),
        child: Center(
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    tr("welcomeLogIn"),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: heightScreen * 0.1,
                  ),
                  InputForm(controllerEmail,
                      validation: Utils.validateEmail,
                      hintText: tr("hintEmail")),
                  InputForm(controllerPassword,
                      validation: Utils.validatePassword,
                      hintText: tr("enterPassword")),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Builder(
                      builder: (context) {
                        return Button(
                          text: tr("welcomeLogIn"),
                          onClick: () {
                            onClickLogIn(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onClickLogIn(BuildContext context) async {
    if (_key.currentState!.validate()) {
      AuthorizationResult result =
          await bloc.logIn(controllerEmail.text, controllerPassword.text);
      if (showSnackbar(result, context)) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (_) => false,
        );
      }
    }
  }

  bool showSnackbar(AuthorizationResult result, BuildContext context) {
    String res = '';
    switch (result) {
      case AuthorizationResult.success:
        res = '';
        break;
      case AuthorizationResult.errorEmail:
        res = tr("errorEmailLogIn");
        break;
      case AuthorizationResult.errorPassword:
        res = tr("errorEmailLogIn");
        break;
      case AuthorizationResult.errorNetwork:
        res = tr("errorNetworkLogIn");
        break;
      case AuthorizationResult.error:
        res = tr("errorNetworkLogIn");
        break;
      default:
        res = '';
        break;
    }
    if (res.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res),
        backgroundColor: AppColor.red,
      ));
    }
    return res.isEmpty;
  }
}
