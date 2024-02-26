
import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
class BasicService {

  
  late JwtAuthenticationResponseDTO? session;
  late Map<String, String> headers;


  BasicService(JwtAuthenticationResponseDTO? session) {
    session = session;
    headers = {
      "Authorization": 'Bearer ${session?.token.toString()}',
      "Content-Type" : "application/json; charset=utf-8"
    };
  }

  _manageErrors(Response res) {
    switch(res.statusCode) {
      case 401: 
        print(jsonDecode(res.body));
        throw ArgumentError(jsonDecode(res.body));
      case 500: 
        throw ArgumentError('INTERNAL SERVER ERROR: ${res.body}');
      default:
        throw('${res.statusCode}  -> ${res.body}');
    }
  }



  getCall(String url, String path, 
    {Map<String,String>? headers, 
    Map<String, dynamic>? queryParameters}) async {
      Response res = await get(Uri.parse(url + path).replace(queryParameters: queryParameters),
        headers: headers ?? this.headers);
      
      if (res.statusCode == 200 || res.statusCode == 204){
        return res;
      } else {
        _manageErrors(res);
      }
    }
  
  deleteCall(String url, String path, 
    {Map<String,String>? headers, 
    Map<String, dynamic>? queryParameters}) async {
      Response res = await delete(Uri.parse(url + path).replace(queryParameters: queryParameters),
        headers: headers ?? this.headers);
      
      if (res.statusCode == 200 || res.statusCode == 204){
        return res;
      } else {
        _manageErrors(res);
      }
    }

  putCall(String url, String path, 
    {Map<String,String>? headers, 
    dynamic body,
    Map<String, dynamic>? queryParameters}) async {
    
    Response res = await put(
      Uri.parse(url + path).replace(queryParameters: queryParameters),
      headers: headers ?? this.headers,
      body: body
    );
    
    if(res.statusCode == 200) {
      return res;
    }else {
      _manageErrors(res);
    }
  }

  patchCall(String url, String path, 
    {Map<String,String>? headers, 
    dynamic body,
    Map<String, dynamic>? queryParameters}) async {
    
    Response res = await patch(
      Uri.parse(url + path).replace(queryParameters: queryParameters),
      headers: headers ?? this.headers,
      body: body
    );
    
    if(res.statusCode == 200) {
      return res;
    }else {
      _manageErrors(res);
    }
  }

  postCall(String url, String path, 
    {Map<String,String>? headers, 
    dynamic body,
    Map<String, dynamic>? queryParameters}) async {
    
    Response res = await post(
      Uri.parse(url+path).replace(queryParameters: queryParameters),
      headers: headers ?? this.headers,
      body: body
    );
    
    if(res.statusCode == 200) {
      return res;
    }else if(res.statusCode == 401) {
      _manageErrors(res);
      return res;
    } else {
      _manageErrors(res);
    }
  }
}