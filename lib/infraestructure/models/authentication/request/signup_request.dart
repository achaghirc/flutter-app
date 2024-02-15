import 'dart:convert';

SignUpRequest signupRequestFromJson(String str) => SignUpRequest.fromJson(json.decode(str));

String signupRequestToJson(SignUpRequest data) => json.encode(data.toJson());

class SignUpRequest {
    String userName;
    String firstName;
    String lastName;
    String email;
    String password;
    String dni;
    String phoneNumber;

    SignUpRequest({
        required this.userName,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.password,
        required this.dni,
        required this.phoneNumber,
    });

    factory SignUpRequest.fromJson(Map<String, dynamic> json) => SignUpRequest(
        userName: json["userName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        dni: json["dni"],
        phoneNumber: json["phoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "dni": dni,
        "phoneNumber": phoneNumber,
    };
}