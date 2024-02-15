import 'package:my_app/infraestructure/models/stripe/payment/address_dto.dart';

class BillingDetailsDTO {
    AddressDTO address;

    BillingDetailsDTO({
        required this.address,
    });

    factory BillingDetailsDTO.fromJson(Map<String, dynamic> json) => BillingDetailsDTO(
      address: AddressDTO.fromJson(json["address"])
    );

    BillingDetailsDTO copyWith({
        AddressDTO? address,
    }) => 
        BillingDetailsDTO(
            address: address ?? this.address,
        );
}