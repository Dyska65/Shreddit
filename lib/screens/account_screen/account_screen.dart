import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/screens/account_screen/account_screen_bloc.dart';
import 'package:shreddit/screens/colors.dart';
import 'package:shreddit/utils.dart';
import 'package:shreddit/widgets/bottom_bar.dart';
import 'package:shreddit/widgets/input_form.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var isButtonActive = ValueNotifier<bool>(false);
  final bloc = AccountScreenBloc();
  bool isChangeGender = false;
  bool isChangeName = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: bloc.getUserName(),
      builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
        if (snapshot.hasData) {
          return mainScreenAccount(snapshot.data!);
        }
        return Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColor.black,
            child: const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget mainScreenAccount(UserModel userModel) {
    var _controllerUserName = TextEditingController();
    _controllerUserName.text = userModel.userName;
    Gender _gender = userModel.gender;

    return Scaffold(
        appBar: AppBar(
            title: Text(userModel.userName),
            backgroundColor: AppColor.thunderColor,
            actions: [
              ValueListenableBuilder(
                valueListenable: isButtonActive,
                builder: (context, value, child) {
                  if (value == true) {
                    return TextButton(
                      onPressed: () async {
                        userModel.gender = _gender;
                        userModel.userName = _controllerUserName.text;
                        bool result = await bloc.updateUser(userModel);
                        if (result) {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error'),
                              backgroundColor: AppColor.red,
                            ),
                          );
                        }
                      },
                      child: Text(
                        tr('save'),
                        style: TextStyle(color: AppColor.white),
                      ),
                    );
                  }
                  if (value == false) {
                    return TextButton(
                      onPressed: () {},
                      child: Text(
                        tr('save'),
                        style: TextStyle(color: AppColor.grey),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ]),
        body: Container(
          color: const Color(0xFF312A2A),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle,
                  size: 100,
                  color: AppColor.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: InputForm(
                  _controllerUserName,
                  hintText: userModel.userName,
                  padding: 0,
                  onChanged: (String string) {
                    if (string.isEmpty || string == userModel.userName) {
                      isChangeName = false;
                    } else if (string != userModel.userName) {
                      isChangeName = true;
                    }
                    if (isChangeName || isChangeGender) {
                      isButtonActive.value = true;
                    } else {
                      isButtonActive.value = false;
                    }
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: StreamBuilder<Gender>(
                  stream: bloc.genderStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      _gender = snapshot.data!;
                      return chooseGender(snapshot.data!, userModel);
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar(0));
  }

  Widget chooseGender(Gender gender, UserModel userModel) {
    Gender valueGender = gender;
    return DropdownButton<Gender>(
      style: TextStyle(color: AppColor.black),
      dropdownColor: AppColor.black,
      borderRadius: BorderRadius.circular(10),
      value: valueGender,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: (Gender? newValue) {
        valueGender = newValue!;
        gender = valueGender;
        if (gender != userModel.gender) {
          isChangeGender = true;
        } else {
          isChangeGender = false;
        }
        if (isChangeName || isChangeGender) {
          isButtonActive.value = true;
        } else {
          isButtonActive.value = false;
        }
        bloc.changeGender(gender);
      },
      items: Gender.values.map<DropdownMenuItem<Gender>>((Gender value) {
        return DropdownMenuItem<Gender>(
          value: value,
          child: Text(
            tr(value.name),
            style: TextStyle(color: AppColor.white),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    isButtonActive.dispose();
    super.dispose();
  }
}
