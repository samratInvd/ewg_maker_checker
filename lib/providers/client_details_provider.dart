import 'dart:convert';
import 'dart:developer';
import 'package:ewg_maker_checker/models/response_model.dart';
import 'package:ewg_maker_checker/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ewg_maker_checker/models/get_client_details_model.dart';
import 'package:provider/provider.dart';
import '../data/encryption.dart';

class ClientDetailsProvider extends ChangeNotifier{

  // String _baseUrl = "https://edgewealth.jmfonline.in/";

  // String _authToken = "";

  List<ClientDetails>? _clientDetails;

  List<ClientDetails>? get clientDetails => _clientDetails;

  void setClientDetails(List<ClientDetails>? clientDetails) {
    _clientDetails = clientDetails;
    notifyListeners();
  }

  Future<void> fetchClientDetails(BuildContext context) async {
    // Fetch client details from API or database and update the _clientDetails list
    // For example, you can use the GetClientDetails class to fetch the data and convert it to a list of ClientDetails objects
    List<ClientDetails> clientDetailsList = [];


    /// This code is making an API request to fetch client details and then converting the response data
    /// into a list of `ClientDetails` objects.
    ResponseModel responseModel = await Provider.of<ApiProvider>(context, listen: false).postRequest(
      endpoint: 'api/RM/Get_ClientDetails',
      body: {
        "flag": encryptString("Pending")
      }
    );        
    /// `List<dynamic> clientDetailsListMap = responseModel.data!['clientDetails'];` is extracting the
    /// value of the `clientDetails` key from the `data` field of the `responseModel` object and
    /// assigning it to a new variable `clientDetailsListMap`. The `!` operator is used to assert that
    /// the `data` field is not null and the `['clientDetails']` operator is used to extract the value
    /// of the `clientDetails` key from the `data` field. The `List<dynamic>` type annotation is used to
    /// specify that the `clientDetailsListMap` variable is a list of dynamic objects, which will be
    /// converted to a list of `ClientDetails` objects in the subsequent code.
    List<dynamic> clientDetailsListMap = responseModel.data!['clientDetails'];
    /// This code is iterating through the `clientDetailsListMap` list, which contains a list of client
    /// details in the form of maps. For each map in the list, it creates a new `ClientDetails` object
    /// by calling the `fromJson` method and passing in the map as an argument. It then adds the new
    /// `ClientDetails` object to the `clientDetailsList` list and prints out the details of the client
    /// using the `toJson` method. This process continues until all the maps in the
    /// `clientDetailsListMap` list have been processed.
    for(int client = 0; client < clientDetailsListMap.length; client++) {
      ClientDetails clientDetails = ClientDetails.fromJson(clientDetailsListMap[client]);      
      clientDetailsList.add(clientDetails);
      print("CLIENT $client =====> " + clientDetails.toJson().toString());
    }    

    // GetClientDetails getClientDetails = ...; // Instantiate GetClientDetails class and call API to get data
    // clientDetails = getClientDetails.data?.clientDetails ?? [];
    setClientDetails(clientDetailsList);
  }

}

