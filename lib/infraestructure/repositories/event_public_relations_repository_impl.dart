
import 'dart:convert';
import 'package:my_app/globals.dart' as globals;
import 'package:http/http.dart';
import 'package:my_app/domain/repositories/event_public_relations_repository.dart';
import 'package:my_app/infraestructure/models/squad/event_public_relations_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/event_public_relation_data_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/search_rrpp_query_params.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.url();

String basicAuth = '';


class EventPublicRelationsRepositoryImpl extends BasicService implements EventPublicRelationsRepository {
  EventPublicRelationsRepositoryImpl(super.session);

  
  @override
  Future<List<EventPublicRelationsDTO>> getPublicRelationsByUsernamePageable(String name,String searchType, String organizerId, int page) async{
    Response res = await getCall(
      baseURL, 
      '/api/user/searchByUsername',
      queryParameters: {
        "username": name,
        "searchType": searchType,
        "organizerId": organizerId,
        "limit": "10"
      }
    );

     if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<EventPublicRelationsDTO>.from(events.map((event) => EventPublicRelationsDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }

  
  @override
  Future<List<EventPublicRelationsDTO>> getAllPublicRelationdByEventId(String eventId) async {
    // TODO: implement getAllEventsAvailaable

    Response res = await getCall(
      baseURL, 
      '/api/publicRelations/allByEventId',
      queryParameters: {
        "eventId": eventId
      }
    );
    if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<EventPublicRelationsDTO>.from(events.map((event) => EventPublicRelationsDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }
  
  @override
  Future<List<EventPublicRelationsDTO>> assignToEvent(String userId, String eventId) async {
    Response res = await postCall(
      baseURL, 
      '/api/publicRelations/assign',
      queryParameters: {
        "userId": userId,
        "eventId": eventId
      }
    );
    if(res.statusCode == 200){
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<EventPublicRelationsDTO>.from(events.map((event) => EventPublicRelationsDTO.fromJson(event)));
    }else {
      return List.empty();
    }
  }
  
  @override
  Future<List<EventPublicRelationsDTO>> deleteFromEvent(int id, int eventId) async{
    Response res = await deleteCall(
      baseURL, 
      '/api/publicRelations/delete',
      queryParameters: {
        "id": "$id",
        "eventId": "$eventId",
      }
    );
    if(res.statusCode == 200){
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<EventPublicRelationsDTO>.from(events.map((event) => EventPublicRelationsDTO.fromJson(event)));
    }else {
      return List.empty();
    }
  }
  
  @override
  Future<List<EventPublicRelationsDTO>> search(String? id, String? rrppCode, String? userId, String? username, String? eventId, String statusCode) async{
    var queryParams = SearchRRPPQueryParams();
    if(id != null) queryParams.id = id;
    if(rrppCode != null) queryParams.rrppCode = rrppCode;
    if(userId != null) queryParams.userId = userId;
    if(username != null) queryParams.username = username;
    if(eventId != null) queryParams.eventId = eventId;
    queryParams.statusCode = statusCode;
       
    Response res = await getCall(
      baseURL, 
      '/api/publicRelations/search',
      queryParameters: queryParams.toJson()
    );
    if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<EventPublicRelationsDTO>.from(events.map((event) => EventPublicRelationsDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }
  
  @override
  Future<List<EventPublicRelationsDTO>> searchPageable(String? id, String? rrppCode, String? userId, String? username, String? eventId, String statusCode, int limit, int page) async {
    var queryParams = SearchRRPPQueryParams();
    if(id != null) queryParams.id = id;
    if(rrppCode != null) queryParams.rrppCode = rrppCode;
    if(userId != null) queryParams.userId = userId;
    if(username != null) queryParams.username = username;
    if(eventId != null) queryParams.eventId = eventId;
    queryParams.statusCode = statusCode;
    queryParams.limit = limit.toString();
    queryParams.page = page.toString();
    Response res = await getCall(
      baseURL, 
      '/api/publicRelations/search',
      queryParameters: queryParams.toJson()
    );
    if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<EventPublicRelationsDTO>.from(events.map((event) => EventPublicRelationsDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }

  @override
  Future<EventPublicRelationDataDTO> getPublicRelationZoneData() async {
    Response res = await getCall(
      baseURL, 
      '/api/publicRelations/zoneData',
    );
    if(res.statusCode == 200) {
      return EventPublicRelationDataDTO.fromJson(json.decode(utf8.decode(res.bodyBytes)));
    } else {
      return EventPublicRelationDataDTO.fromJson({});
    }
  }

  @override
  Future<EventPublicRelationDataDTO> getEventDataResume(String publicRelationCode) async {
    Response res = await getCall(
      baseURL, 
      '/api/publicRelations/eventDataResume',
      queryParameters: {
        "rrppCode": publicRelationCode
      }
    );
    if(res.statusCode == 200) {
      return EventPublicRelationDataDTO.fromJson(json.decode(utf8.decode(res.bodyBytes)));
    } else {
      return EventPublicRelationDataDTO.fromJson({});
    }
  }
}