
import 'dart:convert';
import 'package:my_app/globals.dart' as globals;
import 'package:http/http.dart';
import 'package:my_app/domain/repositories/organizer_squad_repository.dart';
import 'package:my_app/infraestructure/models/squad/organizer_squad_dto.dart';
import 'package:my_app/infraestructure/models/squad/public_relation_squad_dto.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.url();

String basicAuth = '';


class OrganizerSquadRepositoryImpl extends BasicService implements OrganizerSquadRepository {
  OrganizerSquadRepositoryImpl(super.session);

  
  
  @override
  Future<List<OrganizerSquadDTO>> getTeamSquadByOrganizer(String organizerId) async {
    Response res = await getCall(
      baseURL, 
      '/api/squad/organizerSquad',
      queryParameters: {
        "organizerId": organizerId
      }
    );
    if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<OrganizerSquadDTO>.from(events.map((event) => OrganizerSquadDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }
  
  @override
  Future<List<OrganizerSquadDTO>> addUserToSquad(String userId) async {
    // TODO: implement addUserToSquad
    Response res = await postCall(
      baseURL, 
      '/api/squad/addUserToSquad',
      queryParameters: {
        "userId": userId
      }
    );
    if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<OrganizerSquadDTO>.from(events.map((event) => OrganizerSquadDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }
  
  @override
  Future<List<OrganizerSquadDTO>> deleteUserFromSquad(int userId, int organizerId) async{
    Response res = await putCall(
      baseURL, 
      '/api/squad/deleteUserFromSquad',
      queryParameters: {
        "userId": '$userId',
        "organizerId": '$organizerId'
      }
    );

    if(res.statusCode == 200){
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<OrganizerSquadDTO>.from(events.map((event) => OrganizerSquadDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }
  
  @override
  Future<List<PublicRelationSquadDTO>> getSquads() async {
    Response res = await getCall(
      baseURL, 
      '/api/squad/userSquads',
    );
    if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<PublicRelationSquadDTO>.from(events.map((event) => PublicRelationSquadDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }
}