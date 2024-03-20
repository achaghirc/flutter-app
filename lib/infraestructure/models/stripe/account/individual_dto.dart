import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_app/infraestructure/models/stripe/account/dob_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/individual_verification_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/relationship_dto.dart';
import 'package:my_app/infraestructure/models/stripe/account/requirements_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/metadata_dto.dart';

class Individual {
    String account;
    Address address;
    int created;
    Dob dob;
    String email;
    String firstName;
    Requirements futureRequirements;
    String id;
    String lastName;
    MetadataDTO metadata;
    String object;
    String phone;
    Relationship relationship;
    Requirements requirements;
    IndividualVerification verification;

    Individual({
        required this.account,
        required this.address,
        required this.created,
        required this.dob,
        required this.email,
        required this.firstName,
        required this.futureRequirements,
        required this.id,
        required this.lastName,
        required this.metadata,
        required this.object,
        required this.phone,
        required this.relationship,
        required this.requirements,
        required this.verification,
    });

    factory Individual.fromJson(Map<String, dynamic> json) => Individual(
        account: json["account"] ?? '',
        address: json["address"] != null ? Address.fromJson(json["address"]) : Address.fromJson({}),
        created: json["created"] ?? 0,
        dob: json["dob"] != null ? Dob.fromJson(json["dob"]) : Dob.fromJson({}),
        email: json["email"] ?? '',
        firstName: json["firstName"] ?? '',
        futureRequirements: json["futureRequirements"] != null ? Requirements.fromJson(json["future_requirements"]) : Requirements.fromJson({}),
        id: json["id"] ?? '',
        lastName: json["lastName"] ?? '' ,
        metadata: json["metadata"] != null ? MetadataDTO.fromJson(json["metadata"]) : MetadataDTO.fromJson({}),
        object: json["object"] ?? '' ,
        phone: json["phone"] ?? '',
        relationship: json["relationship"] != null ? Relationship.fromJson(json["relationship"]) : Relationship.fromJson({}),
        requirements: json["requirements"] != null ? Requirements.fromJson(json["requirements"]) : Requirements.fromJson({}),
        verification: json["verification"] != null ? IndividualVerification.fromJson(json["verification"]) : IndividualVerification.fromJson({}),
    );

    Map<String, dynamic> toJson() => {
        "account": account,
        "address": address.toJson(),
        "created": created,
        "dob": dob.toJson(),
        "email": email,
        "first_name": firstName,
        "future_requirements": futureRequirements.toJson(),
        "id": id,
        "last_name": lastName,
        "metadata": metadata.toJson(),
        "object": object,
        "phone": phone,
        "relationship": relationship.toJson(),
        "requirements": requirements.toJson(),
        "verification": verification.toJson(),
    };
}