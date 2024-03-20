import 'dart:convert';
import 'package:my_app/domain/repositories/event_open_respository.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:http/http.dart';
import 'package:my_app/infraestructure/models/events/custom/open_event_dto.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.url();

String basicAuth = '';


class EventOpenRepositoryImpl extends BasicService implements EventOpenRepository {
  EventOpenRepositoryImpl(super.session);
  
  @override
  Future<OpenEventDTO?> findEventById(String id) async{
   Response res = await getCall(
      baseURL, 
      '/api/open/event',
      queryParameters: {
        'eventId': id
      },
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Content-Type" : "application/json; charset=utf-8",
        "Accept": "*/*"
      },
    );
    if(res.statusCode == 200) {
      return OpenEventDTO.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    } else {
      return null;
    }
  }

  
}