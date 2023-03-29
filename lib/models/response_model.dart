class ResponseModel {
  String? status;
  String? statusCode;
  String? message;
  Map<String, dynamic>? data;

  ResponseModel({this.status, this.statusCode, this.message, this.data});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    // Checking if data returns an array or a map
    data = json['data'].runtimeType == List ? json['data'][0] : json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}