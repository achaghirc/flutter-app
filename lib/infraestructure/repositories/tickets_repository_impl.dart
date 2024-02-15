import 'dart:convert';
import 'package:my_app/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/domain/repositories/tickets_repository.dart';
import 'package:my_app/infraestructure/models/tickets/custom/sold_data_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/tickets_grouped_dto.dart';
import 'package:my_app/infraestructure/models/tickets/tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/tickets_query_params.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.url();
String basicAuth = '';

class TicketsRepositoryImpl extends BasicService implements TicketsRepository {
  TicketsRepositoryImpl(super.session);

  @override
  Future<bool> create(List<TicketsDTO> tickets) async {
    Response res = await postCall(
      baseURL, 
      '/api/tickets/create',
      body: jsonEncode(tickets)
    );
    if(res.statusCode == 200) {
      return true;
    } else {
      throw ErrorDescription('Create ticket status not 200. Status: ${res.statusCode}');
    }
  }

  @override
  Future<List<TicketsDTO>> search(TicketsQueryParams searchParams) async{
    Response res = await getCall(
      baseURL, 
      '/api/tickets/search',
      queryParameters: {
        "userId": '${searchParams.userId!}'
      }
    );
    if(res.statusCode == 200) {
      Iterable tickets = json.decode(utf8.decode(res.bodyBytes));
      return List<TicketsDTO>.from(tickets.map((ticket) => TicketsDTO.fromJson(ticket)));
    } else {
      return List.empty();
    }
  }

  @override
  Future<SoldDataDTO> searchTicketsSold(TicketsQueryParams searchParams) async{
    Response res = await getCall(
      baseURL, 
      '/api/tickets/searchTicketsSold',
      queryParameters: {
        "rrppCode": searchParams.rrppCode!,
        "eventId": '${searchParams.eventId!}'
      }
    );
    if(res.statusCode == 200) {
      return SoldDataDTO.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    } else {
      return Future.error(Exception('Status code:  ${res.statusCode}'));
    }
  }

  @override
  Future<List<TicketsGroupedDTO>> searchGrouped(TicketsQueryParams searchParams) async{
     Response res = await getCall(
      baseURL, 
      '/api/tickets/grouped',
      queryParameters: {
        "userId": '${searchParams.userId!}'
      }
    );
    if(res.statusCode == 200) {
      Iterable tickets = json.decode(utf8.decode(res.bodyBytes));
      return List<TicketsGroupedDTO>.from(tickets.map((ticket) => TicketsGroupedDTO.fromJson(ticket)));
    } else {
      return List.empty();
    }
  }
  
}