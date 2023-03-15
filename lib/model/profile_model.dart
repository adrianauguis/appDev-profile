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
    required this.fb,
    required this.ig,
    required this.git,
    required this.twtr
  });

  int? id;
  String? name;
  DateTime? birthdate;
  String? aboutMe;
  String? section;
  String? fb;
  String? ig;
  String? git;
  String? twtr;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    name: json["name"],
    birthdate: json["birthdate"],
    aboutMe: json["aboutMe"],
    section: json["section"],
    fb: json["fb"],
    ig: json["ig"],
    git: json["git"],
    twtr: json["twtr"],
  );

  Map<String, dynamic> toJson() => {
    "id":id,
    "name": name,
    "birthdate": birthdate,
    "aboutMe": aboutMe,
    "section": section,
    "fb": fb,
    "ig": ig,
    "git": git,
    "twtr": twtr,
  };
}
