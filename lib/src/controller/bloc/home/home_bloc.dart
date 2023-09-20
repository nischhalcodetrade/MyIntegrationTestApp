import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_event.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_state.dart';
import 'package:integration_test_example_app/src/controller/repo/repo.dart';
import 'package:integration_test_example_app/src/model/error_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Repo repo;
  HomeBloc(this.repo) : super(HomeInitial()) {
    on<SignOut>((event, emit) async {
      bool isRemoved = await repo.removeSignInDetails();
      if (isRemoved) {
        emit(SignOutSuccess());
      } else {
        emit(SignOutFailed(const ErrorModel(
            title: 'SignOut Failed', description: 'Something went wrong')));
      }
    });
    on<DeleteUser>(
      (event, emit) async {
        bool isUserDeleted = await repo.removeUserDetail(event.userName);
        if (isUserDeleted) {
          emit(UserDeleteSuccess());
          add(SignOut());
        } else {
          emit(UserDeleteFailed(const ErrorModel(
              title: 'Delete User',
              description: 'Unable to delete user record')));
        }
      },
    );
  }
}
