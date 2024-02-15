import 'package:my_app/globals.dart' as globals;

class EventPublicRelationDataDTO {
    int? id;
    String userUsername;
    String userPersonName;
    String userPersonLastName;
    int amountSold;
    int totalEvents;
    double profit;
    double totalIncome;

    EventPublicRelationDataDTO({
        this.id,
        required this.userUsername,
        required this.userPersonName,
        required this.userPersonLastName,
        required this.amountSold,
        required this.totalEvents,
        required this.profit,
        required this.totalIncome,
    });

    factory EventPublicRelationDataDTO.fromJson(Map<String, dynamic> json) => EventPublicRelationDataDTO(
      id: json['id'] ?? 0, 
      userUsername: json['userUsername'] ?? '', 
      userPersonName: json['userPersonName'] ?? '', 
      userPersonLastName: json['userPersonLastName'] ?? '', 
      amountSold: json['amountSold'] ?? 0, 
      totalEvents: json['totalEvents'] ?? 0, 
      profit: globals.buildTicketPrice(json['profit']), 
      totalIncome:json['totalIncome'] != null ? globals.buildTicketPrice(json['totalIncome']) : 0.0 
    );

    EventPublicRelationDataDTO copyWith({
        dynamic id,
        String? userUsername,
        String? userPersonName,
        String? userPersonLastName,
        int? amountSold,
        int? totalEvents,
        double? profit,
        double? totalIncome,
    }) => 
        EventPublicRelationDataDTO(
            id: id ?? this.id,
            userUsername: userUsername ?? this.userUsername,
            userPersonName: userPersonName ?? this.userPersonName,
            userPersonLastName: userPersonLastName ?? this.userPersonLastName,
            amountSold: amountSold ?? this.amountSold,
            totalEvents: totalEvents ?? this.totalEvents,
            profit: profit ?? this.profit,
            totalIncome: totalIncome ?? this.totalIncome,
        );
}
