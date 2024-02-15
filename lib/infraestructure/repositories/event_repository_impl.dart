
import 'dart:convert';
import 'package:my_app/globals.dart' as globals;
import 'package:http/http.dart';
import 'package:my_app/domain/repositories/event_repository.dart';
import 'package:my_app/infraestructure/models/events/custom/event_data_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/event_query_params.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.url();

String basicAuth = '';


class EventRepositoryImpl extends BasicService implements EventRepository {
  EventRepositoryImpl(super.session);

  
  
  @override
  Future<List<EventDTO>> getAllEventsAvailable() async {
    // TODO: implement getAllEventsAvailaable

    Response res = await getCall(
      baseURL, 
      '/api/events/findEvents',
    );
    if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<EventDTO>.from(events.map((event) => EventDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }
  
  @override
  Future<EventDTO?> findEventById(String id) async{
   Response res = await getCall(
      baseURL, 
      '/api/events/findEventById',
      queryParameters: {
        'eventId': id
      }
    );
    if(res.statusCode == 200) {
      
      return EventDTO.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    } else {
      return null;
    }
  }
  
  @override
  Future<EventDTO?> create(EventDTO eventDTO) async{
    Response res = await postCall(
      baseURL, 
      '/api/events/create',
      body: jsonEncode(eventDTO)
    );
    if(res.statusCode == 200){
      return EventDTO.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    }else {
      return null;
    }
  }
  
  @override
  Future<EventDTO?> editEvent(EventDTO eventDTO) async{
    Response res = await putCall(
      baseURL, 
      '/api/events/edit',
      body: jsonEncode(eventDTO)
    );
    if(res.statusCode == 200){
      return EventDTO.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    }else {
      return null;
    }
  }

  @override
  Future<EventDataDTO> search(EventQueryParams filter) async{
    Response res = await getCall(
      baseURL, 
      '/api/events',
      queryParameters: filter.toJson()
    );
    if(res.statusCode == 200) {      
      return EventDataDTO.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    } else {
      return EventDataDTO.fromJson({});
    }
  }
  
}