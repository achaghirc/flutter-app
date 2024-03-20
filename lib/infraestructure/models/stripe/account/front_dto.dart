class Front {
    String id;

    Front({
        required this.id,
    });

    factory Front.fromJson(Map<String, dynamic> json) => Front(
        id: json["id"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}