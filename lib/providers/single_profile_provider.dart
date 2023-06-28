import 'dart:convert';

// import 'package:dart_ipify/dart_ipify.dart';
import 'package:ewg_maker_checker/data/encrption_bse.dart';
import 'package:ewg_maker_checker/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SingleProfileProvider extends ChangeNotifier {

  String _formNo = "";
  String get formNo => _formNo;
  void setFormNo(String no) {
    _formNo = no;
    notifyListeners();
  }

  Map<String, dynamic> _clientData = {};
  Map<String, dynamic> get clientData => _clientData;
  setClientData(Map<String, dynamic> data) {
    // Clearing the old data first
    _clientData.clear();
    notifyListeners();

    _clientData = data;
    notifyListeners();
  }

  List<Map<String, dynamic>> _clientDataSeparated = [];
  List<Map<String, dynamic>> get clientDataSeparated => _clientDataSeparated;
  separateDetailsInClientData(Map<String, dynamic> data) {

    // Clearing the old data first
    _clientDataSeparated.clear();
    notifyListeners();

    Map<String, dynamic> basicInfo = {
      "Mobile No": data['MobileNo'] ?? "N/A",
      "Email Id": data['EmailId'] ?? "N/A",
      "Client Category": data['Client Category'] ?? "N/A",
      "Client Type": data['Client Type'] ?? "N/A",
      "First Name": data['First Name'] ?? "N/A",
      "Middle Name": data['Middle Name'] ?? "N/A",
      "Last Name": data['Last Name'] ?? "N/A",
      "PAN": data['PAN'] ?? "N/A",
      "Gender": data['Gender'] ?? "N/A",
      "Date of Birth": data['DOB'] ?? "N/A",
      "Father's/Spouse Name": data['Father Name'] ?? "N/A",
      "Mother's Name": data['Mother Name'] ?? "N/A",
      "isMinor": data['isMinor'] ?? "N/A",
      "Gurdian": data['Gurdian'] ?? "N/A" ?? "N/A",
      "Residential": data['Country'] ?? "N/A",
      "Tax Status": data['Country'] ?? "N/A",
      "Marital Status": data['Marital Status'] ?? "N/A",
    };
    Map<String, dynamic> fatcaDetails = {
      "Residential": data['Address Type'] ?? "N/A",
      "Place of birth": data['Place of birth'] ?? "N/A",
      "Country of birth": data['Country of birth'] ?? "N/A",
      "Nationality": data['Country'] ?? "N/A",
      "Occupation": data['Occupation'] ?? "N/A",
      "Annual Income": data['Annual Income'] ?? "N/A",
      "Source of Income": data['Source of Income'] ?? "N/A",      
    };
    Map<String, dynamic> contactDetails = {
      "Mobile No": data['MobileNo'] ?? "N/A",
      "Email Id": data['EmailId'] ?? "N/A",
      "Address": data['Per Address 1'] + ", " + data['Per Address 2'] + ", " + data['Per Address 3'],
      "State": data['Per State'] ?? "N/A",
      "City": data['Per City'] ?? "N/A",
      "Pincode": data['PerPincode'] ?? "N/A",
      "Country": data['Country'] ?? "N/A",
      "Place of birth": data['Place of birth'] ?? "N/A",
      "Country of Tax": data['Country of birth'] ?? "N/A",
    };
    Map<String, dynamic> bankDetails = {
      "Address": data['Per Address 1'] + ", " + data['Per Address 2'] + ", " + data['Per Address 3'],      
      "City": data['Per City'] ?? "N/A",
      "State": data['Per State'] ?? "N/A",
      "Pincode": data['PerPincode'] ?? "N/A",
      "Country": data['Country'] ?? "N/A",
      "Place of birth": data['Place of birth'] ?? "N/A",
      "Account Type": data['Account Type'] ?? "N/A",
      "Account No": data['Account No'] ?? "N/A",
      "MICR No": data['MICR No'] ?? "N/A",
      "IFSC Code": data['IFSC Code'] ?? "N/A",
    };
    Map<String, dynamic> nomineeDetails = {    
      "Nominee Name": data['Nominee Name'] ?? "N/A",
      "Nominee Relationship": data['Nominee Relationship'] ?? "N/A",
      "Nominee Applicable": "${data['Nominee  Applicable(%)']} %",
      "Is Nominee Minor": data['Nominee  Minor Flag'] ?? "N/A",
      "Nomine Date of Birth": data['Nominee  DOB'] ?? "N/A",
    };
    Map<String, dynamic> otherDetails = {    
      "First Name": data['First Name'] ?? "N/A",
      "Middle Name": data['Middle Name'] ?? "N/A",
      "Last Name": data['Last Name'] ?? "N/A",
    };

    // ADDING ALL THE MAPS IN THE LIST
    _clientDataSeparated.add(basicInfo);
    _clientDataSeparated.add(fatcaDetails);
    _clientDataSeparated.add(contactDetails);
    _clientDataSeparated.add(bankDetails);
    _clientDataSeparated.add(nomineeDetails);
    _clientDataSeparated.add(otherDetails);
    notifyListeners();
  }



  Future<void> clearData() async {
    _clientData.clear();
    _clientDataSeparated.clear();
    notifyListeners();
  }


  //------- APPROVAL DATA MEMBERS -------//
  // PHOTO LIVE STATUS
  bool _photoLiveStatus = false;
  bool get photoLiveStatus => _photoLiveStatus;
  setPhotoLiveStatus(bool val) {
    _photoLiveStatus = val;
    notifyListeners();
  }

  // CHEQUE STATUS
  bool _chequeStatus = false;
  bool get chequeStatus => _chequeStatus;
  setChequeStatus(bool val) {
    _chequeStatus = val;
    notifyListeners();
  }

  // SIGN STATUS
  bool _signStatus = false;
  bool get signStatus => _signStatus;
  setSignStatus(bool val) {
    _signStatus = val;
    notifyListeners();
  }

  // FINAL STATUS
  int _finalStatus = 0;
  int get finalStatus => _finalStatus;
  setFinalStatus(int val) {
    _finalStatus = val;
    notifyListeners();
  }


  List<dynamic> _allClients = [];
  List<dynamic> get allClients => _allClients;
  void setAllClients(List<dynamic> clients) {
    _allClients.add(clients);
    notifyListeners();
  } 

  void clearAllClients() {
    _allClients.clear();
    notifyListeners();
  }  


  // //------- CALL BSE APIS TO REGISTER THE CLIENT TO BSE FOR TRANSACTIONS -------//
  // String _ucc = "";
  // String get ucc => _ucc;
  // setUcc(String ucc) {
  //   _ucc = ucc;
  //   notifyListeners();
  // }

  // String _sessionId = "";
  // String get sessionId => _sessionId;
  // setSessionId(String sessionId) {
  //   _sessionId = sessionId;
  //   notifyListeners();
  // }

  // Future<void> callBseApis(context, Map<String, dynamic> data) async {
  //   String ip4String = await Ipify.ipv4();
    
  //   // UCC CREATION
  //   Response response1 = await post(
  //     Uri.parse("https://jmuatapi.invd.in/api/ClientSignUp/SignUp"),
  //     body: jsonEncode({
  //       "ParamValue": encryptStringBSE("${data['First Name']} ${data['Middle Name']} ${data['Last Name']}|${data['EmailId']}|${data['MobileNo']}|$ip4String|OWNCL00001")
  //     })
  //   );
  //   print(jsonDecode(response1.body));
  //   Map<String, dynamic> uccResponseData = jsonDecode(response1.body);
  //   setUcc(uccResponseData['UCC']);

  //   // SESSION ID CREATION
  //   Response response2 = await post(
  //     Uri.parse("https://jmuatapi.invd.in/api/Common/GenerateClientSession"),
  //     body: jsonEncode({
  //       "ParamValue": encryptStringBSE("$_ucc")
  //     })
  //   );
  //   print(jsonDecode(response2.body));
  //   Map<String, dynamic> sessionIdResponseData = jsonDecode(response2.body);
  //   setUcc(sessionIdResponseData['SessionId']);

  //   // UDPATE PERSONAL INFO
  //   Response response3= await post(
  //     Uri.parse("https://jmuatapi.invd.in/api/ClientOnboard/UpdatePersonalInfoPrimary"),
  //     body: jsonEncode({
  //       "ParamValue": encryptStringBSE("$_ucc|$_sessionId|${data['Gender']}|01|${data['Middle Name']}|${data['First Name']} ${data['Middle Name']} ${data['Last Name']}|91-${data['MobileNo']}|${data['EmailId']}||")
  //     })
  //   );
  //   print(jsonDecode(response3.body));

  //   // UPDATE CLIENT TYPE
  //   Response response4 = await post(
  //     Uri.parse("https://jmuatapi.invd.in/api/ClientOnboard/UpdateClientType"),
  //     body: jsonEncode({
  //       "ParamValue": encryptStringBSE("$_ucc|$_sessionId|single|01")
  //     })
  //   );
  //   print(jsonDecode(response4.body));

  //   // UPDATE NOMINEE INFO
  //   Response response5 = await post(
  //     Uri.parse("https://jmuatapi.invd.in/api/ClientOnboard/UpdateNomineeInfo"),
  //     body: jsonEncode({
  //       "ParamValue": encryptStringBSE("$_ucc|$_sessionId|${data['Nominee Name']}|DC")
  //     })
  //   );
  //   print(jsonDecode(response5.body));

  //   // UPDATE PRIMARY ADDRESS
  //   Response response6 = await post(
  //     Uri.parse("https://jmuatapi.invd.in/api/ClientOnboard/UpdatePrimaryAddress"),
  //     body: jsonEncode({
  //       "ParamValue": encryptStringBSE("$_ucc|$_sessionId|${data['Per Address 1']},${data['Per Address 2']},${data['Per Address 3']}|${data['Place of birth']}|MA|${data['PerPincode']}")
  //     })
  //   );
  //   print(jsonDecode(response6.body));

  //   // UPDATE BANK DETAILS
  //   // Response response7 = await post(
  //   //   Uri.parse("https://jmuatapi.invd.in/api/ClientSignUp/SignUp"),
  //   //   body: jsonEncode({
  //   //     "ParamValue": encryptStringBSE("${data['First Name']} ${data['Middle Name']} ${data['Last Name']}|${data['EmailId']}|${data['MobileNo']}|$ip4String|OWNCL00001")
  //   //   })
  //   // );

  //   // // UCC CREATION
  //   // Response response1 = await post(
  //   //   Uri.parse("https://jmuatapi.invd.in/api/ClientSignUp/SignUp"),
  //   //   body: jsonEncode({
  //   //     "ParamValue": encryptStringBSE("${data['First Name']} ${data['Middle Name']} ${data['Last Name']}|${data['EmailId']}|${data['MobileNo']}|$ip4String|OWNCL00001")
  //   //   })
  //   // );

  //   // // UCC CREATION
  //   // Response response1 = await post(
  //   //   Uri.parse("https://jmuatapi.invd.in/api/ClientSignUp/SignUp"),
  //   //   body: jsonEncode({
  //   //     "ParamValue": encryptStringBSE("${data['First Name']} ${data['Middle Name']} ${data['Last Name']}|${data['EmailId']}|${data['MobileNo']}|$ip4String|OWNCL00001")
  //   //   })
  //   // );
  // }
}