class NetworksDTO {
  List<String> available;

  NetworksDTO({
      required this.available,
  });

  factory NetworksDTO.fromJson(Map<String, dynamic> json) => NetworksDTO(
    available: List<String>.from(json["available"])
  );

  NetworksDTO copyWith({
      List<String>? available,
  }) => 
      NetworksDTO(
          available: available ?? this.available,
      );
}