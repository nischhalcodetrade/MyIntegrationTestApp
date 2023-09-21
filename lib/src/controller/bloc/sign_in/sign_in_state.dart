import 'package:integration_test_example_app/src/model/error_model.dart';
import 'package:integration_test_example_app/src/model/sign_in_model.dart';
import 'package:integration_test_example_app/src/model/user_model.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInSuccess extends SignInState {
  SignInSuccess(this.user);
  final UserModel user;
}

class SignInFailed extends SignInState {
  SignInFailed(this.error);
  final ErrorModel error;
}

class GetSignInCredentialSuccess extends SignInState {
  GetSignInCredentialSuccess(this.signInModel);
  final SignInModel signInModel;
}
