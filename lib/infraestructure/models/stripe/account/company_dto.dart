
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_app/infraestructure/models/stripe/account/company_verification_dto.dart';

class Company {
    Address address;
    bool directorsProvided;
    bool executivesProvided;
    bool ownersProvided;
    String phone;
    bool taxIdProvided;
    CompanyVerification verification;

    Company({
        required this.address,
        required this.directorsProvided,
        required this.executivesProvided,
        required this.ownersProvided,
        required this.phone,
        required this.taxIdProvided,
        required this.verification,
    });

    factory Company.fromJson(Map<String, dynamic> json) => Company(
        address: json["address"] != null ? Address.fromJson(json["address"]) : Address.fromJson({}),
        directorsProvided: json["directors_provided"] != null ? json['directors_provided'] : false,
        executivesProvided: json["executives_provided"] != null ? json['executives_provided'] : false,
        ownersProvided: json["owners_provided"] != null ? json['owners_provided'] : false,
        phone: json["phone"] ?? '',
        taxIdProvided: json["tax_id_provided"] ?? false,
        verification: json["verification"] != null ? CompanyVerification.fromJson(json["verification"]) : CompanyVerification.fromJson({}),
    );

    Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "directors_provided": directorsProvided,
        "executives_provided": executivesProvided,
        "owners_provided": ownersProvided,
        "phone": phone,
        "tax_id_provided": taxIdProvided,
        "verification": verification.toJson(),
    };
}