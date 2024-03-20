class Schedule {
    int delayDays;
    String interval;

    Schedule({
        required this.delayDays,
        required this.interval,
    });

    factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        delayDays: json["delay_days"],
        interval: json["interval"],
    );

    Map<String, dynamic> toJson() => {
        "delay_days": delayDays,
        "interval": interval,
    };
}
