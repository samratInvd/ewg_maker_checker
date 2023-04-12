import 'dart:convert';
import 'dart:developer';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:ewg_maker_checker/data/encrption_bse.dart';
import 'package:ewg_maker_checker/models/response_model.dart';
import 'package:ewg_maker_checker/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class BseApiProvider extends ChangeNotifier {

  String _baseUrl = "";

  String _ucc = "";
  String _sessionId = "";


  Future<void> onboarding(context, String formNo, Map<String, dynamic> clientData) async {
    uccGeneration(context, formNo, clientData);
    // sessionIdGeneration();
    // updateClientType(clientData);
    // updateBankDetails(clientData);
    // updateFatcaDetails(clientData);
    // checkCvlInfo(clientData);
    // updateNomineeInfo(clientData);
    // updatePersonalAddress(clientData);
    // clientDocChequeDetails(clientData);
    // clientDocSignDetails(clientData);
  }


  void uccGeneration(context, String formNo, Map<String, dynamic> clientData) async {
    String ipV4 = await Ipify.ipv4();
    print("${clientData['First Name']} ${clientData['Middle Name']} ${clientData['Last Name']}|${clientData['EmailId']}|${clientData['MobileNo']}|${ipV4}|OWNCL00001");
    print(encryptStringBSE("${clientData['First Name']} ${clientData['Middle Name']} ${clientData['Last Name']}|${clientData['EmailId']}|${clientData['MobileNo']}|${ipV4}|OWNCL00001"));

    Map<String, dynamic> body = {
      "ParamValue": encryptStringBSE(
        "${clientData['First Name']} ${clientData['Middle Name'] == "null" || clientData['Middle Name'] == null ? "" : clientData['Middle Name']} ${clientData['Last Name']}|${clientData['EmailId']}|${clientData['MobileNo']}|${ipV4}|OWNCL00001"
      )
    };
    print(jsonEncode(body).runtimeType);

    try {
      Response signUpForUccResponse = await post(
        Uri.parse("http://jmbseapi.invd.in/api/ClientSignUp/SignUp"),
        body: body
      );
      var data = jsonDecode(signUpForUccResponse.body);
      print("UCC: " + data);
      _ucc = data['UCC'];
      notifyListeners();
    } catch(e) {
      print("ERROR: ${e.toString()}");
    }


    // ResponseModel responseModel = await Provider.of<ApiProvider>(context, listen: false).postRequest(
    //   endpoint: 'api/BSEAPI/UpdateUCC',
    //   body: {
    //     "formNo": encryptStringBSE(formNo),
    //     "mf_UCC": encryptStringBSE(_ucc),
    //     "ucc": encryptStringBSE("EWG" + _ucc)
    //   }
    // );

    // log(responseModel.toJson().toString());
  }


  void sessionIdGeneration() async {
    Response sessionIdResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/Common/GenerateClientSession"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc"
          )
        }
      )
    );
    var data = jsonDecode(sessionIdResponse.body);
    print("SESSION: " + data);
    _sessionId = data['SessionId'];
    notifyListeners();
  }


  void updatePrimaryInfo(Map<String, dynamic> clientData) async {
    Response primaryInfoResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdatePersonalInfoPrimary"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Gender']}|02|$clientData['Father Name']|${clientData['First Name']} ${clientData['Middle Name']} ${clientData['Last Name']}|91-${clientData['MobileNo']}|${clientData['EmailId']}|||"
          )
        }
      )
    );
    var data = jsonDecode(primaryInfoResponse.body);
    print("Primary Info: " + data);    
    notifyListeners();
  }


  void updateClientType(Map<String, dynamic> clientData) async {
    Response clientTypeResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateClientType"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|single|01"
          )
        }
      )
    );
    var data = jsonDecode(clientTypeResponse.body);
    print("Client Type: " + data);    
    notifyListeners();
  }


  void checkCvlInfo(Map<String, dynamic> clientData) async {

    String dob = clientData['DOB'];
    String year = dob.substring(6);
    String month = dob.substring(3, 5);
    String day = dob.substring(0, 2);
    dob = "$year-$month-$day";

    Response cvlResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/CheckCVLPrimary"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|$clientData['PAN']|$dob"
          )
        }
      )
    );
    var data = jsonDecode(cvlResponse.body);
    print("Cvl Data: " + data);    
    notifyListeners();
  }



  void updateNomineeInfo(Map<String, dynamic> clientData) async {
    Response nomineeInfoResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateNomineeInfo"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Nominee Name']}|DC"
          )
        }
      )
    );
    var data = jsonDecode(nomineeInfoResponse.body);
    print("Nominee Info: " + data);    
    notifyListeners();
  }


  void updatePersonalAddress(Map<String, dynamic> clientData) async {
    Response personalAddressResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdatePrimaryAddress"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Per Address 1']}, ${clientData['Per Address 2']}, ${clientData['Per Address 3']}|||${clientData['Per City']}|${stateCodes.where((element) => element['StateName'] == clientData['Per State'].toString().toUpperCase()).first['StateCode']}|${clientData['PerPincode']}"
          )
        }
      )
    );
    var data = jsonDecode(personalAddressResponse.body);
    print("Personal Address: " + data);    
    notifyListeners();
  }

  
  void updateBankDetails(Map<String, dynamic> clientData) async {
    Response bankDetailsResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateBankDetails"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|SB|${clientData['Account No']}|${clientData['IFSC Code']}|Y"
          )
        }
      )
    );
    var data = jsonDecode(bankDetailsResponse.body);
    print("Bank Details: " + data);    
    notifyListeners();
  }

  
  
  void updateFatcaDetails(Map<String, dynamic> clientData) async {
    Response fatcaDetailsResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateFatcaInfo"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|01|${clientData['Per City']}|IN|IN|${clientData['PAN']}|C|01|32||N||"
          )
        }
      )
    );
    var data = jsonDecode(fatcaDetailsResponse.body);
    print("FATCA Details: " + data);    
    notifyListeners();
  }


  void clientDocSignDetails(Map<String, dynamic> clientData) async {
    Response clientDocResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateClientDocs"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|signature|${clientData['Sign Link']}"
          )
        }
      )
    );
    var data = jsonDecode(clientDocResponse.body);
    print("Client Doc Sign Details: " + data);    
    notifyListeners();
  }


  void clientDocChequeDetails(Map<String, dynamic> clientData) async {
    Response clientDocResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateClientDocs"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|bankproof|${clientData['Cheque Link']}"
          )
        }
      )
    );
    var data = jsonDecode(clientDocResponse.body);
    print("Client Doc Cheque Details: " + data);    
    notifyListeners();
  }
  


  List<Map<String, dynamic>> stateCodes = [
        {
            "StateCode": "AN",
            "StateName": "ANDAMAN & NICOBAR"
        },
        {
            "StateCode": "AP",
            "StateName": "ANDHRA PRADESH"
        },
        {
            "StateCode": "AR",
            "StateName": "ARUNACHAL PRADESH"
        },
        {
            "StateCode": "AS",
            "StateName": "ASSAM"
        },
        {
            "StateCode": "BH",
            "StateName": "BIHAR"
        },
        {
            "StateCode": "CH",
            "StateName": "CHANDIGARH"
        },
        {
            "StateCode": "CG",
            "StateName": "CHHATTISGARH"
        },
        {
            "StateCode": "DN",
            "StateName": "DADRA AND NAGAR HAVELI"
        },
        {
            "StateCode": "DL",
            "StateName": "DELHI"
        },
        {
            "StateCode": "DD",
            "StateName": "DIU AND DAMAN"
        },
        {
            "StateCode": "GO",
            "StateName": "GOA"
        },
        {
            "StateCode": "GU",
            "StateName": "GUJARAT"
        },
        {
            "StateCode": "HA",
            "StateName": "HARYANA"
        },
        {
            "StateCode": "HP",
            "StateName": "HIMACHAL PRADESH"
        },
        {
            "StateCode": "JM",
            "StateName": "JAMMU AND KASHMIR"
        },
        {
            "StateCode": "JH",
            "StateName": "JHARKHAND"
        },
        {
            "StateCode": "KA",
            "StateName": "KARNATAKA"
        },
        {
            "StateCode": "KE",
            "StateName": "KERALA"
        },
        {
            "StateCode": "LD",
            "StateName": "LAKSHADWEEP"
        },
        {
            "StateCode": "MP",
            "StateName": "MADHYA PRADESH"
        },
        {
            "StateCode": "MA",
            "StateName": "MAHARASHTRA"
        },
        {
            "StateCode": "MN",
            "StateName": "MANIPUR"
        },
        {
            "StateCode": "ME",
            "StateName": "MEGHALAYA"
        },
        {
            "StateCode": "MI",
            "StateName": "MIZORAM"
        },
        {
            "StateCode": "NA",
            "StateName": "NAGALAND"
        },
        {
            "StateCode": "NG",
            "StateName": "NAGPUR"
        },
        {
            "StateCode": "ND",
            "StateName": "NEW DELHI"
        },
        {
            "StateCode": "OR",
            "StateName": "ORISSA"
        },
        {
            "StateCode": "OH",
            "StateName": "OTHERS"
        },
        {
            "StateCode": "PO",
            "StateName": "PONDICHERRY"
        },
        {
            "StateCode": "PU",
            "StateName": "PUNJAB"
        },
        {
            "StateCode": "RA",
            "StateName": "RAJASTHAN"
        },
        {
            "StateCode": "SI",
            "StateName": "SIKKIM"
        },
        {
            "StateCode": "TN",
            "StateName": "TAMIL NADU"
        },
        {
            "StateCode": "TG",
            "StateName": "TELANGANA"
        },
        {
            "StateCode": "TR",
            "StateName": "TRIPURA"
        },
        {
            "StateCode": "UP",
            "StateName": "UTTAR PRADESH"
        },
        {
            "StateCode": "UL",
            "StateName": "UTTARAKHAND"
        },
        {
            "StateCode": "UC",
            "StateName": "UTTARANCHAL"
        },
        {
            "StateCode": "WB",
            "StateName": "WEST BENGAL"
        }
    ];

}