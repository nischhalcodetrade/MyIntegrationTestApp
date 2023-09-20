class UserModel {
  UserModel({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.userName,
    required this.password,
    required this.gender,
  });
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String userName;
  final String password;
  final Gender gender;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob.toString(),
        'userName': userName,
        'password': password,
        'gender': gender == Gender.male ? 'male' : 'female',
      };
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      dob: DateTime.parse(json['dob']),
      userName: json['userName'],
      password: json['password'],
      gender: json['gender'] == 'male' ? Gender.male : Gender.female);
}

enum Gender { male, female }
