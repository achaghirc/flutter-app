import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_app/infraestructure/models/stripe/card/card_dto.dart';
import 'package:my_app/infraestructure/models/stripe/customer/customer_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/metadata_dto.dart';

class PaymentMethodDTO {
    BillingDetails billingDetails;
    CardDTO card;
    int created;
    CustomerDTO customer;
    String id;
    bool livemode;
    MetadataDTO metadata;
    String object;
    String type;

    PaymentMethodDTO({
        required this.billingDetails,
        required this.card,
        required this.created,
        required this.customer,
        required this.id,
        required this.livemode,
        required this.metadata,
        required this.object,
        required this.type,
    });

    PaymentMethodDTO copyWith({
        BillingDetails? billingDetails,
        CardDTO? card,
        int? created,
        CustomerDTO? customer,
        String? id,
        bool? livemode,
        MetadataDTO? metadata,
        String? object,
        String? type,
    }) => 
        PaymentMethodDTO(
            billingDetails: billingDetails ?? this.billingDetails,
            card: card ?? this.card,
            created: created ?? this.created,
            customer: customer ?? this.customer,
            id: id ?? this.id,
            livemode: livemode ?? this.livemode,
            metadata: metadata ?? this.metadata,
            object: object ?? this.object,
            type: type ?? this.type,
        );

  factory PaymentMethodDTO.fromJson(Map<String, dynamic> json)  => PaymentMethodDTO(
    billingDetails : BillingDetails.fromJson(json["billing_details"]),
    card : CardDTO.fromJson(json["card"]),
    created : json["created"],
    customer : CustomerDTO.fromJson(json["customer"]),
    id : json["id"],
    livemode : json["livemode"],
    metadata : MetadataDTO.fromJson(json["metadata"]),
    object : json["object"],
    type : json["type"],

  );
}







