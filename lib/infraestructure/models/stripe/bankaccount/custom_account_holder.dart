import 'package:my_app/infraestructure/models/stripe/customer/customer_dto.dart';

class CustomAccountHolder {
    CustomerDTO customer;
    String type;

    CustomAccountHolder({
        required this.customer,
        required this.type,
    });

    factory CustomAccountHolder.fromJson(Map<String, dynamic> json) => CustomAccountHolder(
        customer: CustomerDTO.fromJson(json["customer"]),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "customer": customer.toJson(),
        "type": type,
    };
}