import 'dart:developer';

import 'package:ewg_maker_checker/data/encryption.dart';
import 'package:ewg_maker_checker/models/response_model.dart';
import 'package:ewg_maker_checker/providers/api_provider.dart';
import 'package:ewg_maker_checker/providers/single_profile_provider.dart';
import 'package:ewg_maker_checker/utils/navigator.dart';
import 'package:ewg_maker_checker/views/layout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    Provider.of<SingleProfileProvider>(context, listen: false).clearAllClients();          

    Provider.of<ApiProvider>(context, listen: false).postRequestAuth()
      .then((_) async {


        /// Making a POST request to the API endpoint 'api/RM/Get_ClientDetailsForChecker' with a request body
        /// containing a key-value pair where the key is "FormNo" and the value is the encrypted string
        /// "1241". The response from the API is stored in a ResponseModel object called responseModel using
        /// the await keyword to wait for the response to be returned before continuing with the execution of
        /// the code.
        ResponseModel responseModel = await Provider.of<ApiProvider>(context, listen: false).postRequest(
          endpoint: 'api/RM/Get_ClientDetailsForChecker',
          body: {
            "FormNo": encryptString("1233")
          }
        );

        log(responseModel.data!.toString());   
        print("PRINT DATA: " + responseModel.data!['clientDetailsForCheckerMaker'][0].toString());    
        Provider.of<SingleProfileProvider>(context, listen: false).setClientData(responseModel.data!['clientDetailsForCheckerMaker'][0]);
        Provider.of<SingleProfileProvider>(context, listen: false).separateDetailsInClientData(responseModel.data!['clientDetailsForCheckerMaker'][0]);

        log(Provider.of<SingleProfileProvider>(context, listen: false).clientDataSeparated.toString());

        Navigation.pushReplacement(context: context, child: LayoutPage());

      });  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Fetching Data", style: TextStyle(fontFamily: 'Bold', fontSize: 30, color: Color(0xff461257)),),
            SizedBox(width: 20,),
            Container(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(color: Color(0xff461257), strokeWidth: 5,)
            )
          ],
        ),
      ),
    );
  }
}