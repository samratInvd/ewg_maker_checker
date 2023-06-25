import 'dart:convert';
import 'dart:developer';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ewg_maker_checker/data/encrption_bse.dart';
import 'package:ewg_maker_checker/data/encryption.dart';
import 'package:ewg_maker_checker/models/response_model.dart';
import 'package:ewg_maker_checker/providers/api_provider.dart';
import 'package:ewg_maker_checker/providers/bse_api_provider.dart';
import 'package:ewg_maker_checker/providers/single_profile_provider.dart';
import 'package:ewg_maker_checker/views/clients/widgets/pdf_expansion_tile.dart';
import 'package:ewg_maker_checker/views/clients/widgets/photo_expansion_tile.dart';
import 'package:ewg_maker_checker/views/clients/widgets/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MakerCheckerPage extends StatefulWidget {
  const MakerCheckerPage({super.key});

  @override
  State<MakerCheckerPage> createState() => _MakerCheckerPageState();
}

class _MakerCheckerPageState extends State<MakerCheckerPage> {
  TextEditingController _searchController = TextEditingController();
  int tabIndex = 0;
  List<Map<String, dynamic>> clientDetails = [];
  String _ucc = "";
  String _sessionId = "";
  bool _isLoading = false;

  bool _isClientApproved = false;

  // Map<String, String> relationships = {
  //   "Dependent Child": "DC",
  //   "Dependent Parents": "DP",
  //   "Spouse": "SP",
  //   "Siblings": "DS"
  // };


  //------------ BSE APIS ------------//

  callUCC(Map<String, dynamic> clientData) async {
    String ipV4 = await Ipify.ipv4();

    // UCC
    Response getUCC = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientSignUp/SignUp"),
      body: {
        "ParamValue": encryptStringBSE("${clientData['First Name']} ${clientData['Middle Name'] == "null" || clientData['Middle Name'] == null ? "" : clientData['Middle Name']} ${clientData['Last Name']}|${clientData['EmailId']}|${clientData['MobileNo']}|${ipV4}|OWNCL00001|${clientData['JMUCC']}")
      }    
    );
    var data = jsonDecode(getUCC.body);
    print("UCC: " + jsonDecode(getUCC.body).toString());
    setState(() {
      _ucc = data['UCC'];
    });

