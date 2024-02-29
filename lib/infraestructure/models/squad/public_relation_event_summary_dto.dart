import 'dart:convert';

PublicRelationEventSummaryDTO organizerSquadDtoFromJson(String str) => PublicRelationEventSummaryDTO.fromJson(json.decode(str));

String organizerSquadDtoToJson(PublicRelationEventSummaryDTO data) => json.encode(data.toJson());

class PublicRelationEventSummaryDTO {

  int total;
  int active;

  PublicRelationEventSummaryDTO({
    required this.total,
    required this.active
  });

  factory PublicRelationEventSummaryDTO.fromJson(Map<String,dynamic> json) => PublicRelationEventSummaryDTO(
    total: json["total"] ?? 0,
    active: json["active"] ?? 0
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "active": active
  };
}