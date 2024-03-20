import 'package:my_app/infraestructure/models/stripe/card/decline_on_dto.dart';

class CardPayments {
    DeclineOn declineOn;

    CardPayments({
        required this.declineOn,
    });

    factory CardPayments.fromJson(Map<String, dynamic> json) => CardPayments(
        declineOn: json["declineOn"] != null ? DeclineOn.fromJson(json["decline_on"]) : DeclineOn.fromJson({}),
    );

    Map<String, dynamic> toJson() => {
        "decline_on": declineOn.toJson(),
    };
}