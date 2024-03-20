import 'dart:convert';

AccountLink accountLinkFromJson(String str) => AccountLink.fromJson(json.decode(str));

String accountLinkToJson(AccountLink data) => json.encode(data.toJson());

class AccountLink {
    int created;
    int expiresAt;
    String object;
    String url;

    AccountLink({
        required this.created,
        required this.expiresAt,
        required this.object,
        required this.url,
    });

    factory AccountLink.fromJson(Map<String, dynamic> json) => AccountLink(
        created: json["created"],
        expiresAt: json["expires_at"],
        object: json["object"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "created": created,
        "expires_at": expiresAt,
        "object": object,
        "url": url,
    };
}
