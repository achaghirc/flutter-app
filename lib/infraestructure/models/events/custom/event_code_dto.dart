
import 'package:my_app/infraestructure/models/image/imageDTO.dart';

class EventCodeDTO {

  String rrppCode;
  int eventId;
  String eventName;
  String eventDescription;
  String eventStartDate;
  String eventEndDate;
  String eventLimitHour;
  int eventOrganizerId;
  String eventOrganizerName;
  String? eventUbicationId;
  String eventUbicationTypeRoad;
  String eventUbicationNameRoad;
  String eventUbicationNumber;
  String eventUbicationTown;
  String? eventUbicationProvince;
  String? eventUbicationCountry;
  String? eventUbicationPostalCode;
  String? eventUbicationMoreInfo;
  String? eventStatusCode;
  String? eventStatusLocatedCode;
  List<ImageDTO> eventMedias;


  EventCodeDTO({
    required this.rrppCode,
    required this.eventId,
    required this.eventName,
    required this.eventDescription,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventLimitHour,
    required this.eventOrganizerId,
    required this.eventOrganizerName,
    this.eventUbicationId,
    required this.eventUbicationTypeRoad,
    required this.eventUbicationNameRoad,
    required this.eventUbicationNumber,
    required this.eventUbicationTown,
    this.eventUbicationProvince,
    this.eventUbicationCountry,
    this.eventUbicationPostalCode,
    this.eventUbicationMoreInfo,
    this.eventStatusCode,
    this.eventStatusLocatedCode,
    required this.eventMedias,    
  });


  factory EventCodeDTO.fromJson(Map<String,dynamic> json) => EventCodeDTO(
    rrppCode: json["rrppCode"] ?? "", 
    eventId: json["eventId"] ?? 0,
    eventName: json["eventName"] ?? "",
    eventDescription: json["eventDescription"] ?? "",
    eventStartDate: json["eventStartDate"] ?? "",
    eventEndDate: json["eventEndDate"] ?? "",
    eventLimitHour: json["eventLimitHour"] ?? "",
    eventOrganizerId: json["eventOrganizerId"] ?? 0,
    eventOrganizerName: json["eventOrganizerName"] ?? "",
    eventUbicationId: json["eventUbicationId"] ?? 0,
    eventUbicationTypeRoad: json["eventUbicationTypeRoad"] ?? "",
    eventUbicationNameRoad: json["eventUbicationNameRoad"] ?? "",
    eventUbicationNumber: json["eventUbicationNumber"] ?? "",
    eventUbicationTown: json["eventUbicationTown"] ?? "",
    eventUbicationProvince: json["eventUbicationProvince"] ?? "",
    eventUbicationCountry: json["eventUbicationCountry"] ?? "",
    eventUbicationPostalCode: json["eventUbicationPostalCode"] ?? "",
    eventUbicationMoreInfo: json["eventUbicationMoreInfo"] ?? "",
    eventStatusCode: json["eventStatusCode"] ?? "",
    eventStatusLocatedCode: json["eventStatusLocatedCode"] ?? "",
    eventMedias: json["eventMedias"] == null ? [] : List<ImageDTO>.from(json["eventMedias"]!.map((x) => ImageDTO.fromJson(x)))


    
  );


  Map<String, dynamic> toJson() => {
    "rrppCode" : rrppCode,
    "eventId" : eventId,
    "eventName" : eventName,
    "eventDescription" : eventDescription,
    "eventStartDate" : eventStartDate,
    "eventEndDate" : eventEndDate,
    "eventLimitHour" : eventLimitHour,
    "eventOrganizerId" : eventOrganizerId,
    "eventOrganizerName" : eventOrganizerName,
    "eventUbicationId" : eventUbicationId,
    "eventUbicationTypeRoad" : eventUbicationTypeRoad,
    "eventUbicationNameRoad" : eventUbicationNameRoad,
    "eventUbicationNumber" : eventUbicationNumber,
    "eventUbicationTown" : eventUbicationTown,
    "eventUbicationProvince" : eventUbicationProvince,
    "eventUbicationCountry" : eventUbicationCountry,
    "eventUbicationPostalCode" : eventUbicationPostalCode,
    "eventUbicationMoreInfo" : eventUbicationMoreInfo,
    "eventStatusCode" : eventStatusCode,
    "eventStatusLocatedCode" : eventStatusLocatedCode,
    "eventMedias" : eventMedias,
  };

}