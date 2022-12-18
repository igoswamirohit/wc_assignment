import 'dart:convert';

UserModel notificationsFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String notificationsToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    required this.name,
    required this.city,
    required this.profession,
    required this.email,
    this.photo,
  });

  final String? id;
  final String name;
  final String city;
  final String profession;
  final String email;
  final String? photo;

  UserModel copyWith({
    String? id,
    String? name,
    String? city,
    String? profession,
    String? email,
    String? photo,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        city: city ?? this.city,
        profession: profession ?? this.profession,
        email: email ?? this.email,
        photo: photo ?? this.photo,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        city: json["city"],
        profession: json["profession"],
        email: json["email"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city,
        "profession": profession,
        "email": email,
        "photo": photo,
      };
}
