class BusinessProfile {
    String mcc;
    String url;

    BusinessProfile({
        required this.mcc,
        required this.url,
    });

    factory BusinessProfile.fromJson(Map<String, dynamic> json) => BusinessProfile(
        mcc: json["mcc"] ?? '',
        url: json["url"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "mcc": mcc,
        "url": url,
    };
}


