class Requirements {
    List<dynamic> alternatives;
    List<String> currentlyDue;
    List<dynamic> errors;
    List<String> eventuallyDue;
    List<String> pastDue;
    List<dynamic> pendingVerification;
    String? disabledReason;

    Requirements({
        required this.alternatives,
        required this.currentlyDue,
        required this.errors,
        required this.eventuallyDue,
        required this.pastDue,
        required this.pendingVerification,
        this.disabledReason,
    });

    factory Requirements.fromJson(Map<String, dynamic> json) => Requirements(
        alternatives: json["alternatives"] != null ? List<dynamic>.from(json["alternatives"].map((x) => x)) : List.empty(),
        currentlyDue: json["currentlyDue"] != null ? List<String>.from(json["currently_due"].map((x) => x)) : List.empty(),
        errors: json["errors"] != null ? List<dynamic>.from(json["errors"].map((x) => x)) : List.empty(),
        eventuallyDue: json["eventuallyDue"] != null ? List<String>.from(json["eventually_due"].map((x) => x)) : List.empty(),
        pastDue: json["pastDue"] != null ? List<String>.from(json["past_due"].map((x) => x)) : List.empty(),
        pendingVerification: json["pendingVerification"] != null ? List<dynamic>.from(json["pending_verification"].map((x) => x)) : List.empty(),
        disabledReason: json["disabledReason"] != null ? json["disabled_reason"] : '',
    );

    Map<String, dynamic> toJson() => {
        "alternatives": List<dynamic>.from(alternatives.map((x) => x)),
        "currently_due": List<dynamic>.from(currentlyDue.map((x) => x)),
        "errors": List<dynamic>.from(errors.map((x) => x)),
        "eventually_due": List<dynamic>.from(eventuallyDue.map((x) => x)),
        "past_due": List<dynamic>.from(pastDue.map((x) => x)),
        "pending_verification": List<dynamic>.from(pendingVerification.map((x) => x)),
        "disabled_reason": disabledReason,
    };
}