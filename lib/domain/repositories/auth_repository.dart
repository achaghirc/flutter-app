import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/request/signin_request.dart';
import 'package:my_app/infraestructure/models/authentication/request/signup_request.dart';

abstract class AuthenticationRepository {

  Future<JwtAuthenticationResponseDTO> signUp(SignUpRequest signupRequest);
  Future<JwtAuthenticationResponseDTO> signIn(SignInRequest signupRequest);

}