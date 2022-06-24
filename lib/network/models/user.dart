import 'dart:convert';
import 'package:shreddit/utils.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel(
      {required this.gender,
      required this.idUser,
      required this.email,
      required this.userName,
      required this.likedPost,
      required this.dislikedPost});

  Gender gender;
  String idUser;
  String email;
  String userName;
  List likedPost;
  List dislikedPost;

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      UserModel(
          gender: stringToGender(json["gender"]),
          idUser: json["idUser"],
          email: json["email"],
          userName: json["userName"],
          likedPost: json["likedPost"].map((x) => x).toList(),
          dislikedPost: json["dislikedPost"].map((x) => x).toList());

  Map<String, dynamic> toJson() => {
        "gender": genderToString(gender),
        "idUser": idUser,
        "email": email,
        "userName": userName,
        "likedPost": likedPost.map((x) => x).toList(),
        "dislikedPost": dislikedPost.map((x) => x).toList()
      };
}
