import 'package:integration_test_example_app/src/model/sign_in_model.dart';

import '../../model/user_model.dart';

abstract class Repo {
  Future<UserModel?> getUserDetails(String userName);
  Future<bool> saveNewUser(UserModel userModel);
  Future<bool> removeUserDetail(String userName);
  Future<SignInModel?> getSignInDetails();
  Future<bool> saveSignInDetails(SignInModel signInModel);
  Future<bool> removeSignInDetails();
}
