import 'package:ewg_maker_checker/data/encrption_bse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BseApiProvider extends ChangeNotifier {

  String _baseUrl = "";

  String _ucc = "";
  String _sessionId = "";

  void callOnboarding(Map<String, dynamic> clientData) async {
    Response signUpForUccResponse = await post(
      Uri.parse("http://jmbseapi.invd.in/api/ClientSignUp/SignUp"),
      body: {
        "ParamValue": encryptStringBSE(
          "${clientData['First Name']} ${clientData['Middle Name']} ${clientData['Last Name']}|${clientData['EmailId']}"
        )
      }
    );
  }

}