class SignInModel {
  SignInModel({
    required this.userName,
    required this.password,
    required this.isRememberMe,
    required this.alreadySignedIn,
  });

  final String userName;
  final String password;
  final bool isRememberMe;
  final bool alreadySignedIn;

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'password': password,
        'alreadySignedIn': alreadySignedIn.toString(),
        'isRememberMe': isRememberMe.toString(),
      };

  factory SignInModel.formJson(Map<String, dynamic> json) => SignInModel(
      userName: json['userName'],
      password: json['password'],
      alreadySignedIn: json['alreadySignedIn'] == 'false' ? false : true,
      isRememberMe: json['isRememberMe'] == 'false' ? false : true);
}
