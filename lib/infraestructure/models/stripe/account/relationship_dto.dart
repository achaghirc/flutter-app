class Relationship {
    bool director;
    bool executive;
    bool owner;
    bool representative;

    Relationship({
        required this.director,
        required this.executive,
        required this.owner,
        required this.representative,
    });

    factory Relationship.fromJson(Map<String, dynamic> json) => Relationship(
        director: json["director"] ?? false,
        executive: json["executive"] ?? false,
        owner: json["owner"] ?? false,
        representative: json["representative"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "director": director,
        "executive": executive,
        "owner": owner,
        "representative": representative,
    };
}