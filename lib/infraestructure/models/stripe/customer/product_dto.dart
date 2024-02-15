

class ProductDTO {

  String name;
  String id;
  double unitAmountDecimal;
  String currency;

  ProductDTO({
    required this.name,
    required this.id,
    required this.unitAmountDecimal,
    required this.currency
  });

  factory ProductDTO.fromJson(Map<String, dynamic> json) => ProductDTO(
    name: json["name"], 
    id: json["id"], 
    unitAmountDecimal: json["unitAmountDecimal"], 
    currency: json["currency"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "unitAmountDecimal": unitAmountDecimal,
    "currency": currency,
  };


}