import 'package:my_app/infraestructure/models/stripe/payment/metadata_dto.dart';

class CompanyVerification {
    MetadataDTO document;

    CompanyVerification({
        required this.document,
    });

    factory CompanyVerification.fromJson(Map<String, dynamic> json) => CompanyVerification(
        document: json["document"] != null ? MetadataDTO.fromJson(json["document"]) : MetadataDTO.fromJson({}),
    );

    Map<String, dynamic> toJson() => {
        "document": document.toJson(),
    };
}