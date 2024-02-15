

import 'package:my_app/infraestructure/models/tickets/tickets_dto.dart';

class TicketsGroupedDTO{

  int amount;
  List<TicketsDTO> tickets;

  TicketsGroupedDTO({
    required this.amount,
    required this.tickets
  });


  factory TicketsGroupedDTO.fromJson(Map<String, dynamic> json) => TicketsGroupedDTO(
    amount: json["amount"] ?? 0, 
    tickets:json["tickets"] == null ? List.empty() : List<TicketsDTO>.from(json["tickets"].map((x) => TicketsDTO.fromJson(x))), 
  );



}