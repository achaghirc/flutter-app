import 'package:my_app/infraestructure/models/stripe/account/document_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/metadata_dto.dart';

class IndividualVerification {
    MetadataDTO additionalDocument;
    Document document;
    String status;

    IndividualVerification({
        required this.additionalDocument,
        required this.document,
        required this.status,
    });

    factory IndividualVerification.fromJson(Map<String, dynamic> json) => IndividualVerification(
        additionalDocument: json["additional_document"] != null ? MetadataDTO.fromJson(json["additional_document"]) : MetadataDTO.fromJson({}),
        document: json["document"] != null ? Document.fromJson(json["document"]) : Document.fromJson({}),
        status: json["status"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "additional_document": additionalDocument.toJson(),
        "document": document.toJson(),
        "status": status,
    };
}