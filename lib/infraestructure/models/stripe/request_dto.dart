

import 'package:my_app/infraestructure/models/stripe/customer/product_dto.dart';
import 'package:my_app/infraestructure/models/tickets/tickets_dto.dart';

class RequestDTO {

  String customerEmail;
  String customerUsername;
  List<ProductDTO> items;
  double platformCommission;
  double rrppCommission;
  double ticketsAmount;


  RequestDTO({
    required this.customerEmail,
    required this.customerUsername,
    required this.items,
    required this.platformCommission,
    required this.rrppCommission,
    required this.ticketsAmount,
  });


  factory RequestDTO.fromJson(Map<String, dynamic> json) => RequestDTO(
    customerEmail: json['customerEmail'], 
    customerUsername: json['customerUsername'],
    items: json["items"],
    platformCommission: json["platformCommission"], 
    rrppCommission: json["rrppCommission"], 
    ticketsAmount: json["ticketsAmount"], 
  );


  Map<String, dynamic> toJson() => {
    "customerEmail": customerEmail,
    "customerUsername": customerUsername,
    "items": items,
    "platformCommission": platformCommission,
    "rrppCommission": rrppCommission,
    "ticketsAmount": ticketsAmount,
  };

}