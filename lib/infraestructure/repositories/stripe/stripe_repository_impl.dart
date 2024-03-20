import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:my_app/domain/repositories/stripe_repository.dart';
import 'package:my_app/infraestructure/models/stripe/account/account_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/account_link_dto.dart';
import 'package:my_app/infraestructure/models/stripe/bankaccount/custom_financial_connection_state.dart';
import 'package:my_app/infraestructure/models/stripe/customer/customer_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/payment_method_collection.dart';
import 'package:my_app/infraestructure/models/stripe/request_dto.dart';
import 'package:my_app/infraestructure/models/stripe/stripe_response_dto.dart';
import 'package:my_app/shared/services/basic_service.dart';

final baseURL = globals.stripeUrl();

class StripeRepositoryImpl extends BasicService implements StripeRepository {
  StripeRepositoryImpl(super.session);

  @override
  Future<CustomerDTO> createOrRetrieveCustomer(String userId) async {
    Response res = await getCall(
      baseURL,
      '/stripe/customer/',
      queryParameters: {
        "userId": userId
      }
    );
    if(res.statusCode == 200){
      return CustomerDTO.fromJson(jsonDecode(res.body));
    }else {
      throw Exception("Error creating or retrieving a Customer");
    }
  }

  @override
  Future<ResponseStripePayment> createPaymentIntent(RequestDTO requestDTO) async{
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
  @override
  Future<CustomFinancialConnectionState> retrieveSessionClientSecret(String userId) async {
    Response res = await getCall(
      baseURL,
      '/stripe/accounts/financialSession',
      queryParameters: {
        "userId": userId
      }
    );

    if(res.statusCode == 200){
      return CustomFinancialConnectionState.fromJson(jsonDecode(res.body));
    }else {
      throw Exception("Error creating a financial session: ${jsonDecode(res.body)}");
    }
  }

  @override
  Future<Map<String, dynamic>> createAccount(String personEmail, String externalBankAccountId) async{
    Response res = await postCall(
      baseURL, 
      '/stripe/accounts',
      queryParameters: {
        "email": personEmail,
        "externalBankAccountId": externalBankAccountId
      });

      if(res.statusCode == 200) {
        return jsonDecode(res.body);
      }else{
        throw Exception("Error creating the account.");
      }
  }
  @override
  Future<AccountLink> getAccountLink(String userId) async {
    Response res = await getCall(
      baseURL,
      '/stripe/accounts/accountLink',
      queryParameters: {
        "userId": userId
      });

      if (res.statusCode == 200) {
        return AccountLink.fromJson(jsonDecode(res.body));
      } else {
        throw Exception("Error generating the Account Link: ${res.body}");
      }
  }

  @override
  Future<List<Account>> retrieveAccounts(String id) async {
    try {

    Response res = await getCall(
      baseURL, 
      '/stripe/accounts',
      queryParameters: {
        "userId" : id      
        }
      );
      if(res.statusCode == 200){
        Iterable accounts = json.decode(utf8.decode(res.bodyBytes));
        return List<Account>.from(accounts.map((account) => Account.fromJson(account)));
      } else {
        return List.empty();
      }
    } catch(e){
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<String> deleteAccount(String id) async {
    Response res = await deleteCall(
      baseURL, 
      '/stripe/accounts',
      queryParameters: {
        "userId": id
      });

      if(res.statusCode == 200){
        return jsonDecode(res.body);
      }else{
        return jsonDecode(res.body);
      }


  }
}