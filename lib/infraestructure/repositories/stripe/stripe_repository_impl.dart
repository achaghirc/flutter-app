import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:my_app/domain/repositories/stripe_repository.dart';
import 'package:my_app/infraestructure/models/stripe/payment/payment_method_collection.dart';
import 'package:my_app/infraestructure/models/stripe/request_dto.dart';
import 'package:my_app/infraestructure/models/stripe/stripe_response_dto.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.stripeUrl();

class StripeRepositoryImpl extends BasicService implements StripeRepository {
  StripeRepositoryImpl(super.session);

  @override
  Future<ResponseStripePayment> createPaymentIntent(RequestDTO requestDTO) async{
    // TODO: implement createPaymentIntent
    Response res = await postCall(
      baseURL,
      '/stripe/payment/paymentIntent',
      body: jsonEncode(requestDTO),
    );

    if(res.statusCode == 200){
      return ResponseStripePayment.fromJson(jsonDecode(res.body));
    }else {
      throw Exception("Payment Intent error");
    }
  }
  
  @override
  Future<ResponseStripePayment> cancelPaymentIntent(String paymentIntentId) async{
    Response res = await getCall(
      baseURL,
      '/stripe/payment/cancelPaymentIntent',
      queryParameters: {
        "paymentIntentId": paymentIntentId
      }
    );

    if(res.statusCode == 200){
      return ResponseStripePayment.fromJson(jsonDecode(res.body));
    }else {
      throw Exception("Cancel Payment Intent error");
    }
  }

  @override
  Future<PaymentMethodCollection> listCustomerCards(String userId) async{
    Response res = await getCall(
      baseURL,
      '/stripe/cards',
      queryParameters: {
        "userId": userId
      }
    );

    if(res.statusCode == 200){
      return PaymentMethodCollection.fromJson(jsonDecode(res.body));
    }else {
      throw Exception("Cancel Payment Intent error");
    }
  }
  
}