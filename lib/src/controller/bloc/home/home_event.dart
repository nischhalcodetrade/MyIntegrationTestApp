abstract class HomeEvent {}

class SignOut extends HomeEvent {
  SignOut();
}

class DeleteUser extends HomeEvent {
  DeleteUser(this.userName);
  final String userName;
}
