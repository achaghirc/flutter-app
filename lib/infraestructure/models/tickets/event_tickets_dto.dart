class EventTicketsDTO {
    int? id;
    String name;
    double price;
    int amount;
    int? currentAmount;
    bool available;
    String? eventDate;
    int eventId;
    String? eventName;
    int ticketsTypeId;
    String? ticketsTypeEncoderCode;
    String? ticketsTypeEncoderName;
    String? ticketsTypeEncoderDescription;
    double? ticketCommission;

    EventTicketsDTO({
        this.id,
        required this.name,
        required this.price,
        required this.amount,
        this.currentAmount,
        required this.available,
        this.eventDate,
        required this.eventId,
        this.eventName,
        required this.ticketsTypeId,
        this.ticketsTypeEncoderCode,
        this.ticketsTypeEncoderName,
        this.ticketsTypeEncoderDescription,
        this.ticketCommission
    });

    
    factory EventTicketsDTO.fromJson(Map<String, dynamic> json) => EventTicketsDTO(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        price: json["price"] ?? '',
        amount: json["amount"] ?? 0,
        currentAmount: json["currentAmount"] ?? 0,
        available: json["available"] ?? true,
        eventDate: json["eventDate"] ?? '',
        eventId: json["eventId"] ?? 0,
        eventName: json["eventName"] ?? '',
        ticketsTypeId: json["ticketsTypeId"] ?? 0,
        ticketsTypeEncoderCode: json["ticketsTypeEncoderCode"] ?? '',
        ticketsTypeEncoderName: json["ticketsTypeEncoderName"] ?? '',
        ticketsTypeEncoderDescription: json["ticketsTypeEncoderDescription"] ?? '',
        ticketCommission: json["ticketCommission"] ?? 0.0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "amount": amount,
        "currentAmount": currentAmount,
        "available": available,
        "eventDate": eventDate,
        "eventId": eventId,
        "eventName": eventName,
        "ticketsTypeId": ticketsTypeId,
        "ticketsTypeEncoderCode": ticketsTypeEncoderCode,
        "ticketsTypeEncoderName": ticketsTypeEncoderName,
        "ticketsTypeEncoderDescription": ticketsTypeEncoderDescription,
        "ticketCommission": ticketCommission,
    };

    EventTicketsDTO copyWith({
        int? id,
        String? name,
        double? price,
        int? amount,
        int? currentAmount,
        bool? available,
        String? eventDate,
        int? eventId,
        String? eventName,
        int? ticketsTypeId,
        String? ticketsTypeEncoderCode,
        String? ticketsTypeEncoderName,
        String? ticketsTypeEncoderDescription,
    }) => 
        EventTicketsDTO(
            id: id ?? this.id,
            name: name ?? this.name,
            price: price ?? this.price,
            amount: amount ?? this.amount,
            currentAmount: currentAmount ?? this.currentAmount,
            available: available ?? this.available,
            eventDate: eventDate ?? this.eventDate,
            eventId: eventId ?? this.eventId,
            eventName: eventName ?? this.eventName,
            ticketsTypeId: ticketsTypeId ?? this.ticketsTypeId,
            ticketsTypeEncoderCode: ticketsTypeEncoderCode ?? this.ticketsTypeEncoderCode,
            ticketsTypeEncoderName: ticketsTypeEncoderName ?? this.ticketsTypeEncoderName,
            ticketsTypeEncoderDescription: ticketsTypeEncoderDescription ?? this.ticketsTypeEncoderDescription,
        );
}
