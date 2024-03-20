class CustomAccounts {
    String object;
    List<dynamic> data;
    bool hasMore;
    String url;

    CustomAccounts({
        required this.object,
        required this.data,
        required this.hasMore,
        required this.url,
    });

    factory CustomAccounts.fromJson(Map<String, dynamic> json) => CustomAccounts(
        object: json["object"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
        hasMore: json["hasMore"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x)),
        "hasMore": hasMore,
        "url": url,
    };
}
