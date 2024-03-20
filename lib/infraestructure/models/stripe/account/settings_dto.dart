
import 'package:my_app/infraestructure/models/stripe/account/dashboard_dto.dart';
import 'package:my_app/infraestructure/models/stripe/card/card_issuing_dto.dart';
import 'package:my_app/infraestructure/models/stripe/card/card_payments_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/metadata_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/payments_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/payouts_dto.dart';

class Settings {
    MetadataDTO bacsDebitPayments;
    MetadataDTO branding;
    CardIssuing cardIssuing;
    CardPayments cardPayments;
    Dashboard dashboard;
    Payments payments;
    Payouts payouts;
    MetadataDTO sepaDebitPayments;

    Settings({
        required this.bacsDebitPayments,
        required this.branding,
        required this.cardIssuing,
        required this.cardPayments,
        required this.dashboard,
        required this.payments,
        required this.payouts,
        required this.sepaDebitPayments,
    });

    factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        bacsDebitPayments: json["bacs_debit_payments"] != null ? MetadataDTO.fromJson(json["bacs_debit_payments"]) : MetadataDTO.fromJson({}),
        branding: json["branding"] != null ? MetadataDTO.fromJson(json["branding"]) : MetadataDTO.fromJson({}),
        cardIssuing: json["cardIssuing"] != null ? CardIssuing.fromJson(json["card_issuing"]) : CardIssuing.fromJson({}),
        cardPayments: json["cardPayments"] != null ? CardPayments.fromJson(json["card_payments"]) : CardPayments.fromJson({}),
        dashboard: json["dashboard"] != null ? Dashboard.fromJson(json["dashboard"]) : Dashboard.fromJson({}),
        payments: json["payments"] != null ? Payments.fromJson(json["payments"]) : Payments.fromJson({}),
        payouts: json["payouts"] != null ? Payouts.fromJson(json["payouts"]) : Payouts.fromJson({}),
        sepaDebitPayments: json["sepaDebitPayments"] != null ? MetadataDTO.fromJson(json["sepa_debit_payments"]) : MetadataDTO.fromJson({}),
    );

    Map<String, dynamic> toJson() => {
        "bacs_debit_payments": bacsDebitPayments.toJson(),
        "branding": branding.toJson(),
        "card_issuing": cardIssuing.toJson(),
        "card_payments": cardPayments.toJson(),
        "dashboard": dashboard.toJson(),
        "payments": payments.toJson(),
        "payouts": payouts.toJson(),
        "sepa_debit_payments": sepaDebitPayments.toJson(),
    };
}
