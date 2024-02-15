


class EventQueryParams {

  int? id;
  int? organizerId;
  String? startDate;
  String? endDate;
  List<String>? status;
  int? userId;


  EventQueryParams({
    this.id,
    this.organizerId,
    this.startDate,
    this.endDate,
    this.status,
    this.userId,
  });

  factory EventQueryParams.fromJson(Map<String, dynamic> json) => EventQueryParams(
    id : json["id"],
    organizerId : json["organizerId"],
    startDate : json["startDate"],
    endDate : json["endDate"],
    status : json["roleCode"],
    userId : json["userId"],
  );


  Map<String, dynamic> toJson() => {
    if(id != null) "id" : id,
    if(organizerId != null) "organizerId" : organizerId,
    if(startDate != null) "startDate" : startDate,
    if(endDate != null) "endDate" : endDate,
    if(status != null) "status" : status,
  };
}