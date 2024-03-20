// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

import 'package:my_app/infraestructure/models/stripe/account/business_profile_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/capabilities_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/company_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/external_account_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/individual_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/requirements_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/settings_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/tos_acceptance_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/metadata_dto.dart';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
    BusinessProfile businessProfile;
    String businessType;
    Capabilities capabilities;
    bool chargesEnabled;
    Company company;
    String country;
    int created;
    String defaultCurrency;
    bool detailsSubmitted;
    String email;
    ExternalAccounts externalAccounts;
    Requirements futureRequirements;
    String id;
    Individual individual;
    MetadataDTO metadata;
    String object;
    bool payoutsEnabled;
    Requirements requirements;
    Settings settings;
    TosAcceptance tosAcceptance;
    String type;

    Account({
        required this.businessProfile,
        required this.businessType,
        required this.capabilities,
        required this.chargesEnabled,
        required this.company,
        required this.country,
        required this.created,
        required this.defaultCurrency,
        required this.detailsSubmitted,
        required this.email,
        required this.externalAccounts,
        required this.futureRequirements,
        required this.id,
        required this.individual,
        required this.metadata,
        required this.object,
        required this.payoutsEnabled,
        required this.requirements,
        required this.settings,
        required this.tosAcceptance,
        required this.type,
    });

    factory Account.fromJson(Map<String, dynamic> json) => Account(
        businessProfile: BusinessProfile.fromJson(json["business_profile"]),
        businessType: json["business_type"] ?? '',
        capabilities: Capabilities.fromJson(json["capabilities"]),
        chargesEnabled: json["charges_enabled"],
        company: json["company"] != null ? Company.fromJson(json["company"]) : Company.fromJson({}),
        country: json["country"],
        created: json["created"],
        defaultCurrency: json["default_currency"] ?? '',
        detailsSubmitted: json["details_submitted"] ?? '',
        email: json["email"] ?? '',
        externalAccounts: json["external_accounts"] != null ? ExternalAccounts.fromJson(json["external_accounts"]) : ExternalAccounts.fromJson({}),
        futureRequirements: json["future_requirements"] != null ? Requirements.fromJson(json["future_requirements"]) : Requirements.fromJson({}),
        id: json["id"],
        individual: json["individual"] != null ? Individual.fromJson(json["individual"]) : Individual.fromJson({}),
        metadata: json["metadata"] != null ? MetadataDTO.fromJson(json["metadata"]) : MetadataDTO.fromJson({}),
        object: json["object"],
        payoutsEnabled: json["payouts_enabled"],
        requirements: json["requirements"] != null ? Requirements.fromJson(json["requirements"]) : Requirements.fromJson({}),
        settings: json["settings"] != null ? Settings.fromJson(json["settings"]) : Settings.fromJson({}),
        tosAcceptance: json["tos_acceptance"] != null ? TosAcceptance.fromJson(json["tos_acceptance"]) : TosAcceptance.fromJson({}),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "business_profile": businessProfile.toJson(),
        "business_type": businessType,
        "capabilities": capabilities.toJson(),
        "charges_enabled": chargesEnabled,
        "company": company.toJson(),
        "country": country,
        "created": created,
        "default_currency": defaultCurrency,
        "details_submitted": detailsSubmitted,
        "email": email,
        "external_accounts": externalAccounts.toJson(),
        "future_requirements": futureRequirements.toJson(),
        "id": id,
        "individual": individual.toJson(),
        "metadata": metadata.toJson(),
        "object": object,
        "payouts_enabled": payoutsEnabled,
        "requirements": requirements.toJson(),
        "settings": settings.toJson(),
        "tos_acceptance": tosAcceptance.toJson(),
        "type": type,
    };
}
