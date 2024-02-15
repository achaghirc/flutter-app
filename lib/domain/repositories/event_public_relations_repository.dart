
import 'package:my_app/infraestructure/models/squad/event_public_relations_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/event_public_relation_data_dto.dart';

abstract class EventPublicRelationsRepository {
  
  Future<List<EventPublicRelationsDTO>> getPublicRelationsByUsernamePageable(String name,String searchType, String organizerId, int page);
  Future<List<EventPublicRelationsDTO>> getAllPublicRelationdByEventId(String eventId);
  Future<List<EventPublicRelationsDTO>> assignToEvent(String userId, String eventId);
  Future<List<EventPublicRelationsDTO>> search(String? id, String? rrppCode, String? userId, String? username, String? eventId, String statusCode);
  Future<List<EventPublicRelationsDTO>> searchPageable(String? id, String? rrppCode, String? userId, String? username, String? eventId, String statusCode, int limit, int page);
  Future<List<EventPublicRelationsDTO>> deleteFromEvent(int id, int eventId);
  Future<EventPublicRelationDataDTO> getPublicRelationZoneData();
  Future<EventPublicRelationDataDTO> getEventDataResume(String publicRelationCode);

}