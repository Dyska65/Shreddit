import 'package:flutter/material.dart';
import 'package:shreddit/screens/home_screen/home_screen.dart';
import 'package:shreddit/screens/splash_screen/splash_screen_bloc.dart';
import 'package:shreddit/screens/welcome_screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var bloc = SplashScreenBloc();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Future.delayed(
        const Duration(seconds: 3),
        () {
          return bloc.isAuthorized();
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return const HomeScreen();
        }
        if (snapshot.hasData && !snapshot.data!) {
          return const WelcomeScreen();
        }
        return const Scaffold(
          body: Center(
            child: Text(
              'SHREDDIT',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40),
            ),
          ),
        );
      },
    );
  }
}
