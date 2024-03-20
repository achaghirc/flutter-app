class DeclineOn {
    bool avsFailure;
    bool cvcFailure;

    DeclineOn({
        required this.avsFailure,
        required this.cvcFailure,
    });

    factory DeclineOn.fromJson(Map<String, dynamic> json) => DeclineOn(
        avsFailure: json["avs_failure"] ?? false,
        cvcFailure: json["cvc_failure"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "avs_failure": avsFailure,
        "cvc_failure": cvcFailure,
    };
}