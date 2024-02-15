import 'dart:convert';

TicketsTypeDTO ticketsTypeDTOFromJson(String str) => TicketsTypeDTO.fromJson(json.decode(str));

String ticketsTypeDTOToJson(TicketsTypeDTO data) => json.encode(data.toJson());


class TicketsTypeDTO {
    int? id;
    String encoderName;
    String encoderCode;
    String encoderLocatedCode;
    String encoderDescription;
    int organizerId;
    String? organizerName;

    TicketsTypeDTO({
        this.id,
        required this.encoderName,
        required this.encoderCode,
        required this.encoderLocatedCode,
        required this.encoderDescription,
        required this.organizerId,
        this.organizerName,
    });



    factory TicketsTypeDTO.fromJson(Map<String, dynamic> json) => TicketsTypeDTO(
        id: json["id"] ?? 0,
        encoderName: json["encoderName"] ?? '',
        encoderCode: json["encoderCode"] ?? 'DEFAULTCODE',
        encoderLocatedCode: json["encoderLocatedCode"] ?? '',
        encoderDescription: json["encoderDescription"] ?? '',
        organizerId: json["organizerId"] ?? '',
        organizerName: json["organizerName"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "encoderName": encoderName,
        "encoderCode": encoderCode,
        "encoderLocatedCode": encoderLocatedCode,
        "encoderDescription": encoderDescription,
        "organizerId": organizerId,
        "organizerName": organizerName,
    };


    TicketsTypeDTO copyWith({
        int? id,
        String? encoderName,
        String? encoderCode,
        String? encoderLocatedCode,
        String? encoderDescription,
        int? organizerId,
        String? organizerName,
    }) => 
        TicketsTypeDTO(
            id: id ?? this.id,
            encoderName: encoderName ?? this.encoderName,
            encoderCode: encoderCode ?? this.encoderCode,
            encoderLocatedCode: encoderLocatedCode ?? this.encoderLocatedCode,
            encoderDescription: encoderDescription ?? this.encoderDescription,
            organizerId: organizerId ?? this.organizerId,
            organizerName: organizerName ?? this.organizerName,
        );
}