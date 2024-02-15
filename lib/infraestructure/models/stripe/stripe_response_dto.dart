import 'package:http/http.dart';

class ResponseStripePayment {


  String paymentIntent;
  String paymentIntentId;
  String? ephemeralKey;
  String? customer;
  bool success;


  ResponseStripePayment({
    required this.paymentIntent,
    required this.paymentIntentId,
    this.ephemeralKey,
    this.customer,
    required this.success
  });


  factory ResponseStripePayment.fromJson(Map<String, dynamic> json) => ResponseStripePayment(
    paymentIntent: json['paymentIntent'], 
    paymentIntentId: json['paymentIntentId'],
    ephemeralKey: json['ephemeralKey'] ?? '',
    customer: json['customer'] ?? '',
    success: json['success']
  );

  Map<String, dynamic> toJson() => {
    "paymentIntent": paymentIntent,
    "paymentIntentId": paymentIntentId,
    if(ephemeralKey != null) "ephemeralKey": ephemeralKey,
    if(customer != null) "customer": customer,
    "success": success,
  };

}