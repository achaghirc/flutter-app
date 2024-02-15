
import 'dart:convert';
SearchRRPPQueryParams searchRRPPQueryParamsDtoFromJson(String str) => SearchRRPPQueryParams.fromJson(json.decode(str));

String searchRRPPQueryParamsDtoToJson(SearchRRPPQueryParams data) => json.encode(data.toJson());

class SearchRRPPQueryParams {
    String? id;
    String? rrppCode;
    String? userId;
    String? username;
    String? eventId;
    String? statusCode;
    String? limit;
    String? page;


    SearchRRPPQueryParams({
      this.id,
      this.rrppCode,
      this.userId,
      this.username,
      this.eventId,
      this.statusCode,
      this.limit,
      this.page,
    });

    factory SearchRRPPQueryParams.fromJson(Map<String, dynamic> json) => SearchRRPPQueryParams(
        id: json["id"] ?? '',
        rrppCode: json["rrppCode"] ?? 'DEFAULTCODE',
        userId: json["userId"] ?? '',
        username: json["userUsername"] ?? '',
        eventId: json["eventId"] ?? '',
        statusCode: json["eventOrganizerId"] ?? '',
        limit: json["eventOrganizerId"] ?? '',
        page: json["eventOrganizerId"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        if(id != null) "id" : id,
        if(rrppCode != null) "rrppCode" : rrppCode,
        if(userId != null) "userId" : userId,
        if(username != null) "username" : username,
        if(eventId != null) "eventId" : eventId,
        if(statusCode != null) "statusCode" : statusCode,
        if(limit != null) "limit" : limit,
        if(page != null) "page" : page,
    };
}