import 'package:my_app/infraestructure/models/events/custom/event_code_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';

class EventDataDTO {

  List<EventDTO> allEvents;
  List<EventCodeDTO> assignedEvents;


  EventDataDTO({
    required this.allEvents,
    required this.assignedEvents,
  });

  factory EventDataDTO.fromJson(Map<String, dynamic> json) => EventDataDTO(
    allEvents: json["allEvents"] != null ? List<EventDTO>.from(json["allEvents"].map((event) => EventDTO.fromJson(event))) : List.empty(), 
    assignedEvents: json["assignedEvents"] != null ? List<EventCodeDTO>.from(json["assignedEvents"].map((event) => EventCodeDTO.fromJson(event))) : List.empty(),
  );


  Map<String, dynamic> toJson() => {
    "allEvents": allEvents,
    "assignedEvents": assignedEvents,
  };
}