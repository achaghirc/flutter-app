class ChangePasswordDTO {

  String userId;
  String oldPassword;
  String newPassword;

  ChangePasswordDTO({
    required this.userId,
    required this.oldPassword,
    required this.newPassword
  });

  factory ChangePasswordDTO.fromJson(Map<String, dynamic> json) => ChangePasswordDTO(
    userId: json["userId"], 
    oldPassword: json["oldPassword"], 
    newPassword: json["newPassword"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "oldPassword": oldPassword,
    "newPassword": newPassword,    
  };
}