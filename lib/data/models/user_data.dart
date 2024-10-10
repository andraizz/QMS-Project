part of 'models.dart';

class UserData {
  final String? fullName;
  final String? username;
  final String? phone;
  final String? email;

  UserData({
    this.fullName,
    this.username,
    this.phone,
    this.email
  });

   factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        fullName: json["fullname"],
        username: json["username"],
        phone: json["phone"],
        email: json["email"],
      );
}