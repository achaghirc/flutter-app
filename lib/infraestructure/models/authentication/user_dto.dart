import 'package:my_app/infraestructure/models/authentication/person_dto.dart';
import 'package:my_app/infraestructure/models/authentication/role_dto.dart';
import 'package:my_app/infraestructure/models/image/imageDTO.dart';

class UserDTO {

  int? id;
  String username;
  PersonDTO person;
  RoleDTO role;
  ImageDTO? image;

  UserDTO({
    required this.id,
    required this.username,
    required this.person,
    required this.role,
    this.image
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    id: json["id"],
    username: json["username"] ?? '',
    person: json["person"] != null ? PersonDTO.fromJson(json["person"]) : PersonDTO.fromJson({}),
    role: json["role"] != null ? RoleDTO.fromJson(json["role"]) : RoleDTO.fromJson({}),
    image: json["image"] != null ? ImageDTO.fromJson(json["image"]) : null
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "person": person,
    "role": role,
  };
}