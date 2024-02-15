import 'package:my_app/infraestructure/models/tickets/event_tickets_details_dart.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/event_tickets_query_params.dart';

abstract class EventTicketsRepository {

  Future<List<EventTicketsDTO>> search(EventTicketsQueryParams searchParams);

  Future<EventTicketsDTO> create(EventTicketsDTO eventTicket);
  Future<EventTicketsDTO> edit(EventTicketsDTO ticketsType);
  Future<EventTicketsDetailsDTO> dataResume(int eventId, int eventTicketId);
  Future<EventTicketsDetailsDTO> eventTicketsDataResume(int eventId);


}