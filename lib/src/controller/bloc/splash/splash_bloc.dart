import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/splash/splash_event.dart';
import 'package:integration_test_example_app/src/controller/bloc/splash/splash_state.dart';
import 'package:integration_test_example_app/src/controller/repo/repo.dart';
import 'package:integration_test_example_app/src/model/error_model.dart';
import 'package:integration_test_example_app/src/model/sign_in_model.dart';
import 'package:integration_test_example_app/src/model/user_model.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final Repo repo;
  SplashBloc(this.repo) : super(SplashInitial()) {
    on<AutoSignIn>((event, emit) async {
      SignInModel? signCredentials = await repo.getSignInDetails();
      if (signCredentials != null) {
        UserModel? user = await repo.getUserDetails(signCredentials.userName);
        if (user != null) {
          if (user.password == signCredentials.password) {
            emit(AutoSignInSuccess(user));
          } else {
            emit(AutoSignInFailed(const ErrorModel(
                title: 'Unable to Auto SignIn',
                description: 'Incorrect Password')));
          }
        }
      } else {
        emit(AutoSignInFailed(const ErrorModel(
            title: 'Unable to Auto SignIn ',
            description: 'No Credentials found')));
      }
    });
  }
}
