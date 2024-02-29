import 'dart:convert';

import 'package:my_app/infraestructure/models/organizer/organizer_dto.dart';
import 'package:my_app/infraestructure/models/squad/organizer_squad_dto.dart';
import 'package:my_app/infraestructure/models/squad/public_relation_event_summary_dto.dart';

PublicRelationSquadDTO organizerSquadDtoFromJson(String str) => PublicRelationSquadDTO.fromJson(json.decode(str));

String organizerSquadDtoToJson(PublicRelationSquadDTO data) => json.encode(data.toJson());

class PublicRelationSquadDTO {
    
    OrganizerDTO organizer;
    OrganizerSquadDTO organizerSquad;
    PublicRelationEventSummaryDTO eventSummary; 


    PublicRelationSquadDTO({
        required this.organizer,
        required this.organizerSquad,
        required this.eventSummary
    });

    factory PublicRelationSquadDTO.fromJson(Map<String, dynamic> json) => PublicRelationSquadDTO(
      organizer: json["organizer"] != null ? OrganizerDTO.fromJson(json["organizer"]) : OrganizerDTO.fromJson({}),
      organizerSquad: json["organizerSquad"] != null ? OrganizerSquadDTO.fromJson(json["organizerSquad"]) : OrganizerSquadDTO.fromJson({}),
      eventSummary: json["eventSummary"] != null ? PublicRelationEventSummaryDTO.fromJson(json["eventSummary"]) : PublicRelationEventSummaryDTO.fromJson({})
    );

    Map<String, dynamic> toJson() => {
        "organizer": organizer,
        "organizerSquad": organizerSquad,
    };
}
