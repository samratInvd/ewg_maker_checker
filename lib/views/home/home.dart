import 'dart:io';
import 'package:ewg_maker_checker/views/client_details/client_details_page.dart';
import 'package:ewg_maker_checker/views/clients/maker_checker_page.dart';
import 'package:ewg_maker_checker/views/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';

import '../drawer/drawer_page.dart';
import '../dynamic_updates/dynamic_updates.dart';
//import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;

  late BuildContext myContext;
  bool _isExpanded = true;

  // Our first view in viewpot
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: webLayout(screenHeight, screenWidth),
    );
  }

  Widget webLayout(double screenHeight, double screenWidth) {
    return Container(
        color: Colors.white,
        child: Column(children: [
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Color(0xff461257),
                  child: Row(children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Container(
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        )),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'JM Financial',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Bold',
                          fontSize: 20),
                    ),
                  ]))),
          Expanded(
              flex: 14,
              child: Row(
                children: [
                  Container(
                      //padding:EdgeInsets.only(right: 100),
                      //margin:EdgeInsets.only(right: 100),
                      //flex: 1,
                      child:
                          // AnimatedContainer(
                          //     duration: Duration(milliseconds: 300),
                          //     curve: Curves.linear,
                          //     height: _isExpanded ? 1000 : 1,
                          //     width: double.infinity,
                          //     color: Colors.red,
                          //     child:
                          Visibility(
                              visible: _isExpanded,
                              maintainAnimation: true,
                              maintainState: true,
                              child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                  opacity: _isExpanded ? 1.0 : 0.0,
                                  child: DrawerPage(
                                    notifyParent: () {
                                      print("refresh1");
                                      setState(() {});
                                    },
                                  )))),
                  //),
                  Expanded(
                    flex: 15,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: currentTab == 0
                            ? DashboardPage()
                            : currentTab == 1
                                ? subcurrentTab == 0
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Onboard new clients',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Bold'),
                                        ),
                                      )
                                    : subcurrentTab == 1
                                        ? MakerCheckerPage()
                                        : subcurrentTab == 2
                                            ? ClientDetailsPage()
                                            : Container()

                                //     : currentTab == 2
                                //         ? Container(
                                //             alignment: Alignment.center,
                                //             child: Text(
                                //               'Onboard new clients',
                                //               style: TextStyle(
                                //                   color: Colors.black,
                                //                   fontFamily: 'Bold'),
                                //             ),
                                //           )
                                //         : currentTab == 3
                                //             ? MakerCheckerPage()
                                //             : currentTab == 4
                                //                 ? ClientDetailsPage()
                                : currentTab == 2
                                    ? DynamicUpdatesPage()
                                    : currentTab == 3
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Roles Management',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Bold'),
                                            ),
                                          )
                                        : currentTab == 4
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Other',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Bold'),
                                                ),
                                              )
                                            : currentTab == 5
                                                ? Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Settings',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Bold'),
                                                    ),
                                                  )
                                                : currentTab == 6
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Research',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Bold'),
                                                        ),
                                                      )
                                                    : currentTab == 7
                                                        ? Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Downloads',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Bold'),
                                                            ),
                                                          )
                                                        : Container()),

                    // Expanded(
                    //   child: Container(),
                    // ),
                    // Expanded(
                    //   child: Container(),
                    // )
                  )
                ],
              )),
        ]));
  }
}

class Constants {
  Constants._();
  static const double padding = 30;
  static const double avatarRadius = 45;
}
