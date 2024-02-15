import 'dart:convert';


RoleDTO roleDTOFromJson(String str) => RoleDTO.fromJson(json.decode(str));

String roleDTOToJson(RoleDTO data) => json.encode(data.toJson());

class RoleDTO {
  int id;
  String name;
  String code;


  RoleDTO({
    required this.id,
    required this.name,
    required this.code
  });

    factory RoleDTO.fromJson(Map<String, dynamic> json) => RoleDTO(
      id: json["id"],
      name: json["name"],
      code: json["code"],
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "name": name,
      "code": code,
  };

}