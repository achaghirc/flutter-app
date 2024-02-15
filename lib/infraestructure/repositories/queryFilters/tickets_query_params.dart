import 'dart:convert';
TicketsQueryParams ticketsTypeQueryParamsFromJson(String str) => TicketsQueryParams.fromJson(json.decode(str));

String ticketsTypeQueryParamsToJson(TicketsQueryParams data) => json.encode(data.toJson());

class TicketsQueryParams {
    int? id;
    int? ticketsTypeId;
    String? rrppCode;
    int? eventId;
    int? userId;
    String? userName;

    TicketsQueryParams({
        this.id,
        this.ticketsTypeId,
        this.rrppCode,
        this.eventId,
        this.userId,
        this.userName,
    });


    factory TicketsQueryParams.fromJson(Map<String, dynamic> json) => TicketsQueryParams(
        id: json["id"] ?? 0,
        ticketsTypeId: json["ticketsTypeId"] ?? 0,
        rrppCode: json["rrppCode"] ?? 'DEFAULTCODE',
        eventId: json["eventId"] ?? '',
        userId: json["userId"] ?? 0,
        userName: json["userName"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        if(id!= null) "id": '$id',
        if(ticketsTypeId!= null) "ticketsTypeId": ticketsTypeId,
        if(rrppCode!= null) "rrppcode": rrppCode,
        if(eventId!= null) "eventId": eventId,
        if(userId!= null) "userId": userId,
        if(userName!= null) "userName": userName,
    };


    TicketsQueryParams copyWith({
        int? id,
        int? ticketsTypeId,
        String? rrppCode,
        int? eventId,
        int? userId,
        String? userName,
    }) => 
        TicketsQueryParams(
            id: id ?? this.id,
            ticketsTypeId: ticketsTypeId ?? this.ticketsTypeId,
            rrppCode: rrppCode ?? this.rrppCode,
            eventId: eventId ?? this.eventId,
            userId: userId ?? this.userId,
            userName: userName ?? this.userName,
        );

}