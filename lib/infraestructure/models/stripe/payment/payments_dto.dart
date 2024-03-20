class Payments {
    String statementDescriptor;

    Payments({
        required this.statementDescriptor,
    });

    factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        statementDescriptor: json["statement_descriptor"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "statement_descriptor": statementDescriptor,
    };
}