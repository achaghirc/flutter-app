

import 'package:my_app/infraestructure/models/stripe/payment/payment_method_collection.dart';
import 'package:my_app/infraestructure/models/stripe/request_dto.dart';
import 'package:my_app/infraestructure/models/stripe/stripe_response_dto.dart';

abstract class StripeRepository {


  Future<ResponseStripePayment> createPaymentIntent(RequestDTO requestDTO);
  Future<ResponseStripePayment> cancelPaymentIntent(String paymentIntentId);
  Future<PaymentMethodCollection> listCustomerCards(String userId);
} 