import '../../../model/user_model.dart';

abstract class SignUpEvent {}

class SignUp extends SignUpEvent {
  SignUp(this.userModel);
  final UserModel userModel;
}
