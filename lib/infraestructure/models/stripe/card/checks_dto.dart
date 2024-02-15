class ChecksDTO {
    String cvcCheck;

    ChecksDTO({
        required this.cvcCheck,
    });

    ChecksDTO copyWith({
        String? cvcCheck,
    }) => 
        ChecksDTO(
            cvcCheck: cvcCheck ?? this.cvcCheck,
        );

  factory  ChecksDTO.fromJson(Map<String, dynamic> json) => ChecksDTO(
    cvcCheck: json["cvc_check"] ?? ""
  );
}