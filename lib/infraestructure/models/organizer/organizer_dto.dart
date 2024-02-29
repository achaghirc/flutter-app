import 'dart:convert';

OrganizerDTO organizerSquadDtoFromJson(String str) => OrganizerDTO.fromJson(json.decode(str));

String organizerSquadDtoToJson(OrganizerDTO data) => json.encode(data.toJson());

class OrganizerDTO {
    
    int id;
    String name;
    String cif;
    int ubicationId;
    int maxCapacity;
    int totalMembers;

    OrganizerDTO({
      required this.id,
      required this.name,
      required this.cif,
      required this.ubicationId,
      required this.maxCapacity,
      required this.totalMembers,
    });

    factory OrganizerDTO.fromJson(Map<String, dynamic> json) => OrganizerDTO(
      id: json["id"],
      name: json["name"],
      cif: json["cif"],
      ubicationId: json["ubicationId"],
      maxCapacity: json["maxCapacity"],
      totalMembers: json["totalMembers"],
    );

    Map<String, dynamic> toJson() => {        
        "id": id,
        "name": name,
        "cif": cif,
        "ubicationId": ubicationId,
        "maxCapacity": maxCapacity,
        "totalMembers": totalMembers,
    };
}
