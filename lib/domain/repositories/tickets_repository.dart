import 'package:my_app/infraestructure/models/tickets/custom/sold_data_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/tickets_grouped_dto.dart';
import 'package:my_app/infraestructure/models/tickets/tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/tickets_query_params.dart';

abstract class TicketsRepository {

  Future<bool> create(List<TicketsDTO> ticket);
  Future<List<TicketsDTO>> search(TicketsQueryParams searchParams);
  Future<List<TicketsGroupedDTO>> searchGrouped(TicketsQueryParams searchParams);
  Future<SoldDataDTO> searchTicketsSold(TicketsQueryParams searchParams);

}