import 'package:my_app/infraestructure/models/authentication/user_info_dto.dart';

abstract class UserRepository {

  List<UserInfoDTO> getUsersByUsername(String name);

  Future<List<UserInfoDTO>> getUsersByUsernamePageable(String name,String searchType, String organizerId, String? eventId, int page);

}