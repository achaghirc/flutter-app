import 'package:my_app/infraestructure/models/stripe/account/front_dto.dart';

class Document {
    Front front;

    Document({
        required this.front,
    });

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        front: json["front"] != null ? Front.fromJson(json["front"]) : Front.fromJson({}),
    );

    Map<String, dynamic> toJson() => {
        "front": front.toJson(),
    };
}