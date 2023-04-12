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


  Future<void> onboarding(Map<String, dynamic> clientData) async {
    uccGeneration(clientData);
    sessionIdGeneration();
    updateClientType(clientData);
    updateBankDetails(clientData);
    updateFatcaDetails(clientData);
    checkCvlInfo(clientData);
    updateNomineeInfo(clientData);
    updatePersonalAddress(clientData);
    clientDocChequeDetails(clientData);
    clientDocSignDetails(clientData);
  }


  uccGeneration(Map<String, dynamic> clientData) async {
    String ipV4 = await Ipify.ipv4();
    print("${clientData['First Name']} ${clientData['Middle Name']} ${clientData['Last Name']}|${clientData['EmailId']}|${clientData['MobileNo']}|${ipV4}|OWNCL00001");
    print(encryptStringBSE("${clientData['First Name']} ${clientData['Middle Name']} ${clientData['Last Name']}|${clientData['EmailId']}|${clientData['MobileNo']}|${ipV4}|OWNCL00001"));
    
    // print(jsonEncode(body).toString());    

    try {
      Response getUcc = await post(
        Uri.parse("http://jmbseapi.invd.in/api/ClientSignUp/SignUp"),
        body: {
          "ParamValue": encryptStringBSE("${clientData['First Name']} ${clientData['Middle Name'] == "null" || clientData['Middle Name'] == null ? "" : clientData['Middle Name']} ${clientData['Last Name']}|${clientData['EmailId']}|${clientData['MobileNo']}|${ipV4}|OWNCL00001")
        },      
      );
      var data = jsonDecode(getUcc.body);
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


  sessionIdGeneration() async {
    try {
      Response getSessionId = await post(
        Uri.parse("http://jmbseapi.invd.in/api/Common/GenerateClientSession"),
        body: {
          "ParamValue": encryptStringBSE("1002")
        },        
      );
      print("RESPONSE CODE: " + getSessionId.statusCode.toString());
      var data = jsonDecode(getSessionId.body);
      print("SESSION: " + data);
      _sessionId = data['SessionId'];
      notifyListeners();
    } catch(e) {
      print("ERROR: ${e.toString()}");
    }
  }


  updatePrimaryInfo(Map<String, dynamic> clientData) async {
    Response getPrimaryInfo = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdatePersonalInfoPrimary"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Gender']}|02|$clientData['Father Name']|${clientData['First Name']} ${clientData['Middle Name']} ${clientData['Last Name']}|91-${clientData['MobileNo']}|${clientData['EmailId']}|||"
          )
        }
      )
    );
    var data = jsonDecode(getPrimaryInfo.body);
    print("Primary Info: " + data);    
    notifyListeners();
  }


  updateClientType(Map<String, dynamic> clientData) async {
    Response getClientType = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateClientType"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|single|01"
          )
        }
      )
    );
    var data = jsonDecode(getClientType.body);
    print("Client Type: " + data);    
    notifyListeners();
  }


  checkCvlInfo(Map<String, dynamic> clientData) async {

    String dob = clientData['DOB'];
    String year = dob.substring(6);
    String month = dob.substring(3, 5);
    String day = dob.substring(0, 2);
    dob = "$year-$month-$day";

    Response getCvl = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/CheckCVLPrimary"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|$clientData['PAN']|$dob"
          )
        }
      )
    );
    var data = jsonDecode(getCvl.body);
    print("Cvl Data: " + data);    
    notifyListeners();
  }



  updateNomineeInfo(Map<String, dynamic> clientData) async {
    Response getNomineeInfo = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateNomineeInfo"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Nominee Name']}|DC"
          )
        }
      )
    );
    var data = jsonDecode(getNomineeInfo.body);
    print("Nominee Info: " + data);    
    notifyListeners();
  }


  updatePersonalAddress(Map<String, dynamic> clientData) async {
    Response getAddress = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdatePrimaryAddress"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Per Address 1']}, ${clientData['Per Address 2']}, ${clientData['Per Address 3']}|||${clientData['Per City']}|${stateCodes.where((element) => element['StateName'] == clientData['Per State'].toString().toUpperCase()).first['StateCode']}|${clientData['PerPincode']}"
          )
        }
      )
    );
    var data = jsonDecode(getAddress.body);
    print("Personal Address: " + data);    
    notifyListeners();
  }

  
  updateBankDetails(Map<String, dynamic> clientData) async {
    Response getBankDetails = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateBankDetails"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|SB|${clientData['Account No']}|${clientData['IFSC Code']}|Y"
          )
        }
      )
    );
    var data = jsonDecode(getBankDetails.body);
    print("Bank Details: " + data);    
    notifyListeners();
  }

  
  
  updateFatcaDetails(Map<String, dynamic> clientData) async {
    Response getFatcaDetails = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateFatcaInfo"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|01|${clientData['Per City']}|IN|IN|${clientData['PAN']}|C|01|32||N||"
          )
        }
      )
    );
    var data = jsonDecode(getFatcaDetails.body);
    print("FATCA Details: " + data);    
    notifyListeners();
  }


  clientDocSignDetails(Map<String, dynamic> clientData) async {
    Response getClientDoc = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateClientDocs"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|signature|${clientData['Sign Link']}"
          )
        }
      )
    );
    var data = jsonDecode(getClientDoc.body);
    print("Client Doc Sign Details: " + data);    
    notifyListeners();
  }


  clientDocChequeDetails(Map<String, dynamic> clientData) async {
    Response getClientDoc = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientOnboard/UpdateClientDocs"),
      body: jsonEncode(
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|bankproof|${clientData['Cheque Link']}"
          )
        }
      )
    );
    var data = jsonDecode(getClientDoc.body);
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