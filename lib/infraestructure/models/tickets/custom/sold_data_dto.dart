import 'package:my_app/infraestructure/models/tickets/custom/event_public_relation_data_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/tickets_search_count_dto.dart';

class SoldDataDTO {

    EventPublicRelationDataDTO data;
    List<TicketSearchCountDTO> ticketsSold;


    SoldDataDTO({
      required this.data,
      required this.ticketsSold
    });


    factory SoldDataDTO.fromJson(Map<String, dynamic> json) => SoldDataDTO(
      data: json['data'] != null ? EventPublicRelationDataDTO.fromJson(json['data']) : EventPublicRelationDataDTO.fromJson({}),
      ticketsSold: json['ticketsSold'] != null ? List<TicketSearchCountDTO>.from(json['ticketsSold'].map((ticket) => TicketSearchCountDTO.fromJson(ticket))) : List.empty(),
    );


    Map<String, dynamic> toJson() => {
      "data" : data,
      "ticketsSold": ticketsSold,
    };

}