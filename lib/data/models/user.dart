part of 'models.dart';

class User {
  final int? userId;
  final int? roleId;
  final String? roleName;
  final String? fullName;

  User({
    this.userId,
    this.roleId,
    this.roleName,
    this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        roleId: json["role_id"],
        roleName: json["role_name"],
        fullName: json["fullname"],
      );
  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "role_id": roleId,
        "role_name": roleName,
        "fullname": fullName,
      };
}
