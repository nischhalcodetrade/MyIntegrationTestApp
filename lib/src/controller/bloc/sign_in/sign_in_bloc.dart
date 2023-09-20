import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_event.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_state.dart';
import 'package:integration_test_example_app/src/controller/repo/repo.dart';
import 'package:integration_test_example_app/src/model/error_model.dart';
import 'package:integration_test_example_app/src/model/user_model.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final Repo repo;
  SignInBloc(this.repo) : super(SignInInitial()) {
    on<SignIn>((event, emit) async {
      UserModel? user = await repo.getUserDetails(event.signInModel.userName);
      if (user != null) {
        if (user.password == event.signInModel.password) {
          if (event.signInModel.isRememberMe) {
            await repo.saveSignInDetails(event.signInModel);
          }
          emit(SignInSuccess(user));
        } else {
          emit(SignInFailed(const ErrorModel(
              title: 'Sign In Failed',
              description: 'Please enter the correct password')));
        }
      } else {
        emit(SignInFailed(const ErrorModel(
            title: 'Sign In Failed', description: 'User not found')));
      }
    });
  }
}
