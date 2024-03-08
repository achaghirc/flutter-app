

import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';

class OpenEventDTO {

  EventDTO event;
  List<EventTicketsDTO> tickets;

  OpenEventDTO({
    required this.event,
    required this.tickets
  });

  factory OpenEventDTO.fromJson(Map<String, dynamic> json) => OpenEventDTO(
    event: json["event"] != null ? EventDTO.fromJson(json["event"]): EventDTO.fromJson({}), 
    tickets: json["eventTickets"] != null ? List.from(json["eventTickets"].map((ticket) => EventTicketsDTO.fromJson(ticket))) : List.empty()
  );

}