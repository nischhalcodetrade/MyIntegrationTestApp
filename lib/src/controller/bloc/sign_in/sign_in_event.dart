import 'package:integration_test_example_app/src/model/sign_in_model.dart';

abstract class SignInEvent {}

class SignIn extends SignInEvent {
  SignIn(this.signInModel);
  final SignInModel signInModel;
}
