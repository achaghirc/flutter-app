
import 'dart:convert';
import 'package:my_app/globals.dart' as globals;
import 'package:http/http.dart';
import 'package:my_app/domain/repositories/user_repository.dart';
import 'package:my_app/infraestructure/models/authentication/request/change_password.dart';
import 'package:my_app/infraestructure/models/authentication/user_dto.dart';
import 'package:my_app/infraestructure/models/authentication/user_info_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/search_users_query_params.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.url();

String basicAuth = '';


class UserRepositoryImpl extends BasicService implements UserRepository {  
  UserRepositoryImpl(super.session);

  @override
  List<UserInfoDTO> getUsersByUsername(String name) {
   Response res = getCall(
      baseURL, 
      '/api/user/searchByUsername',
      queryParameters: {
        "username": name,
        "page": 0,
        "limit": 10
      }
    );
    if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<UserInfoDTO>.from(events.map((event) => UserInfoDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }
  
  @override
  Future<List<UserInfoDTO>> getUsersByUsernamePageable(String name,String searchType, String organizerId, String? eventId, int page) async{
    Response res = await getCall(
      baseURL, 
      '/api/user/searchByUsername',
      queryParameters: {
        "username": name,
        "searchType": searchType,
        "organizerId": organizerId,
        "eventId": eventId,
        "limit": "10"
      }
    );

     if(res.statusCode == 200) {
      Iterable events = json.decode(utf8.decode(res.bodyBytes));
      return List<UserInfoDTO>.from(events.map((event) => UserInfoDTO.fromJson(event)));
    } else {
      return List.empty();
    }
  }

  @override
  Future<List<UserDTO>> searchUser(SearchUsersQueryParams searchUsersQueryParams) async {
    Response res = await getCall(
      baseURL, 
      '/api/user/search',
      queryParameters: searchUsersQueryParams.toJson()
    );

     if(res.statusCode == 200) {
      Iterable users = json.decode(utf8.decode(res.bodyBytes));
      return List<UserDTO>.from(users.map((user) => UserDTO.fromJson(user)));
    } else {
      return List.empty();
    }
  }

  @override
  Future<bool> changePassword(ChangePasswordDTO changePasswordDTO) async {
    Response res = await patchCall(
      baseURL, 
      '/api/user/password',
      body: jsonEncode(changePasswordDTO)
    );
    if(res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return false;
    }
  }
  @override
  Future<UserDTO> updateUser(UserDTO user) async{
    Response res = await putCall(
      baseURL,
      '/api/user',
      body: jsonEncode(user)
    );

    if(res.statusCode == 200){
      return UserDTO.fromJson(jsonDecode(res.body));
    }else{
      return UserDTO.fromJson({});
    }
  } 
}