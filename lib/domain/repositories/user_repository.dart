import 'package:my_app/infraestructure/models/authentication/request/change_password.dart';
import 'package:my_app/infraestructure/models/authentication/user_dto.dart';
import 'package:my_app/infraestructure/models/authentication/user_info_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/search_users_query_params.dart';

abstract class UserRepository {

  List<UserInfoDTO> getUsersByUsername(String name);

  Future<List<UserInfoDTO>> getUsersByUsernamePageable(String name,String searchType, String organizerId, String? eventId, int page);

  Future<List<UserDTO>> searchUser(SearchUsersQueryParams searchUsersQueryParams);

  Future<bool> changePassword(ChangePasswordDTO changePasswordDTO);

  Future<UserDTO> updateUser(UserDTO user);

}