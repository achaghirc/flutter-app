

import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';

class EventTicketsGroupedDTO{

  int amount;
  List<EventTicketsDTO> tickets;

  EventTicketsGroupedDTO({
    required this.amount,
    required this.tickets
  });


  factory EventTicketsGroupedDTO.fromJson(Map<String, dynamic> json) => EventTicketsGroupedDTO(
    amount: json["amount"] ?? 0, 
    tickets:json["tickets"] == null ? List.empty() : List<EventTicketsDTO>.from(json["tickets"].map((x) => EventTicketsDTO.fromJson(x))), 
  );



}