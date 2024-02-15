

import 'dart:convert';
import 'package:my_app/globals.dart' as globals;
import 'package:http/http.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/request/signin_request.dart';
import 'package:my_app/infraestructure/models/authentication/request/signup_request.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.url();

String basicAuth = '';

class AuthenticationRepositoryImpl extends BasicService implements AuthenticationRepository {
  AuthenticationRepositoryImpl(super.session);

  
  @override
  Future<JwtAuthenticationResponseDTO> signIn(SignInRequest signinRequest) async {
    Response res = await postCall(
      baseURL, 
      '/api/auth/signin',
      headers: <String,String> {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(signinRequest)
      );
    if(res.statusCode == 200) {
      return JwtAuthenticationResponseDTO.fromJson(jsonDecode(res.body));
    } else {
      throw (JwtAuthenticationResponseDTO.fromJson(jsonDecode(res.body)).status);
    }
  }

  @override
  Future<JwtAuthenticationResponseDTO> signUp(SignUpRequest signupRequest) async{
    Response res = await postCall(
      baseURL,
      "/api/auth/signup",
      body: jsonEncode(signupRequest), 
      headers: <String, String> {
        'Content-Type': 'application/json'
      },
    );

    if(res.statusCode == 200) {
      return JwtAuthenticationResponseDTO.fromJson(jsonDecode(res.body));
    } else{
      throw UnimplementedError();
    }
  }

  Future<bool> validateUniqueEmail(String email) async {
    Response res = await getCall(
      baseURL, 
      '/api/auth/validateEmail',
      queryParameters: {"email": email},
      headers: <String, String> {
        'Content-Type': 'application/json'
      },
      );

    if(res.statusCode == 200) {
      return bool.parse(res.body);
    } else {
      throw ArgumentError("Error validating email");
    }
  }
  Future<bool> validateAvailableUserName(String userName) async {
    Response res = await getCall(
      baseURL, 
      '/api/auth/availableUserName',
      queryParameters: {"userName": userName},
      headers: <String, String> {
        'Content-Type': 'application/json'
      },
      );

    if(res.statusCode == 200) {
      return bool.parse(res.body);
    } else {
      throw ArgumentError("Error validating username");
    }
  }

}