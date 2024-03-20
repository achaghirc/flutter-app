class TosAcceptance {
    int date;
    String ip;
    String userAgent;

    TosAcceptance({
        required this.date,
        required this.ip,
        required this.userAgent,
    });

    factory TosAcceptance.fromJson(Map<String, dynamic> json) => TosAcceptance(
        date: json["date"] ?? 0,
        ip: json["ip"] ?? '',
        userAgent: json["user_agent"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "ip": ip,
        "user_agent": userAgent,
    };
}
