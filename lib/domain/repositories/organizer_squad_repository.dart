import 'package:my_app/infraestructure/models/squad/organizer_squad_dto.dart';

abstract class OrganizerSquadRepository {

  Future<List<OrganizerSquadDTO>> getTeamSquadByOrganizer(String organizerIds);

  Future<List<OrganizerSquadDTO>> addUserToSquad(String userId);

   Future<List<OrganizerSquadDTO>> deleteUserFromSquad(int userId, int organizerId);
   
   Future<List<OrganizerSquadDTO>> getSquads();

}