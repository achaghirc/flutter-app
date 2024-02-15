class AddressDTO {
    String country;

    AddressDTO({
        required this.country,
    });

    factory AddressDTO.fromJson(Map<String, dynamic> json) => AddressDTO(
      country: json["country"]
    );

    AddressDTO copyWith({
        String? country,
    }) => 
        AddressDTO(
            country: country ?? this.country,
        );
}