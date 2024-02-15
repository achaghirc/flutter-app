// To parse this JSON data, do
//
//     final organizerSquadDto = organizerSquadDtoFromJson(jsonString);

import 'dart:convert';

OrganizerSquadDTO organizerSquadDtoFromJson(String str) => OrganizerSquadDTO.fromJson(json.decode(str));

String organizerSquadDtoToJson(OrganizerSquadDTO data) => json.encode(data.toJson());

class OrganizerSquadDTO {
    int userId;
    String userUsername;
    String userPersonName;
    String userPersonLastName;
    String userRoleCode;
    int organizerId;
    String organizerName;
    int? organizerTotalMembers;

    OrganizerSquadDTO({
        required this.userId,
        required this.userUsername,
        required this.userPersonName,
        required this.userPersonLastName,
        required this.userRoleCode,
        required this.organizerId,
        required this.organizerName,
        this.organizerTotalMembers
    });

    factory OrganizerSquadDTO.fromJson(Map<String, dynamic> json) => OrganizerSquadDTO(
        userId: json["userId"] ?? '',
        userUsername: json["userUsername"] ?? '',
        userPersonName: json["userPersonName"] ?? '',
        userPersonLastName: json["userPersonLastName"] ?? '',
        userRoleCode: json["userRoleCode"] ?? '',
        organizerId: json["organizerId"] ?? '',
        organizerName: json["organizerName"] ?? '',
        organizerTotalMembers: json["organizerTotalMembers"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "userUsername": userUsername,
        "userPersonName": userPersonName,
        "userPersonLastName": userPersonLastName,
        "userRoleCode": userRoleCode,
        "organizerId": organizerId,
        "organizerName": organizerName,
    };
}
