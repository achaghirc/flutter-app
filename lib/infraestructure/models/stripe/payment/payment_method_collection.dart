import 'package:my_app/infraestructure/models/stripe/payment/payment_method_dto.dart';

class PaymentMethodCollection {
    String object;
    List<PaymentMethodDTO> data;
    bool? hasMore;
    String? url;

    PaymentMethodCollection({
        required this.object,
        required this.data,
        this.hasMore,
        this.url
    });

    factory PaymentMethodCollection.fromJson(Map<String, dynamic> json) => PaymentMethodCollection(
      object: json["object"],
      data: List<PaymentMethodDTO>.from(json["data"].map((element) => PaymentMethodDTO.fromJson(element))), 
      hasMore: json["hasMore"],
      url: json["url"]
    );

    PaymentMethodCollection copyWith({
        String? object,
        List<PaymentMethodDTO>? data,
        bool? hasMore,
        String? url,
    }) => 
        PaymentMethodCollection(
            object: object ?? this.object,
            data: data ?? this.data,
            hasMore: hasMore ?? this.hasMore,
            url: url ?? this.url,
        );
}

