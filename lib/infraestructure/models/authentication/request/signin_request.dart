import 'dart:convert';

SignInRequest signInRequestFromJson(String str) => SignInRequest.fromJson(json.decode(str));

String signInRequestToJson(SignInRequest data) => json.encode(data.toJson());

class SignInRequest {
    String userName;
    String password;


    SignInRequest({
        required this.userName,
        required this.password,
    });

    factory SignInRequest.fromJson(Map<String, dynamic> json) => SignInRequest(
        userName: json["userName"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
    };
}