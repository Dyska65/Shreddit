import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/screens/log_in_screen/log_in_screen.dart';
import 'package:shreddit/screens/registration_screen/registration_screen.dart';
import 'package:shreddit/widgets/button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;

    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widthScreen * 0.1, vertical: widthScreen * 0.3),
        child: Column(
          children: [
            const Icon(
              Icons.ac_unit,
              size: 100,
            ),
            SizedBox(
              height: heightScreen * 0.15,
            ),
            Button(
              text: tr("welcomeLogIn"),
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LogInScreen()));
              },
            ),
            SizedBox(
              height: heightScreen * 0.05,
            ),
            Button(
              text: tr("welcomeSignUp"),
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
