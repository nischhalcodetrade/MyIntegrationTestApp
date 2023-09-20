import 'package:integration_test_example_app/src/model/error_model.dart';
import 'package:integration_test_example_app/src/model/user_model.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class AutoSignInSuccess extends SplashState {
  AutoSignInSuccess(this.user);
  final UserModel user;
}

class AutoSignInFailed extends SplashState {
  AutoSignInFailed(this.error);
  final ErrorModel error;
}
