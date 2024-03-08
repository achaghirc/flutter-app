import 'package:my_app/infraestructure/models/events/custom/open_event_dto.dart';

abstract class EventOpenRepository {
  Future<OpenEventDTO?> findEventById(String id);
}