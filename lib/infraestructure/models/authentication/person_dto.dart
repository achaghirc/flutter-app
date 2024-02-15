import 'dart:convert';


PersonDTO personDTOFromJson(String str) => PersonDTO.fromJson(json.decode(str));

String personDTOToJson(PersonDTO data) => json.encode(data.toJson());


class PersonDTO {
  int id;
  String email;
  String lastName;
  String name;
  String dni;
  int phoneNumber;


  PersonDTO({
    required this.id,
    required this.email,
    required this.lastName,
    required this.name,
    required this.dni,
    required this.phoneNumber
  });

      factory PersonDTO.fromJson(Map<String, dynamic> json) => PersonDTO(
        id: json["id"],
        lastName: json["lastName"],
        name: json["name"],
        email: json["email"],
        dni: json["dni"],
        phoneNumber: json["phoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "lastName": lastName,
        "name": name,
        "dni": dni,
        "phoneNumber": phoneNumber,
    };

}