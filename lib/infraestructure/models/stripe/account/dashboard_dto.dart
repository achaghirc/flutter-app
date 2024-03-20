class Dashboard {
    String displayName;
    String timezone;

    Dashboard({
        required this.displayName,
        required this.timezone,
    });

    factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        displayName: json["display_name"] ?? '',
        timezone: json["timezone"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "timezone": timezone,
    };
}