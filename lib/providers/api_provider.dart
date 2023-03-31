import 'dart:convert';
import 'dart:developer';
import 'package:ewg_maker_checker/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../data/encryption.dart';

class ApiProvider extends ChangeNotifier {

  // This is the base url for all the APIs
  String _baseUrl = "https://edgewealth.jmfonline.in/";

  // The auth token (jwt) will be set in this variable
  String _authToken = "";

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isLoading2 = false;
  bool get isLoading2 => _isLoading2;

  Future<void> postRequestAuth() async {
    _isLoading = true;
    notifyListeners();

    Response response = await post(
      Uri.parse("https://edgewealth.jmfonline.in/api/Login/Authenticate"),
      body: jsonEncode({
        "username": encryptString("JMEWG"),
        "password": encryptString("Jmfs@1234")
      }),
      headers: {"Content-Type": "application/json"}
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    _authToken = data['token'];
    
    print(_authToken);
    _isLoading = false;
    notifyListeners();
  }

  Future<ResponseModel> postRequest({String? endpoint, Map<String, dynamic>? body}) async {     
    try {
      print(_baseUrl + endpoint!);
      _isLoading = true;
      notifyListeners();

      Response response = await post(
        Uri.parse(_baseUrl + endpoint),
        body: jsonEncode(body!),
        headers: {
          "Authorization": "Bearer $_authToken",
          "Content-Type": "application/json"
        }
      );
      ResponseModel responseModel = ResponseModel.fromJson(jsonDecode(response.body)); 

      _isLoading = false;
      notifyListeners();
      return responseModel;   
    } catch (e) {
      log(e.toString());
      ResponseModel emptyResponse = ResponseModel(message: e.toString());
      return emptyResponse;
    }    
  }

  // This is a secondary post request function made for another loader in a page for 2 different api calls
  Future<ResponseModel> postRequest2({String? endpoint, Map<String, dynamic>? body}) async {     
    try {
      print(_baseUrl + endpoint!);
      _isLoading2 = true;
      notifyListeners();

      Response response = await post(
        Uri.parse(_baseUrl + endpoint),
        body: jsonEncode(body!),
        headers: {
          "Authorization": "Bearer $_authToken",
          "Content-Type": "application/json"
        }
      );
      ResponseModel responseModel = ResponseModel.fromJson(jsonDecode(response.body)); 

      _isLoading2 = false;
      notifyListeners();
      return responseModel;   
    } catch (e) {
      log(e.toString());
      ResponseModel emptyResponse = ResponseModel(message: e.toString());
      return emptyResponse;
    }    
  }


  // This is the get request function with no Body
  Future<ResponseModel> getRequest({String? endpoint}) async {     
    try {
      print(_baseUrl + endpoint!);
      _isLoading = true;
      notifyListeners();

      Response response = await get(
        Uri.parse(_baseUrl + endpoint),
        headers: {
          "Authorization": "Bearer $_authToken",
          "Content-Type": "application/json"
        }
      );
      ResponseModel responseModel = ResponseModel.fromJson(jsonDecode(response.body)); 

      _isLoading = false;
      notifyListeners();
      return responseModel;   
    } catch (e) {
      log(e.toString());
      ResponseModel emptyResponse = ResponseModel(message: e.toString());
      return emptyResponse;
    }    
  }

}