import 'dart:convert';
TicketsTypeQueryParams ticketsTypeQueryParamsFromJson(String str) => TicketsTypeQueryParams.fromJson(json.decode(str));

String ticketsTypeQueryParamsToJson(TicketsTypeQueryParams data) => json.encode(data.toJson());

class TicketsTypeQueryParams {
    int? id;
    String? name;
    String? code;
    int organizerId;
    String? organizerName;

    TicketsTypeQueryParams({
        this.id,
        this.name,
        this.code,
        required this.organizerId,
        this.organizerName,
    });


    factory TicketsTypeQueryParams.fromJson(Map<String, dynamic> json) => TicketsTypeQueryParams(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        code: json["code"] ?? 'DEFAULTCODE',
        organizerId: json["organizerId"] ?? '',
        organizerName: json["organizerName"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        if(id!= null) "id": '$id',
        if(name!= null) "name": name,
        if(code!= null) "code": code,
        "organizerId": '$organizerId',
        if(organizerName!= null) "organizerName": organizerName,
    };


    TicketsTypeQueryParams copyWith({
        int? id,
        String? name,
        String? code,
        int? organizerId,
        String? organizerName,
    }) => 
        TicketsTypeQueryParams(
            id: id ?? this.id,
            name: name ?? this.name,
            code: code ?? this.code,
            organizerId: organizerId ?? this.organizerId,
            organizerName: organizerName ?? this.organizerName,
        );

}