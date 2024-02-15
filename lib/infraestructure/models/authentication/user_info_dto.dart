import 'dart:convert';

UserInfoDTO userDTOFromJson(String str) => UserInfoDTO.fromJson(json.decode(str));

String userDTOToJson(UserInfoDTO data) => json.encode(data.toJson());


class UserInfoDTO {

  String id;
  String personEmail;
  String personName;
  String roleCode;
  String roleName;
  List<dynamic> organizerId;
  String username;


  UserInfoDTO({
    required this.id,
    required this.personEmail,
    required this.personName,
    required this.roleCode,
    required this.roleName,
    required this.organizerId,
    required this.username
  });


  factory UserInfoDTO.fromJson(Map<String, dynamic> json) => UserInfoDTO(
    id: json["id"] ?? '',
    personEmail: json["personEmail"] ?? '',
    personName : json["personName"] ?? '',
    roleCode : json["roleCode"] ?? '',
    roleName : json["roleName"] ?? '',
    organizerId : json["organizerId"] ?? List.empty(),
    username : json["username"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "personEmail":personEmail,
    "persoName":personName,
    "roleCode":roleCode,
    "roleName":roleName,
    "organizerId": organizerId,
  };

}