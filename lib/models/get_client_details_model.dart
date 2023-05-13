class GetClientDetails {
  String? status;
  String? statusCode;
  String? message;
  Data? data;

  GetClientDetails({this.status, this.statusCode, this.message, this.data});

  GetClientDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<ClientDetails>? clientDetails;

  Data({this.clientDetails});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['clientDetails'] != null) {
      clientDetails = <ClientDetails>[];
      json['clientDetails'].forEach((v) {
        clientDetails!.add(new ClientDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.clientDetails != null) {
      data['clientDetails'] =
          this.clientDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClientDetails {
  int? formID;
  String? mobileNo;
  String? emailID;
  String? pAN;
  String? uCC;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? description;

  ClientDetails(
      {this.formID,
        this.mobileNo,
        this.emailID,
        this.pAN,
        this.uCC,
        this.firstName,
        this.middleName,
        this.lastName,
        this.gender,
        this.description});

  ClientDetails.fromJson(Map<String, dynamic> json) {
    formID = json['FormID'];
    mobileNo = json['MobileNo'];
    emailID = json['EmailID'];
    pAN = json['PAN'];
    uCC = json['UCC'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    gender = json['Gender'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FormID'] = this.formID;
    data['MobileNo'] = this.mobileNo;
    data['EmailID'] = this.emailID;
    data['PAN'] = this.pAN;
    data['UCC'] = this.uCC;
    data['FirstName'] = this.firstName;
    data['MiddleName'] = this.middleName;
    data['LastName'] = this.lastName;
    data['Gender'] = this.gender;
    data['Description'] = this.description;
    return data;
  }
}
