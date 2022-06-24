import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/utils.dart';

class AuthResult {
  AuthorizationResult result;
  UserModel? value;
  AuthResult({required this.result, required this.value});
}
