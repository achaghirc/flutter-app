// To parse this JSON data, do
//
//     final eventDto = eventDtoFromJson(jsonString);

import 'dart:convert';

import 'package:my_app/infraestructure/models/image/imageDTO.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';

EventDTO eventDtoFromJson(String str) => EventDTO.fromJson(json.decode(str));

String eventDtoToJson(EventDTO data) => json.encode(data.toJson());

class EventDTO {
    int id;
    String name;
    String description;
    String startDate;
    String endDate;
    String limitHour;
    int organizerId;
    String organizerName;
    String? ubicationId;
    String ubicationTypeRoad;
    String ubicationNameRoad;
    String ubicationNumber;
    String ubicationTown;
    String? ubicationProvince;
    String? ubicationCountry;
    String? ubicationPostalCode;
    String? ubicationMoreInfo;
    String statusCode;
    String statusLocatedCode;
    List<ImageDTO> medias;
    List<EventTicketsDTO>? tickets;

    EventDTO({
        required this.id,
        required this.name,
        required this.description,
        required this.startDate,
        required this.limitHour,
        required this.endDate,
        required this.organizerId,
        required this.organizerName,
        required this.ubicationTypeRoad,
        required this.ubicationNameRoad,
        required this.ubicationNumber,
        required this.ubicationTown,
        this.ubicationId,
        this.ubicationProvince,
        this.ubicationCountry,
        this.ubicationPostalCode,
        this.ubicationMoreInfo,
        required this.statusCode,
        required this.statusLocatedCode,
        required this.medias,
        this.tickets,
    });

    factory EventDTO.fromJson(Map<String, dynamic> jsonMap) => EventDTO (
      id: jsonMap["id"],
      name: jsonMap["name"],
      description: jsonMap["description"] ?? '',
      startDate: jsonMap["startDate"],
      endDate: jsonMap["endDate"],
      limitHour: jsonMap["limitHour"] ?? jsonMap["startDate"],
      organizerId: jsonMap["organizerId"],
      organizerName: jsonMap["organizerName"],
      ubicationId: jsonMap["ubicationId"] ?? '0',
      ubicationTypeRoad: jsonMap["ubicationTypeRoad"] ?? 'TC',
      ubicationNameRoad: jsonMap["ubicationNameRoad"] ?? 'Test',
      ubicationNumber: jsonMap["ubicationNumber"] ?? '0',
      ubicationTown: jsonMap["ubicationTown"] ?? 'Test',
      ubicationProvince: jsonMap["ubicationProvince"] ?? '',
      ubicationCountry: jsonMap["ubicationCountry"] ?? '',
      ubicationPostalCode: jsonMap["ubicationPostalCode"] ?? '',
      ubicationMoreInfo: jsonMap["ubicationMoreInfo"] ?? '',
      statusCode: jsonMap["statusCode"] ?? '',
      statusLocatedCode: jsonMap["statusLocatedCode"] ?? '',
      medias: jsonMap["medias"] == null ? [] : List<ImageDTO>.from(jsonMap["medias"]!.map((x) => ImageDTO.fromJson(x))), 
      tickets: jsonMap["tickets"] == null ? [] : List<EventTicketsDTO>.from(jsonMap["tickets"]!.map((x) => EventTicketsDTO.fromJson(x))), 
    );


    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "startDate": startDate,
        "endDate": endDate,
        "limitHour": limitHour,
        "organizerId": organizerId,
        "organizerName": organizerName,
        "ubicationId" : ubicationId,
        "ubicationTypeRoad" : ubicationTypeRoad,
        "ubicationNameRoad" : ubicationNameRoad,
        "ubicationNumber" : ubicationNumber,
        "ubicationTown" : ubicationTown,
        "ubicationProvince" : ubicationProvince ?? '',
        "ubicationCountry" : ubicationCountry ?? '',
        "ubicationPostalCode" : ubicationPostalCode ?? '',
        "ubicationMoreInfo" : ubicationMoreInfo ?? '',
    };
}
