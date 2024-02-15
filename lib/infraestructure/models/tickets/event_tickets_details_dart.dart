
class EventTicketsDetailsDTO {

  int amountSold;
  int amountRemaining;
  double totalIncome;


  EventTicketsDetailsDTO({
    required this.amountSold,
    required this.amountRemaining,
    required this.totalIncome
  });

  factory EventTicketsDetailsDTO.fromJson(Map<String ,dynamic> json) => EventTicketsDetailsDTO(
    amountSold: json['amountSold'], 
    amountRemaining: json['amountRemaining'], 
    totalIncome: json['totalIncome']
  );

  Map<String, dynamic> toJson() => {
    "amountSold":amountSold,
    "amountRemaining":amountRemaining,
    "totalIncome":totalIncome,
  };

}