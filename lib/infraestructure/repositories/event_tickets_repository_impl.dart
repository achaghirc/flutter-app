import 'dart:convert';
import 'package:my_app/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/domain/repositories/event_tickets_repository.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_details_dart.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/event_tickets_query_params.dart';
import 'package:my_app/shared/services/basic_service.dart';


final baseURL = globals.url();
String basicAuth = '';

class EventTicketsRepositoryImpl extends BasicService implements EventTicketsRepository {
  EventTicketsRepositoryImpl(super.session);

  @override
  Future<EventTicketsDTO> create(EventTicketsDTO ticketsType) async {
    Response res = await postCall(
      baseURL, 
      '/api/eventTickets/create',
      body: jsonEncode(ticketsType)
    );
    if(res.statusCode == 200) {
      return EventTicketsDTO.fromJson(json.decode(res.body));
    } else {
      throw ErrorDescription('Create ticket status not 200. Status: ${res.statusCode}');
    }
  }

  @override
  Future<List<EventTicketsDTO>> search(EventTicketsQueryParams searchParams) async{
    Response res = await getCall(
      baseURL, 
      '/api/eventTickets/search',
      queryParameters: searchParams.toJson()
    );
    if(res.statusCode == 200) {
      Iterable tickets = json.decode(utf8.decode(res.bodyBytes));
      return List<EventTicketsDTO>.from(tickets.map((ticket) => EventTicketsDTO.fromJson(ticket)));
    } else {
      return List.empty();
    }
  }

  @override
  Future<EventTicketsDTO> edit(EventTicketsDTO ticketsType) async {
    Response res = await putCall(
      baseURL, 
      '/api/eventTickets/edit',
      body: jsonEncode(ticketsType)
    );
    if(res.statusCode == 200) {
      return EventTicketsDTO.fromJson(json.decode(res.body));
    } else {
      throw ErrorDescription('Create ticket status not 200. Status: ${res.statusCode}');
    }
  }

  @override
  Future<EventTicketsDetailsDTO> dataResume(int eventId, int eventTicketId) async{
    Response res = await getCall(
      baseURL, 
      '/api/eventTickets/dataResume',
      queryParameters: {
        "eventId": '$eventId',
        "eventTicketId": '$eventTicketId'
      }
    );
    if(res.statusCode == 200) {
      return EventTicketsDetailsDTO.fromJson(json.decode(utf8.decode(res.bodyBytes)));
    } else {
      return EventTicketsDetailsDTO(amountSold: 0, amountRemaining: 0, totalIncome: 0);
    }
  }
  
  @override
  Future<EventTicketsDetailsDTO> eventTicketsDataResume(int eventId) async {
    Response res = await getCall(
      baseURL, 
      '/api/eventTickets/eventDataResume',
      queryParameters: {
        "eventId": '$eventId'
      }
    );
    if(res.statusCode == 200) {
      return EventTicketsDetailsDTO.fromJson(jsonDecode(res.body));
    } else {
      return EventTicketsDetailsDTO(amountSold: 0, amountRemaining: 0, totalIncome: 0);
    }
  }

 
}