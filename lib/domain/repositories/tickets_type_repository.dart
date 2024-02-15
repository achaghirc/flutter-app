import 'package:my_app/infraestructure/models/tickets/type/tickets_type_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/search_tickets_type_params.dart';

abstract class TicketsTypeRepository {

  Future<List<TicketsTypeDTO>> search(TicketsTypeQueryParams searchParams);

  Future<TicketsTypeDTO> create(TicketsTypeDTO ticketsType);


}