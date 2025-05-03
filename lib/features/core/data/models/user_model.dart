class UserModel {
  String fullName;
  String password;
  String email;
  String studentId;
  String? profileImageUrl;

  UserModel({
    required this.fullName,
    required this.password,
    required this.email,
    required this.studentId,
  });

  // refactoring
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullname'],
      password: json['password'],
      email: json['email'],
      studentId: json['studentId'],
    );
  }

  //to json
  Map<String, dynamic> toJson() => {
    'fullname':fullName,
    'email':email,
    'password':password,
    'studentId':studentId,
  };  
}
