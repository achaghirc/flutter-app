

import 'package:my_app/infraestructure/models/stripe/account/account_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/account_link_dto.dart';
import 'package:my_app/infraestructure/models/stripe/bankaccount/custom_financial_connection_state.dart';
import 'package:my_app/infraestructure/models/stripe/customer/customer_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/payment_method_collection.dart';
import 'package:my_app/infraestructure/models/stripe/request_dto.dart';
import 'package:my_app/infraestructure/models/stripe/stripe_response_dto.dart';

abstract class StripeRepository {

  Future<CustomerDTO> createOrRetrieveCustomer(String userId);
  Future<ResponseStripePayment> createPaymentIntent(RequestDTO requestDTO);
  Future<ResponseStripePayment> cancelPaymentIntent(String paymentIntentId);
  Future<PaymentMethodCollection> listCustomerCards(String userId);
  Future<CustomFinancialConnectionState> retrieveSessionClientSecret(String userId);
  Future<List<Account>> retrieveAccounts(String id);
  Future<Map<String,dynamic>> createAccount(String personEmail, String externalBankAccountId);
  Future<AccountLink> getAccountLink(String userId);
  Future<String> deleteAccount(String id);
} 