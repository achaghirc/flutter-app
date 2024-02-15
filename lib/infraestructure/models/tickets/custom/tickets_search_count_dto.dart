import 'dart:convert';

TicketSearchCountDTO ticketSearchCountDTOFromJson(String str) => TicketSearchCountDTO.fromJson(json.decode(str));
String ticketSearchCountDTOToJson(TicketSearchCountDTO data) => json.encode(data.toJson());

class TicketSearchCountDTO {
    int amount;
    String ticketsTypeEncoderName;
    String ticketsTypeEncoderCode;
    String ticketsTypeEncoderLocatedCode;
    double eventTicketPrice;
    double eventTicketTicketCommission;

    TicketSearchCountDTO({
        required this.amount,
        required this.ticketsTypeEncoderName,
        required this.ticketsTypeEncoderCode,
        required this.ticketsTypeEncoderLocatedCode,
        required this.eventTicketPrice,
        required this.eventTicketTicketCommission,
    });

    factory TicketSearchCountDTO.fromJson(Map<String, dynamic> json) => TicketSearchCountDTO(
      amount: json["amount"] ?? 0, 
      ticketsTypeEncoderName: json["ticketsTypeEncoderName"] ?? '', 
      ticketsTypeEncoderCode: json["ticketsTypeEncoderCode"] ?? '', 
      ticketsTypeEncoderLocatedCode: json["ticketsTypeEncoderLocatedCode"] ?? '', 
      eventTicketPrice: json["eventTicketPrice"] ?? 0.0,
      eventTicketTicketCommission: json["eventTicketTicketCommission"] ?? 0.0
    );

    Map<String, dynamic> toJson() => {
      "amount": amount,
      "ticketsTypeEncoderName": ticketsTypeEncoderName,
      "ticketsTypeEncoderCode": ticketsTypeEncoderCode,
      "ticketsTypeEncoderLocatedCode": ticketsTypeEncoderLocatedCode,
      "eventTicketPrice": eventTicketPrice,
      "eventTicketTicketCommission": eventTicketTicketCommission,
    };

    TicketSearchCountDTO copyWith({
        int? amount,
        String? ticketsTypeEncoderName,
        String? ticketsTypeEncoderCode,
        String? ticketsTypeEncoderLocatedCode,
        double? eventTicketPrice,
        double? eventTicketTicketCommission,
    }) => 
        TicketSearchCountDTO(
            amount: amount ?? this.amount,
            ticketsTypeEncoderName: ticketsTypeEncoderName ?? this.ticketsTypeEncoderName,
            ticketsTypeEncoderCode: ticketsTypeEncoderCode ?? this.ticketsTypeEncoderCode,
            ticketsTypeEncoderLocatedCode: ticketsTypeEncoderLocatedCode ?? this.ticketsTypeEncoderLocatedCode,
            eventTicketPrice: eventTicketPrice ?? this.eventTicketPrice,
            eventTicketTicketCommission: eventTicketTicketCommission ?? this.eventTicketTicketCommission,
        );
}