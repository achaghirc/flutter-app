import 'dart:convert';
EventTicketsQueryParams eventTicketsQueryParamsFromJson(String str) => EventTicketsQueryParams.fromJson(json.decode(str));

String eventTicketsQueryParamsToJson(EventTicketsQueryParams data) => json.encode(data.toJson());


class EventTicketsQueryParams {
    int? id;
    int? eventId;
    bool? available;

    EventTicketsQueryParams({
        this.id,
        this.eventId,
        this.available,
    });

    factory EventTicketsQueryParams.fromJson(Map<String, dynamic> json) => EventTicketsQueryParams(
      id: json["id"] ?? 0, 
      eventId: json["eventId"] ?? 0, 
      available: json["available"] ?? true
    ); 

    Map<String, dynamic> toJson() => {
      if(id != null) "id" : '$id',
      if(eventId != null) "eventId" : '$eventId',
      if(available != null) "available" : '$available',
    };


    EventTicketsQueryParams copyWith({
        int? id,
        int? eventId,
        bool? available,
    }) => 
        EventTicketsQueryParams(
            id: id ?? this.id,
            eventId: eventId ?? this.eventId,
            available: available ?? this.available,
        );
}
