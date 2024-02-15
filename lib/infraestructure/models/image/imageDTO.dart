import 'dart:convert';

import 'package:flutter/foundation.dart';

class ImageDTO {

  late int? id;
  late String title;
  late String type;
  late Uint8List data;


  ImageDTO({
    this.id,
    required this.title,
    required this.type,
    required this.data,
  });

  static Map<String, dynamic> toJson(ImageDTO image){
    return {
      "id" : image.id ?? 0,
      "title": image.title,
      "mimeType": image.type,
      "data": image.data,
    };
  }

  factory ImageDTO.fromJson(Map<String, dynamic> json){
    return ImageDTO(
        id: json["id"] ?? 0,
        title: json["title"],
        type: json["type"],
        data: base64Decode(json["data"]),
    );
  }



}