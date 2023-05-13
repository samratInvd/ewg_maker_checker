import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ewg_maker_checker/models/get_client_details_model.dart';
import 'package:provider/provider.dart';
import '../data/encryption.dart';

class ClientDetailsProvider extends ChangeNotifier{

  String _baseUrl = "https://edgewealth.jmfonline.in/";

  String _authToken = "";

  List<ClientDetails>? _clientDetails;

  List<ClientDetails>? get clientDetails => _clientDetails;

  void setClientDetails(List<ClientDetails>? clientDetails) {
    _clientDetails = clientDetails;
    notifyListeners();
  }

  Future<void> fetchClientDetails() async {
    // Fetch client details from API or database and update the _clientDetails list
    // For example, you can use the GetClientDetails class to fetch the data and convert it to a list of ClientDetails objects
    List<ClientDetails> clientDetails = [];
    // GetClientDetails getClientDetails = ...; // Instantiate GetClientDetails class and call API to get data
    // clientDetails = getClientDetails.data?.clientDetails ?? [];
    setClientDetails(clientDetails);
  }

}

