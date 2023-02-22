// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.id,
    required this.name,
    required this.birthdate,
    required this.aboutMe,
    required this.section,
  });

  int? id;
  String? name;
  DateTime? birthdate;
  String? aboutMe;
  String? section;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    name: json["name"],
    birthdate: json["birthdate"],
    aboutMe: json["aboutMe"],
    section: json["section"],
  );

  Map<String, dynamic> toJson() => {
    "id":id,
    "name": name,
    "birthdate": birthdate,
    "aboutMe": aboutMe,
    "section": section,
  };
}
