

class SearchUsersQueryParams{

  int? id;
  String? personName;
  String? personEmail;
  String? roleCode;
  String? roleName;
  String? username;


  SearchUsersQueryParams({
    this.id,
    this.personName,
    this.personEmail,
    this.roleCode,
    this.roleName,
    this.username,
  });

  factory SearchUsersQueryParams.fromJson(Map<String, dynamic> json) => SearchUsersQueryParams(
    id : json["id"],
    personName : json["personName"],
    personEmail : json["personEmail"],
    roleCode : json["roleCode"],
    roleName : json["roleName"],
    username : json["username"],
  );

  Map<String, dynamic> toJson() => {
    if(id != null) "id": '$id',
    if(personName != null) "personName": personName,
    if(personEmail != null) "personEmail": personEmail,
    if(roleCode != null) "roleCode": roleCode,
    if(roleName != null) "roleName": roleName,
    if(username != null) "username": username,
  };
}