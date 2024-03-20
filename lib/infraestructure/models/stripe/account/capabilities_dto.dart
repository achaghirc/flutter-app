class Capabilities {
    String cardPayments;
    String transfers;

    Capabilities({
        required this.cardPayments,
        required this.transfers,
    });

    factory Capabilities.fromJson(Map<String, dynamic> json) => Capabilities(
        cardPayments: json["card_payments"],
        transfers: json["transfers"],
    );

    Map<String, dynamic> toJson() => {
        "card_payments": cardPayments,
        "transfers": transfers,
    };
}