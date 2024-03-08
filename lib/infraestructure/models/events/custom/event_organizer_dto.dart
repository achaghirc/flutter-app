import 'package:my_app/infraestructure/models/events/event_dto.dart';

class EventOrganizerDTO {

  List<EventDTO> finished;
  List<EventDTO> active;

  EventOrganizerDTO({
    required this.finished,
    required this.active,
  });


  factory EventOrganizerDTO.fromJson(Map<String, dynamic> json) => EventOrganizerDTO(
    finished: json["finished"] != null ? List<EventDTO>.from(json["finished"].map((event) => EventDTO.fromJson(event))) : List.empty(),
    active: json["active"] != null ? List<EventDTO>.from(json["active"].map((event) => EventDTO.fromJson(event))) : List.empty()
  );

  Map<String, dynamic> toJson() => {
    "finished": finished,
    "active": active
  };
}