import 'package:integration_test_example_app/src/model/error_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class SignOutSuccess extends HomeState {}

class SignOutFailed extends HomeState {
  SignOutFailed(this.error);
  final ErrorModel error;
}

class UserDeleteSuccess extends HomeState {}

class UserDeleteFailed extends HomeState {
  UserDeleteFailed(this.error);
  final ErrorModel error;
}
