import 'package:my_app/infraestructure/models/events/custom/event_data_dto.dart';
import 'package:my_app/infraestructure/models/events/custom/event_organizer_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/event_query_params.dart';

abstract class EventRepository {

  Future<List<EventDTO>> getAllEventsAvailable();
  Future<EventOrganizerDTO> getAllEventsOrganizer(String organizerId);
  Future<EventDTO?> findEventById(String id);
  Future<EventDTO?> create(EventDTO eventDTO);
  Future<EventDTO?> editEvent(EventDTO eventDTO);
  Future<EventDataDTO> search(EventQueryParams filter);
}