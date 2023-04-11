import 'dart:io';

import 'package:ewg_maker_checker/providers/api_provider.dart';
import 'package:ewg_maker_checker/providers/bse_api_provider.dart';
import 'package:ewg_maker_checker/providers/single_profile_provider.dart';
import 'package:ewg_maker_checker/views/clients/maker_checker_page.dart';
import 'package:ewg_maker_checker/views/dashboard/dashboard_page.dart';
import 'package:ewg_maker_checker/views/layout_page.dart';
import 'package:ewg_maker_checker/views/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
     ..badCertificateCallback = (X509Certificate cert, String host, int 
    port)=> true;
 }
}


void main() {
  runApp(
    MultiProvider(
      providers: [        
        ChangeNotifierProvider(create: (context) => ApiProvider(),),
        ChangeNotifierProvider(create: (context) => SingleProfileProvider(),),
        ChangeNotifierProvider(create: (context) => BseApiProvider(),),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EWG Maker Checker',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Medium'
      ),
      home: SplashScreen(),      
    );
  }
}
