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
