import 'package:my_app/infraestructure/models/stripe/payment/schedule_dto.dart';

class Payouts {
    bool debitNegativeBalances;
    Schedule schedule;

    Payouts({
        required this.debitNegativeBalances,
        required this.schedule,
    });

    factory Payouts.fromJson(Map<String, dynamic> json) => Payouts(
        debitNegativeBalances: json["debit_negative_balances"] ?? false,
        schedule: json["schedule"] != null ? Schedule.fromJson(json["schedule"]) : Schedule.fromJson({}),
    );

    Map<String, dynamic> toJson() => {
        "debit_negative_balances": debitNegativeBalances,
        "schedule": schedule.toJson(),
    };
}