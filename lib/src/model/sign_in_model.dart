class SignInModel {
  SignInModel(
      {required this.userName,
      required this.password,
      required this.isRememberMe});

  final String userName;
  final String password;
  final bool isRememberMe;

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'password': password,
        'isRememberMe': isRememberMe.toString()
      };

  factory SignInModel.formJson(Map<String, dynamic> json) => SignInModel(
      userName: json['userName'],
      password: json['password'],
      isRememberMe: json['isRememberMe'] == 0 ? false : true);
}
