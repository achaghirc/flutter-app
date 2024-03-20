import 'package:my_app/infraestructure/models/stripe/payment/metadata_dto.dart';

class CardIssuing {
    MetadataDTO tosAcceptance;

    CardIssuing({
        required this.tosAcceptance,
    });

    factory CardIssuing.fromJson(Map<String, dynamic> json) => CardIssuing(
        tosAcceptance: json["tos_acceptance"] != null ? MetadataDTO.fromJson(json["tos_acceptance"]) : MetadataDTO.fromJson({}),
    );

    Map<String, dynamic> toJson() => {
        "tos_acceptance": tosAcceptance.toJson(),
    };
}