import 'dart:typed_data';
import 'dart:convert';

TicketsDTO ticketsDTOFromJson(String str) => TicketsDTO.fromJson(json.decode(str));

String ticketsDTOToJson(TicketsDTO data) => json.encode(data.toJson());


class TicketsDTO {
    int? id;
    String name;
    double price;
    Uint8List? qrCode;
    String rrppCode;
    String? ticketCode;
    String buyDate;
    int ticketsTypeId;
    String ticketsTypeEncoderCode;
    String? ticketsTypeEncoderName;
    int userId;
    String userUsername;
    int eventTicketId;
    String eventTicketName;
    String? eventTicketEventName;
    String eventTicketEventDate;
    double? eventTicketTicketCommission; 
    
    TicketsDTO({
        this.id,
        required this.name,
        required this.price,
        this.qrCode,
        required this.rrppCode,
        this.ticketCode,
        required this.buyDate,
        required this.ticketsTypeId,
        required this.ticketsTypeEncoderCode,
        this.ticketsTypeEncoderName,
        required this.userId,
        required this.userUsername,
        required this.eventTicketId,
        required this.eventTicketName,
        this.eventTicketEventName,
        required this.eventTicketEventDate,
        this.eventTicketTicketCommission
    });

    factory TicketsDTO.fromJson(Map<String, dynamic> json) => TicketsDTO(
      id: json["id"] ?? 0, 
      name: json["name"] ?? '', 
      price: json["price"] ?? 0.0, 
      qrCode: base64Decode(json["qrCode"]), 
      rrppCode: json["rrppCode"] ?? '', 
      ticketCode: json["ticketCode"] ?? 'TICKETCODE', 
      buyDate: json["buyDate"] ?? DateTime.now(), 
      ticketsTypeId: json["ticketsTypeId"] ?? '', 
      ticketsTypeEncoderCode: json["ticketsTypeEncoderCode"] ?? '', 
      ticketsTypeEncoderName: json["ticketsTypeEncoderName"] ?? '', 
      userId: json["userId"] ?? 0, 
      userUsername: json["userUsername"] ?? '', 
      eventTicketId: json["eventTicketId"] ?? 0, 
      eventTicketName: json["eventTicketName"] ?? '', 
      eventTicketEventName: json["eventTicketEventName"] ?? '', 
      eventTicketEventDate: json["eventTicketEventDate"] ?? DateTime.now(),
      eventTicketTicketCommission: json["eventTicketTicketCommission"] ?? 0.0
    );

    Map<String, dynamic> toJson() => {
      "id" : id,
      "name" : name,
      "price" : price,
      "qrCode" : qrCode,
      "rrppCode" : rrppCode,
      "buyDate" : buyDate,
      "ticketsTypeId" : ticketsTypeId,
      "ticketsTypeEncoderCode" : ticketsTypeEncoderCode,
      "ticketsTypeEncoderName" : ticketsTypeEncoderName,
      "userId" : userId,
      "userUsername" : userUsername,
      "eventTicketId" : eventTicketId,
      "eventTicketName" : eventTicketName,
      "eventTicketEventDate" : eventTicketEventDate,
      "eventTicketTicketCommission": eventTicketTicketCommission
    };


    TicketsDTO copyWith({
        int? id,
        String? name,
        double? price,
        Uint8List? qrCode,
        String? rrppCode,
        String? ticketCode,
        String? buyDate,
        int? ticketsTypeId,
        String? ticketsTypeEncoderCode,
        String? ticketsTypeEncoderName,
        int? userId,
        String? userUsername,
        int? eventTicketId,
        String? eventTicketName,
        String? eventTicketEventName,
        String? eventTicketEventDate,
    }) => 
        TicketsDTO(
            id: id ?? this.id,
            name: name ?? this.name,
            price: price ?? this.price,
            qrCode: qrCode ?? this.qrCode,
            rrppCode: rrppCode ?? this.rrppCode,
            ticketCode: ticketCode ?? this.ticketCode,
            buyDate: buyDate ?? this.buyDate,
            ticketsTypeId: ticketsTypeId ?? this.ticketsTypeId,
            ticketsTypeEncoderCode: ticketsTypeEncoderCode ?? this.ticketsTypeEncoderCode,
            ticketsTypeEncoderName: ticketsTypeEncoderName ?? this.ticketsTypeEncoderName,
            userId: userId ?? this.userId,
            userUsername: userUsername ?? this.userUsername,
            eventTicketId: eventTicketId ?? this.eventTicketId,
            eventTicketName: eventTicketName ?? this.eventTicketName,
            eventTicketEventName: eventTicketEventName ?? this.eventTicketEventName,
            eventTicketEventDate: eventTicketEventDate ?? this.eventTicketEventDate
        );
}
