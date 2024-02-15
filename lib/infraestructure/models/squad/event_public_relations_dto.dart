// To parse this JSON data, do
//
//     final organizerSquadDto = organizerSquadDtoFromJson(jsonString);

import 'dart:convert';

EventPublicRelationsDTO eventPublicRelationsDtoFromJson(String str) => EventPublicRelationsDTO.fromJson(json.decode(str));

String eventPublicRelationsDtoToJson(EventPublicRelationsDTO data) => json.encode(data.toJson());

class EventPublicRelationsDTO {
    int id;
    String rrppCode;
    int userId;
    String userUsername;
    String userPersonName;
    int eventId;
    String eventName;
    int eventOrganizerId;

    EventPublicRelationsDTO({
      required this.id,
      required this.rrppCode,
      required this.userId,
      required this.userUsername,
      required this.userPersonName,
      required this.eventId,
      required this.eventName,
      required this.eventOrganizerId,
    });

    factory EventPublicRelationsDTO.fromJson(Map<String, dynamic> json) => EventPublicRelationsDTO(
        id: json["id"] ?? '',
        rrppCode: json["rrppCode"] ?? 'DEFAULTCODE',
        userId: json["userId"] ?? '',
        userUsername: json["userUsername"] ?? '',
        userPersonName: json["userPersonName"] ?? '',
        eventId: json["eventId"] ?? '',
        eventName: json["eventName"] ?? '',
        eventOrganizerId: json["eventOrganizerId"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "userUsername": userUsername,
        "userPersonName": userPersonName,
        "userPersonLastName": eventId,
        "userRoleCode": eventName,
        "organizerId": eventOrganizerId,
    };
}
