class Dob {
    int day;
    int month;
    int year;

    Dob({
        required this.day,
        required this.month,
        required this.year,
    });

    factory Dob.fromJson(Map<String, dynamic> json) => Dob(
        day: json["day"] ?? 0,
        month: json["month"] ?? 0,
        year: json["year"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
    };
}