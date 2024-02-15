
import 'dart:convert';

import 'package:my_app/infraestructure/models/authentication/user_info_dto.dart';


JwtAuthenticationResponseDTO jwtAuthenticationResponseDTOFromJson(String str) => JwtAuthenticationResponseDTO.fromJson(json.decode(str));

String jwtAuthenticationResponseDTOToJson(JwtAuthenticationResponseDTO data) => json.encode(data.toJson());


class JwtAuthenticationResponseDTO {

    String status;
    String token;
    UserInfoDTO user;

  JwtAuthenticationResponseDTO({
    required this.status,
    required this.token,
    required this.user
  });


  factory JwtAuthenticationResponseDTO.fromJson(Map<String, dynamic> json) => JwtAuthenticationResponseDTO(
      status: json["status"],
      token: json["token"] ?? '',
      user: UserInfoDTO.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
      "status": status,
      "token": token,
      "user": user,
  };   


}