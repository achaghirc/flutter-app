// To parse this JSON data, do
//
//     final customFinancialConnectionState = customFinancialConnectionStateFromJson(jsonString);

import 'dart:convert';

import 'package:my_app/infraestructure/models/stripe/bankaccount/custom_account.dart';
import 'package:my_app/infraestructure/models/stripe/bankaccount/custom_account_holder.dart';

CustomFinancialConnectionState customFinancialConnectionStateFromJson(String str) => CustomFinancialConnectionState.fromJson(json.decode(str));

String customFinancialConnectionStateToJson(CustomFinancialConnectionState data) => json.encode(data.toJson());

class CustomFinancialConnectionState {
    CustomAccountHolder accountHolder;
    CustomAccounts accounts;
    String clientSecret;
    String id;
    bool livemode;
    String object;
    List<String> permissions;
    List<dynamic> prefetch;

    CustomFinancialConnectionState({
        required this.accountHolder,
        required this.accounts,
        required this.clientSecret,
        required this.id,
        required this.livemode,
        required this.object,
        required this.permissions,
        required this.prefetch,
    });

    factory CustomFinancialConnectionState.fromJson(Map<String, dynamic> json) => CustomFinancialConnectionState(
        accountHolder: CustomAccountHolder.fromJson(json["account_holder"]),
        accounts: CustomAccounts.fromJson(json["accounts"]),
        clientSecret: json["client_secret"],
        id: json["id"],
        livemode: json["livemode"],
        object: json["object"],
        permissions: List<String>.from(json["permissions"].map((x) => x)),
        prefetch: List<dynamic>.from(json["prefetch"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "account_holder": accountHolder.toJson(),
        "accounts": accounts.toJson(),
        "client_secret": clientSecret,
        "id": id,
        "livemode": livemode,
        "object": object,
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
        "prefetch": List<dynamic>.from(prefetch.map((x) => x)),
    };
}



class Customer {
    String id;

    Customer({
        required this.id,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}

