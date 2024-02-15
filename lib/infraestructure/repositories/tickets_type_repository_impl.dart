import 'dart:convert';
import 'package:my_app/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/domain/repositories/tickets_type_repository.dart';
import 'package:my_app/infraestructure/models/tickets/type/tickets_type_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/search_tickets_type_params.dart';
import 'package:my_app/shared/services/basic_service.dart';


final baseURL = globals.url();
String basicAuth = '';

class TicketsTypeRepositoryImpl extends BasicService implements TicketsTypeRepository {
  TicketsTypeRepositoryImpl(super.session);

  @override
  Future<TicketsTypeDTO> create(TicketsTypeDTO ticketsType) async {
    Response res = await postCall(
      baseURL, 
      '/api/ticketsType/create',
      body: jsonEncode(ticketsType)
    );
    if(res.statusCode == 200) {
      return ticketsTypeDTOFromJson(res.body);
    } else {
      throw ErrorDescription('Create ticket status not 200. Status: ${res.statusCode}');
    }
  }

  @override
  Future<List<TicketsTypeDTO>> search(TicketsTypeQueryParams searchParams) async{
    Response res = await getCall(
      baseURL, 
      '/api/ticketsType/search',
      queryParameters: searchParams.toJson()
    );
    if(res.statusCode == 200) {
      Iterable ticketsType = json.decode(utf8.decode(res.bodyBytes));
      return List<TicketsTypeDTO>.from(ticketsType.map((ticketType) => TicketsTypeDTO.fromJson(ticketType)));
    } else {
      return List.empty();
    }
  }


  
}