    return data;
  }


  // SESSION ID
  callSessionId() async {
    // SESSIONID
    Response getSessionIdResponse = await post(
      Uri.parse("https://jmbseapi.invd.in/api/Common/GenerateClientSession"),
      body: {
        "ParamValue": encryptStringBSE("$_ucc")
      }      
    );    
    var data = jsonDecode(getSessionIdResponse.body);
    setState(() {
      _sessionId = data['SessionId'];
    });
    print("SESSION: " + jsonDecode(getSessionIdResponse.body).toString());
    print("SESSIONID: " + _sessionId);
    return data;
  }      



  callUpdatePrimaryInfo(Map<String, dynamic> clientData) async {
    // PRIMARYINFO
    Response updatePrimaryInfoResponse = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UpdatePersonalInfoPrimary"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Gender']}|02|${clientData['Father Name']}|${clientData['First Name']} ${clientData['Middle Name']} ${clientData['Last Name']}|91-${clientData['MobileNo']}|${clientData['EmailId']}|||"
          )
        }      
    );
    var data = jsonDecode(updatePrimaryInfoResponse.body);
    
    return data;
    
  }   

  callUpdateClientType(Map<String, dynamic> clientData) async {
    //CLIENT TYPE
    Response getClientTypeResponse = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UpdateClientType"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|single|01"
          )
        }      
    );
    var data = jsonDecode(getClientTypeResponse.body);
    
    return data;
    
  }   
  

  callCheckCVL(Map<String, dynamic> clientData) async {
    // CVL
    String dob = clientData['DOB'];
    String year = dob.substring(6);
    String month = dob.substring(3, 5);
    String day = dob.substring(0, 2);
    dob = "$year-$month-$day";

    Response getCvlResponse = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/CheckCVLPrimary"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['PAN']}|$dob"
          )
        }      
    );
    var data = jsonDecode(getCvlResponse.body);
    
    return data;
    
  }

  callUpdateNomineeInfo(Map<String, dynamic> clientData) async {
     // NOMINEE INFO
    Response getNomineeInfo = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UpdateNomineeInfo"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Nominee Name']}|${clientData['Nominee Relationship']}"
          )
        }      
    );
    var data = jsonDecode(getNomineeInfo.body);
    
    return data;
    
  }      

  callUpdateAddress(Map<String, dynamic> clientData) async {
    // ADDRESS
    Response getAddressResponse = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UpdatePrimaryAddress"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|${clientData['Per Address 1']}, ${clientData['Per Address 2']}, ${clientData['Per Address 3']}|||${clientData['Per City']}|${stateCodes.where((element) => element['StateName'] == clientData['Per State'].toString().toUpperCase()).first['StateCode']}|${clientData['PerPincode']}"
          )
        }      
    );
    var data = jsonDecode(getAddressResponse.body);
    
    return data;
    
  }   


  callBankDetails(Map<String, dynamic> clientData) async {
    // BANK DETAILS
    Response getBankDetailsResponse = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UpdateBankDetails"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|SB|${clientData['Account No']}|${clientData['IFSC Code']}|Y"
          )
        }      
    );
    var data = jsonDecode(getBankDetailsResponse.body);
    
    return data;
    
  }    


  callUpdateFatcaDetails(Map<String, dynamic> clientData) async {
    print("$_ucc|$_sessionId|01|${clientData['Per City']}|IN|IN|${clientData['PAN']}|C|01|32||N||");
    // FATCA
    Response getFatcaDetailsResponse = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UpdateFatcaInfo"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|01|${clientData['Per City']}|IN|IN|${clientData['PAN']}|C|01|32||N||"
          )
        }      
    );
    var data = jsonDecode(getFatcaDetailsResponse.body);
    
    return data;
    
  }


  callSignDoc(Map<String, dynamic> clientData) async {
    // SIGN
    Response getClientDoc = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UpdateClientDocs"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|signature|${clientData['Sign Link']}"
          )
        }      
    );
    var data = jsonDecode(getClientDoc.body);
    
    return data;
    
  }


  callChequeDoc(Map<String, dynamic> clientData) async {
    // CHEQUE
    Response getClientDocCheque = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UpdateClientDocs"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId|bankproof|${clientData['Cheque Link']}"
          )
        }      
    );
    var data = jsonDecode(getClientDocCheque.body);
    
    return data;
    
  }  




  uploadDataToBSE() async {
    // UPLOAD DATA TO BSE
    Response getUploadDatatoBSEResponse = await post(
      Uri.parse("https://jmbseapi.invd.in/api/ClientOnboard/UploadDataToBSE"),
      body:
        {
          "ParamValue": encryptStringBSE(
            "$_ucc|$_sessionId"
          )
        }      
    );
    var data = jsonDecode(getUploadDatatoBSEResponse.body);
    return data;
    
  }    


  //------------ BSE APIS END ------------//


  @override
  void initState() { 
    // callBseApis(Provider.of<SingleProfileProvider>(context, listen: false).clientData);
    Provider.of<SingleProfileProvider>(context, listen: false).setPhotoLiveStatus(Provider.of<SingleProfileProvider>(context, listen: false).clientData['PhotoLive_Status']);
    Provider.of<SingleProfileProvider>(context, listen: false).setChequeStatus(Provider.of<SingleProfileProvider>(context, listen: false).clientData['Cheque_Status']);
    Provider.of<SingleProfileProvider>(context, listen: false).setSignStatus(Provider.of<SingleProfileProvider>(context, listen: false).clientData['Sign_Status']);
    Provider.of<SingleProfileProvider>(context, listen: false).setFinalStatus(Provider.of<SingleProfileProvider>(context, listen: false).clientData['Final_Status']);
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return Consumer3<SingleProfileProvider, ApiProvider, BseApiProvider>(
      builder: (context, SingleProfileProvider singleProfileProvider, ApiProvider apiProvider, BseApiProvider bseApiProvider, _) {
        return Scaffold(body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // HEADER
              Container(
                padding: EdgeInsets.only(left: 32, right: 32, top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Maker / Checker", style: TextStyle(color: Color(0xff461257), fontFamily: 'SemiBold', fontSize: 30),),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (value) {
                          Provider.of<ApiProvider>(context, listen: false).postRequestAuth()
                          .then((_) async {

                            ResponseModel responseModel = await Provider.of<ApiProvider>(context, listen: false).postRequest(
                              endpoint: 'api/RM/Get_ClientDetailsForChecker',
                              body: {
                                "FormNo": encryptString(_searchController.text)
                              }
                            ).then((response) async {  

                              if(response.statusCode != "0") {
                                showDialog(
                                  context: context, 
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text("${response.message!.toUpperCase()}", style: TextStyle(fontFamily: 'SemiBold', color: Color(0xff461257)),),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }, 
                                          child: Text("Ok", style: TextStyle(color: Color(0xff461257)),)
                                        )
                                      ],
                                    );
                                  }
                                );
                              } else {
                                log(response.toJson().toString()); 

                                // CLEARING THE DATA
                                singleProfileProvider.clearData();                                

                                // Populating the new data
                                singleProfileProvider.setClientData(response.data!['clientDetailsForCheckerMaker'][0]);
                                singleProfileProvider.separateDetailsInClientData(response.data!['clientDetailsForCheckerMaker'][0]);
                                print("CLIENT DATA SEPARATED: " + singleProfileProvider.clientDataSeparated.toString());
                                print(singleProfileProvider.clientData);
                                singleProfileProvider.setFormNo(value);
                                
                                // CHECKING IF THE CLIENT IS APPROVED OR NOT
                                if(singleProfileProvider.clientData['Final_Status'] == 1) {
                                  setState(() {
                                    _isClientApproved = true;
                                  });
                                } else {
                                  setState(() {
                                    _isClientApproved = false;
                                  });
                                }                                                               
                              }

                              return response;
                              
                            });      

                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Search Clients",
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              print("SEARCH");
                              Provider.of<ApiProvider>(context, listen: false).postRequestAuth()
                                .then((_) async {

                                  ResponseModel responseModel = await Provider.of<ApiProvider>(context, listen: false).postRequest(
                                    endpoint: 'api/RM/Get_ClientDetailsForChecker',
                                    body: {
                                      "FormNo": encryptString(_searchController.text)
                                    }
                                  ).then((response) async {   
                                    log(response.toJson().toString());                                       

                                    // CLEARING THE DATA
                                    singleProfileProvider.clearData();

                                    // Populating the new data  
                                    singleProfileProvider.setClientData(response.data!['clientDetailsForCheckerMaker'][0]);
                                    singleProfileProvider.separateDetailsInClientData(response.data!['clientDetailsForCheckerMaker'][0]);                                    
                                    print("CLIENT DATA SEPARATED: " + singleProfileProvider.clientDataSeparated.toString());
                                    singleProfileProvider.setFormNo(_searchController.text);


                                    // CHECKING IF THE CLIENT IS APPROVED OR NOT
                                    if(singleProfileProvider.clientData['Final_Status'] == 1) {
                                      setState(() {
                                        _isClientApproved = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isClientApproved = false;
                                      });
                                    }
                                    
                                    return response;
                                  });      

                                });
                            },
                            child: Icon(Icons.search_rounded, color: Color(0xff461257),)
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff461257), width: 1.5), 
                            borderRadius: BorderRadius.circular(7)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff461257), width: 1.5), 
                            borderRadius: BorderRadius.circular(7)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff461257), width: 1.5), 
                            borderRadius: BorderRadius.circular(7)
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff461257), width: 1.5), 
                            borderRadius: BorderRadius.circular(7)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // BODY
              Container(
                margin: EdgeInsets.all(32),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffF3EEF8),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  )
                ),
                child: apiProvider.isLoading 
                  ? Container(height: 600, width: MediaQuery.of(context).size.width, child: Center(child: CircularProgressIndicator(color: Color(0xff461257),),),) 
                  : Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // BASIC INFO TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 0;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 0 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(bottomRight: tabIndex == 1 ? Radius.circular(15) : Radius.circular(0))
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Basic Info", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // FATCA DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 1;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,                      
                                decoration: BoxDecoration(
                                  color: tabIndex == 1 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 0 ? Radius.circular(15) : Radius.circular(0),
                                    bottomRight: tabIndex == 2 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("FATCA Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // CONTACT DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 2;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 2 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 1 ? Radius.circular(15) : Radius.circular(0),
                                    bottomRight: tabIndex == 3 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Contact Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // BANK DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 3;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 3 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 2 ? Radius.circular(15) : Radius.circular(0),
                                    bottomRight: tabIndex == 4 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Bank Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // NOMINEE DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 4;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 4 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 3 ? Radius.circular(15) : Radius.circular(0),
                                    bottomRight: tabIndex == 5 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Nominee Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // OTHER DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 5;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 5 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 4 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Other Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // CENTER COLUMN DATA
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      height: 600,
                      width: 400,
                      child: ListView.builder(
                        itemCount: singleProfileProvider.clientDataSeparated[tabIndex].length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(left: 20),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                // The Type of Data => Name of the keys of the map
                                Container(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, 
                                    mainAxisAlignment: MainAxisAlignment.start,                                 
                                    children: [
                                      Text(
                                        singleProfileProvider.clientDataSeparated[tabIndex].keys.toList()[index],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(":   "),
                                ),
                                // The Actual Data => Data of the values of the map
                                Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,                                  
                                    children: [
                                      SelectableText(
                                        singleProfileProvider.clientDataSeparated[tabIndex][singleProfileProvider.clientDataSeparated[tabIndex].keys.toList()[index]].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.black, fontFamily: 'SemiBold'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                    Spacer(),
                    // PHOTO COLUMN
                    Container(
                      height: 600,
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: Color(0xffE6DFF0),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        )
                      ),
                      child: SingleChildScrollView(
                        child: Column(                        
                          children: [
                            Container(
                              margin: EdgeInsets.all(16),
                              child: Text(
                                "Image Verification",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Color(0xff461257), fontFamily: 'SemiBold', fontSize: 20),
                              ),
                            ),
                            PhotoExpanstionTile(title: "Signature", imageUrl: singleProfileProvider.clientData['Sign Link']),
                            SizedBox(height: 20,),
                            PhotoExpanstionTile(title: "Cheque", imageUrl: singleProfileProvider.clientData['Cheque Link']),
                            SizedBox(height: 20,),
                            PhotoExpanstionTile(title: "Selfie", imageUrl: singleProfileProvider.clientData['Selfie Link']),
                            SizedBox(height: 20,),
                            PdfExpansionTile(title: "Esign PDF", pdfUrl: singleProfileProvider.clientData['Esign PDF']),
                            SizedBox(height: 20,),
                            Container(
                              child: _isClientApproved 
                                ? SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        color: Colors.green,
                                        onPressed: () {
                                          print("CLIENT DATA =====> " + Provider.of<SingleProfileProvider>(context, listen: false).clientData.toString());
                                          // bseApiProvider.onboarding(context, _searchController.text, singleProfileProvider.clientData);
                                        },
                                        child: Center(child: Text("Approved", style: TextStyle(color: Colors.white, fontFamily: 'SemiBold'),)),
                                      ),
                                    )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.1,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        color: Color(0xff461257),
                                        onPressed: () async {
                                          print("CLIENT DATA =====> " + Provider.of<SingleProfileProvider>(context, listen: false).clientData.toString());

                                          singleProfileProvider.setFinalStatus(0);
                              
                                          print(singleProfileProvider.formNo);
                                          print(singleProfileProvider.clientData['PAN'].toString());
                                          print(singleProfileProvider.chequeStatus.toString());
                                          print(singleProfileProvider.signStatus.toString());
                                          print(singleProfileProvider.photoLiveStatus.toString());
                                          print(singleProfileProvider.finalStatus.toString());
                              
                                          ResponseModel setFinalStatusResponseModel = await apiProvider.postRequest(
                                            endpoint: "api/RM/CheckerApproved",
                                            body: {
                                                "formNo": encryptString(singleProfileProvider.formNo),
                                                "panNo": encryptString(singleProfileProvider.clientData['PAN'].toString()),
                                                "chequeStatus": encryptString(singleProfileProvider.chequeStatus ? "1" : "0"),
                                                "signStatus": encryptString(singleProfileProvider.signStatus  ? "1" : "0"),
                                                "photo_VideoStatus": encryptString(singleProfileProvider.photoLiveStatus  ? "1" : "0"),
                                                "finalStatus": encryptString(singleProfileProvider.finalStatus.toString())
                                            }
                                          );
                                          print("SET FINAL STATUS DATA RESPONSE ====> " + setFinalStatusResponseModel.toJson().toString());

                                          showDialog(
                                            context: context, 
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Text("Client should be notified to do onboarding again and is not approved", style: TextStyle(fontFamily: 'SemiBold', color: Color(0xff461257)),),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }, 
                                                    child: Text("Ok", style: TextStyle(color: Color(0xff461257)),)
                                                  )
                                                ],
                                              );
                                            }
                                          );
                                          // bseApiProvider.onboarding(context, _searchController.text, singleProfileProvider.clientData);
                                        },
                                        child: Center(child: Text("Resend", style: TextStyle(color: Colors.white, fontFamily: 'SemiBold'),)),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.1,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        color: Color(0xff461257),
                                        onPressed: () async {                                          

                                          setState(() {
                                            _isLoading = true;
                                          });                                                                                                                               
                              
                              
                                          callUCC(singleProfileProvider.clientData).then((value) async {
                                            if(value['StatusCode'] == 101) {
                                              showErrorDialog(context, "${value['ErrorDescription']}\nAPI: api/ClientSignUp/SignUp");
                                            } else {
                                              // Calling the session id api here
                                              callSessionId().then((value) async {

                                                if(value['StatusCode'] == 101) {
                                                  showErrorDialog(context, "Session ID Error\nAPI: api/Common/GenerateClientSession");
                                                } else if(value['StatusCode'] == 100) {

                                                  // Update Client Type
                                                  callUpdateClientType(singleProfileProvider.clientData).then((value) {
                                                    if(value['StatusCode'] == 101) {
                                                      showErrorDialog(context, "Updating Client Type Error\nAPI: api/ClientOnboard/UpdateClientType");
                                                    } else if(value['StatusCode'] == 100) {
                                                      
                                                      // Checking Client CVL
                                                      callCheckCVL(singleProfileProvider.clientData).then((value) {
                                                        if(value['StatusCode'] == 101) {
                                                          showErrorDialog(context, "CVL Error\nAPI: api/ClientOnboard/CheckCVLPrimary");
                                                        } else if(value['StatusCode'] == 100) {
                                                          
                                                          // Updating Primary Info
                                                          callUpdatePrimaryInfo(singleProfileProvider.clientData).then((value) {
                                                            if(value['StatusCode'] == 101) {
                                                              showErrorDialog(context, "Updating Primary Info Error\nAPI: api/ClientOnboard/UpdatePersonalInfoPrimary");
                                                            } else if(value['StatusCode'] == 100) {

                                                              // Updating Address
                                                              callUpdateAddress(singleProfileProvider.clientData).then((value) {
                                                                if(value['StatusCode'] == 101) {
                                                                  showErrorDialog(context, "Updating Address Error\nAPI: api/ClientOnboard/UpdatePrimaryAddress");
                                                                } else if(value['StatusCode'] == 100) {

                                                                  // Calling Bank Details
                                                                  callBankDetails(singleProfileProvider.clientData).then((value) {
                                                                    if(value['StatusCode'] == 101) {
                                                                      showErrorDialog(context, "Bank Details Error\nAPI: api/ClientOnboard/UpdatePrimaryAddress");
                                                                    } else {

                                                                      // Updating Fatca Details
                                                                      callUpdateFatcaDetails(singleProfileProvider.clientData).then((value) {
                                                                        if(value['StatusCode'] == 101) {
                                                                          showErrorDialog(context, "Fatca Details Error\nAPI: api/ClientOnboard/UpdateFatcaDetails");                                  
                                                                        } else if(value['StatusCode'] == 100) {

                                                                          // Updating Nominee
                                                                          callUpdateNomineeInfo(singleProfileProvider.clientData).then((value) {
                                                                            if(value['StatusCode'] == 101) {
                                                                              showErrorDialog(context, "Nominee Info Error\nAPI: api/ClientOnboard/UpdateNomineeInfo");
                                                                            } else if(value['StatusCode'] == 100) {

                                                                              // Uploading Signature
                                                                              callSignDoc(singleProfileProvider.clientData).then((value) {
                                                                                if(value['StatusCode'] == 101) {
                                                                                  showErrorDialog(context, "Signature Error\nAPI: api/ClientOnboard/UpdateClientDocs");
                                                                                } else if(value['StatusCode'] == 100) {
                                                                                  // Uploading Cheque
                                                                                  callChequeDoc(singleProfileProvider.clientData).then((value) {
                                                                                    if(value['StatusCode'] == 101) {
                                                                                      showErrorDialog(context, "Cheque Error\nAPI: api/ClientOnboard/UpdateClientDocs");
                                                                                    } else if(value['StatusCode'] == 100) {
                                                                                      uploadDataToBSE().then((value) async {                                                                                          

                                                                                        setState(() {
                                                                                          _isLoading = false;
                                                                                        });

                                                                                        if(value['StatusCode'] == 100) {

                                                                                          singleProfileProvider.setFinalStatus(1);
                              
                                                                                          print(singleProfileProvider.formNo);
                                                                                          print(singleProfileProvider.clientData['PAN'].toString());
                                                                                          print(singleProfileProvider.chequeStatus.toString());
                                                                                          print(singleProfileProvider.signStatus.toString());
                                                                                          print(singleProfileProvider.photoLiveStatus.toString());
                                                                                          print(singleProfileProvider.finalStatus.toString());
                                                                              
                                                                                          ResponseModel setFinalStatusResponseModel = await apiProvider.postRequest(
                                                                                            endpoint: "api/RM/CheckerApproved",
                                                                                            body: {
                                                                                                "formNo": encryptString(singleProfileProvider.formNo),
                                                                                                "panNo": encryptString(singleProfileProvider.clientData['PAN'].toString()),
                                                                                                "chequeStatus": encryptString(singleProfileProvider.chequeStatus ? "1" : "0"),
                                                                                                "signStatus": encryptString(singleProfileProvider.signStatus  ? "1" : "0"),
                                                                                                "photo_VideoStatus": encryptString(singleProfileProvider.photoLiveStatus  ? "1" : "0"),
                                                                                                "finalStatus": encryptString(singleProfileProvider.finalStatus.toString())
                                                                                            }
                                                                                          ).then((value) async {
                                                                                            // MAP MF UCC WITH JM UCC
                                                                                            // If checker status is approved
                                                                                            if(value.statusCode == "0") {
                                                                                              Future.delayed(Duration(seconds: 2), () async {
                                                                                                ResponseModel mapUccResponse = await apiProvider.postRequest(
                                                                                                  endpoint: 'api/BSEAPI/UpdateUCC',
                                                                                                  body: {
                                                                                                    "formNo": encryptString(singleProfileProvider.formNo),
                                                                                                    "mf_UCC": encryptString(_ucc),
                                                                                                    "ucc": encryptString(singleProfileProvider.clientData['JMUCC'])
                                                                                                  }
                                                                                                  
                                                                                                );
                                                                                
                                                                                                print("UCC SAVE RESPONSE: " + mapUccResponse.toJson().toString());

                                                                                                if(mapUccResponse.statusCode.toString() != "0") {
                                                                                                  showErrorDialog(context, "${mapUccResponse.message}");
                                                                                                } else {
                                                                                                  showDialog(
                                                                                                    context: context, 
                                                                                                    builder: (context) {
                                                                                                      return AlertDialog(
                                                                                                        content: Text("Approval Confirmed! MF UCC: $_ucc", style: TextStyle(fontFamily: 'SemiBold', color: Color(0xff461257)),),
                                                                                                        actions: [
                                                                                                          TextButton(
                                                                                                            onPressed: () {
                                                                                                              Navigator.pop(context);
                                                                                                            }, 
                                                                                                            child: Text("Ok", style: TextStyle(color: Color(0xff461257)),)
                                                                                                          )
                                                                                                        ],
                                                                                                      );
                                                                                                    }
                                                                                                  );
                                                                                                }                                                                                                
                                                                                              });
                                                                                            } else {
                                                                                              // If checker details is not approved error
                                                                                              showDialog(
                                                                                                context: context, 
                                                                                                builder: (context) {
                                                                                                  return AlertDialog(
                                                                                                    content: Text("${value.message}", style: TextStyle(fontFamily: 'SemiBold', color: Color(0xff461257)),),
                                                                                                    actions: [
                                                                                                      TextButton(
                                                                                                        onPressed: () {
                                                                                                          Navigator.pop(context);
                                                                                                        }, 
                                                                                                        child: Text("Ok", style: TextStyle(color: Color(0xff461257)),)
                                                                                                      )
                                                                                                    ],
                                                                                                  );
                                                                                                }
                                                                                                );
                                                                                            }                                                                                          
                                                                                            return value;
                                                                                          }); 

                                                                                        } else {
                                                                                          showDialog(
                                                                                            context: context, 
                                                                                            builder: (context) {
                                                                                              return AlertDialog(
                                                                                                content: Text("Error in Sending data to BSE", style: TextStyle(fontFamily: 'SemiBold', color: Color(0xff461257)),),
                                                                                                actions: [
                                                                                                  TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                    }, 
                                                                                                    child: Text("Ok", style: TextStyle(color: Color(0xff461257)),)
                                                                                                  )
                                                                                                ],
                                                                                              );
                                                                                            }
                                                                                          );
                                                                                        }                                                                  
                                                                                      });
                                                                                    }
                                                                                  });
                                                                                }
                                                                              });
                                                                            }
                                                                          });
                                                                        }
                                                                      });
                                                                    }
                                                                  });
                                                                }
                                                              });
                                                            }                   
                                                          });
                                                        }
                                                      });
                                                    }
                                                  });
                                                } 
                                              });
                                            }                                            

                                            return value;                                        
                                          });                                                                                                                                                                                                                       
                              
                                        },
                                        child: Center(
                                          child: !_isLoading
                                              ? Text("Approve", style: TextStyle(color: Colors.white, fontFamily: 'SemiBold'),)
                                              : Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(color: Colors.white,)
                                                )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
      }
    );
  }
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