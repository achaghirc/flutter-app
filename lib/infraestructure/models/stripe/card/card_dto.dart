import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_app/infraestructure/models/stripe/card/checks_dto.dart';
import 'package:my_app/infraestructure/models/stripe/card/networs_dto.dart';

class CardDTO {
    String brand;
    ChecksDTO checks;
    String country;
    int expMonth;
    int expYear;
    String fingerprint;
    String funding;
    String last4;
    NetworksDTO networks;
    ThreeDSecureUsage threeDSecureUsage;

    CardDTO({
        required this.brand,
        required this.checks,
        required this.country,
        required this.expMonth,
        required this.expYear,
        required this.fingerprint,
        required this.funding,
        required this.last4,
        required this.networks,
        required this.threeDSecureUsage,
    });

    factory CardDTO.fromJson(Map<String, dynamic> json) => CardDTO(
      brand: json["brand"],
      checks: json["checks"] != null ? ChecksDTO.fromJson(json["checks"]) : ChecksDTO.fromJson({}),
      country: json["country"],
      expMonth: json["exp_month"],
      expYear: json["exp_year"],
      fingerprint: json["fingerprint"],
      funding: json["funding"],
      last4: json["last4"],
      networks: NetworksDTO.fromJson(json["networks"]),
      threeDSecureUsage: ThreeDSecureUsage.fromJson(json["three_d_secure_usage"]),
    );

    CardDTO copyWith({
        String? brand,
        ChecksDTO? checks,
        String? country,
        int? expMonth,
        int? expYear,
        String? fingerprint,
        String? funding,
        String? last4,
        NetworksDTO? networks,
        ThreeDSecureUsage? threeDSecureUsage,
    }) => 
        CardDTO(
            brand: brand ?? this.brand,
            checks: checks ?? this.checks,
            country: country ?? this.country,
            expMonth: expMonth ?? this.expMonth,
            expYear: expYear ?? this.expYear,
            fingerprint: fingerprint ?? this.fingerprint,
            funding: funding ?? this.funding,
            last4: last4 ?? this.last4,
            networks: networks ?? this.networks,
            threeDSecureUsage: threeDSecureUsage ?? this.threeDSecureUsage,
        );
}
