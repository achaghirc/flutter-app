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
    allEvents: List<EventDTO>.from(json["allEvents"].map((event) => EventDTO.fromJson(event))), 
    assignedEvents: List<EventCodeDTO>.from(json["assignedEvents"].map((event) => EventCodeDTO.fromJson(event))),
  );


  Map<String, dynamic> toJson() => {
    "allEvents": allEvents,
    "assignedEvents": assignedEvents,
  };
}