import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/screens/home_screen/home_screen.dart';
import 'package:shreddit/screens/registration_screen/registration_screen_bloc.dart';
import 'package:shreddit/utils.dart';
import 'package:shreddit/widgets/button.dart';
import 'package:shreddit/widgets/input_form.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var controllerName = TextEditingController();
  var controllerEmail = TextEditingController();
  var controllerPassword = TextEditingController();
  final _key = GlobalKey<FormState>();
  final bloc = RegistrationScreenBloc();
  Gender gender = Gender.man;
  String textValueGender = tr('man');

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.1),
            child: Center(
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColor.black,
                            ),
                          ),
                          Text(
                            tr("titleRegistration"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: heightScreen * 0.1,
                      ),
                      InputForm(
                        controllerName,
                        hintText: tr("hintName"),
                        validation: Utils.validateName,
                      ),
                      InputForm(
                        controllerEmail,
                        hintText: tr("hintEmail"),
                        validation: Utils.validateEmail,
                      ),
                      InputForm(
                        controllerPassword,
                        hintText: tr("hintPassword"),
                        validation: Utils.validatePassword,
                      ),
                      StreamBuilder<Gender>(
                        stream: bloc.genderStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            bloc.changeGender(Gender.man);
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            gender = snapshot.data!;
                            return chooseGender(snapshot.data!);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      Builder(
                        builder: (context) => Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Button(
                            text: tr("hintAccount"),
                            onClick: () {
                              onRegistration(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onRegistration(BuildContext context) async {
    if (_key.currentState!.validate()) {
      AuthorizationResult result = await bloc.register(controllerEmail.text,
          controllerPassword.text, controllerName.text, gender);
      bool isShowedSnackBar = showSnackbar(result, context);
      if (isShowedSnackBar) {
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
        res = tr("errorEmailSignUp");
        break;
      case AuthorizationResult.errorPassword:
        res = tr("errorPasswordSignUp");
        break;
      case AuthorizationResult.errorNetwork:
        res = tr("errorNetworkSignUp");
        break;
      case AuthorizationResult.error:
        res = tr("errorNetworkSignUp");
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

  Widget chooseGender(Gender gender) {
    return DropdownButton<String>(
      style: TextStyle(color: AppColor.black),
      dropdownColor: AppColor.white,
      borderRadius: BorderRadius.circular(10),
      value: textValueGender,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: (String? newValue) {
        if (newValue == tr('man')) {
          gender = Gender.man;
          textValueGender = tr('man');
        } else if (newValue == tr('woman')) {
          gender = Gender.woman;
          textValueGender = tr('woman');
        }
        bloc.changeGender(gender);
      },
      items: <String>[tr('man'), tr('woman')]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
