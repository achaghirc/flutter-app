class CustomerDTO {
    String id;

    CustomerDTO({
        required this.id,
    });

    factory CustomerDTO.fromJson(Map<String, dynamic> json) => CustomerDTO(
      id: json["id"]
    );

    CustomerDTO copyWith({
        String? id,
    }) => 
        CustomerDTO(
            id: id ?? this.id,
        );
}