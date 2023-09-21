abstract class HomeEvent {}

class SignOut extends HomeEvent {
  SignOut(this.userName);
  final String userName;
}

class DeleteUser extends HomeEvent {
  DeleteUser(this.userName);
  final String userName;
}
