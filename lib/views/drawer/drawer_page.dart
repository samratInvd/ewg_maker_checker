import 'package:ewg_maker_checker/providers/routes_provider.dart';
import 'package:ewg_maker_checker/utils/navigator.dart';
import 'package:ewg_maker_checker/views/client_details/client_details_page.dart';
import 'package:ewg_maker_checker/views/clients/maker_checker_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// int currentTab = 0;
// int subcurrentTab = 0;

class ButtonsInfo {
  String title;

  ButtonsInfo({
    required this.title,
  });
}

class Task {
  String task;
  double taskValue;
  Color color;

  Task({required this.task, required this.taskValue, required this.color});
}

List<ButtonsInfo> _buttonNames = [
  ButtonsInfo(
    title: "Dashboard",
  ),
  ButtonsInfo(
    title: "Client",
  ),
  // ButtonsInfo(
  //   title: "Onboard new clients",
  // ),
  // ButtonsInfo(
  //   title: "Maker / Checker",
  // ),
  // ButtonsInfo(
  //   title: "All Clients",
  // ),
  ButtonsInfo(
    title: "Dynamic Updates",
  ),
  ButtonsInfo(
    title: "Roles Management",
  ),
  ButtonsInfo(
    title: "Other",
  ),
  ButtonsInfo(
    title: "Settings",
  ),
  ButtonsInfo(
    title: "Research",
  ),
  ButtonsInfo(
    title: "Downloads",
  ),
];

class DrawerPage extends StatefulWidget {
  // int cindex = 0;
  late Function() notifyParent;

  DrawerPage({required this.notifyParent});
  // DrawerPage({required this.cindex});
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  //final List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    // currentTab=widget.cindex;
    // screens.add(HomeGridScreen());
    // screens.add(FalconCafeGridScreen());
    // screens.add(AuditoriumScreen());
    // screens.add(MeetingRoomScreen());
    // screens.add(ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<RoutesProvider>(
      builder: (context, RoutesProvider routesProvider, _) {
        return Drawer(
          backgroundColor: Color(0xff9F4BBB),
          elevation: 0,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ListTile(
                  //   // title: Text(
                  //   //   "Admin Menu",
                  //   //   style: TextStyle(
                  //   //     color: Colors.white,
                  //   //   ),
                  //   // ),
                  //   trailing: !ResponsiveLayout.isComputer(context)
                  //       ? IconButton(
                  //           onPressed: () {
                  //             Navigator.pop(context);
                  //           },
                  //           icon: Icon(Icons.close, color: Colors.white),
                  //         )
                  //       : null,
                  // ),

                  // InkWell(
                  //     onTap: () {
                  //
                  //     },
                  //     child: Container(
                  //         alignment: Alignment.center,
                  //         padding: EdgeInsets.symmetric(vertical: 20),
                  //         //   padding: EdgeInsets.only(left: 200, top: 100),
                  //         width: screenWidth,
                  //         //height: screenHeight / 8,
                  //         decoration: BoxDecoration(
                  //             // gradient: LinearGradient(
                  //             //     colors: [Color(0xff4DC8F4), Colors.blueAccent],
                  //             //     begin: Alignment.topCenter,
                  //             //     end: Alignment.bottomCenter)
                  //             ),
                  //         child: Text('JM Financial', style: TextStyle(color: Colors.white, fontFamily: 'Bold',fontSize: 22),),)),

                  // SizedBox(
                  //   height: 20,
                  // ),

                  // ExpansionTile(
                  //     title: Text("Clients",style:
                  // TextStyle(
                  // color: Colors.white,
                  // fontSize: 14),),
                  //     childrenPadding: EdgeInsets.only(left: 60), //children padding
                  //     children: [
                  //       ListTile(
                  //         title: Text(
                  //           'Onboard new clients',
                  //           style:
                  //           TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 14),
                  //         ),
                  //         onTap: () {
                  //           //action on press
                  //         },
                  //       ),
                  //       ListTile(
                  //         title: Text("Maker / Checker",style:
                  //         TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 14),),
                  //         onTap: () {
                  //           //action on press
                  //         },
                  //       ),
                  //       ListTile(
                  //         title: Text("All Clients",style:
                  //             TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 14),),
                  //         onTap: () {
                  //           //action on press
                  //         },
                  //       ),
                  //
                  //     ]),

                  //more child menu

                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _buttonNames.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              print(index);
                              setState(() {
                                routesProvider.setCurrentTab(index);
                              });
                              widget.notifyParent();
                            },
                            child:
                              _buttonNames[index].title == "Client"
                                  ? ExpansionTile(
                                      //backgroundColor: Colors.red,
                                      //collapsedBackgroundColor: Colors.deepPurple,
                                      //iconColor: Colors.white,
                                      tilePadding:
                                          EdgeInsets.only(left: 50, right: 20),
                                      title: Text(
                                        "Clients",
                                        style: TextStyle(
                                            color: index == routesProvider.currentTab
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                      ),
                                      childrenPadding: EdgeInsets.only(
                                          left: 60), //children padding
                                      children: [
                                          Container(
                                              //alignment: Alignment.center,
                                              decoration: index == routesProvider.currentTab && routesProvider.subCurrentTab==0
                                                  ? BoxDecoration(
                                                      //borderRadius: BorderRadius.circular(10),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          //Colors.purple,
                                                          Colors.deepPurple,
                                                          Colors.deepPurple,
                                                          //Colors.purple
                                                        ],
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey))
                                                  : null,
                                              child: ListTile(
                                                title: Text(
                                                  'Onboard new clients',
                                                  style: TextStyle(
                                                      color: index == routesProvider.currentTab && routesProvider.subCurrentTab==0
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 14),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    routesProvider.setSubCurrentTab(0);
                                                    routesProvider.setCurrentTab(1);
                                                    print("Tab");
                                                    print(routesProvider.currentTab);
                                                    widget.notifyParent();
                                                  });
                                                  //action on press
                                                  //Navigation.pushReplacement(context: context, child: MakerCheckerPage());
                                                },
                                              )),
                                          Container(
                                              //alignment: Alignment.center,
                                              decoration: index == routesProvider.currentTab && routesProvider.subCurrentTab==1
                                                  ? BoxDecoration(
                                                      //borderRadius: BorderRadius.circular(10),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          //Colors.purple,
                                                          Colors.deepPurple,
                                                          Colors.deepPurple,
                                                          //Colors.purple
                                                        ],
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey))
                                                  : null,
                                              child: ListTile(
                                                title: Text(
                                                  "Maker / Checker",
                                                  style: TextStyle(
                                                      color: index == routesProvider.currentTab && routesProvider.subCurrentTab==1
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 14),
                                                ),
                                                onTap: () {
                                                  //action on press
                                                  setState(() {
                                                    routesProvider.setSubCurrentTab(1);
                                                    routesProvider.setCurrentTab(1);
                                                    print("Tab");
                                                    print(routesProvider.currentTab);
                                                    widget.notifyParent();
                                                  });

                                                  // Navigation.pushReplacement(
                                                  //     context: context,
                                                  //     child: MakerCheckerPage());
                                                },
                                              )),
                                          Container(
                                              //alignment: Alignment.center,
                                              decoration: index == routesProvider.currentTab && routesProvider.subCurrentTab==2
                                                  ? BoxDecoration(
                                                      //borderRadius: BorderRadius.circular(10),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          //Colors.purple,
                                                          Colors.deepPurple,
                                                          Colors.deepPurple,
                                                          //Colors.purple
                                                        ],
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey))
                                                  : null,
                                              child: ListTile(
                                                title: Text(
                                                  "All Clients",
                                                  style: TextStyle(
                                                      color: index == routesProvider.currentTab && routesProvider.subCurrentTab==2
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 14),
                                                ),
                                                onTap: () {
                                                  //action on press
                                                  setState(() {
                                                    routesProvider.setSubCurrentTab(2);
                                                    routesProvider.setCurrentTab(1);
                                                    print("Tab");
                                                    print(routesProvider.currentTab);
                                                    widget.notifyParent();
                                                  });


                                                  // Navigation.pushReplacement(
                                                  //     context: context,
                                                  //     child: ClientDetailsPage());
                                                },
                                              )),
                                        ])
                                  : Container(
                        //alignment: Alignment.center,
                        decoration: index == routesProvider.currentTab
                        ? BoxDecoration(
                        //borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                        colors: [
                        //Colors.purple,
                        Colors.deepPurple,
                        Colors.deepPurple,
                        //Colors.purple
                        ],
                        ),
                        border: Border.all(color: Colors.grey))
                            : null,
                        child:ListTile(
                                      //minLeadingWidth: 70,
                                      contentPadding: EdgeInsets.only(left: 50),
                                      title: Text(
                                        _buttonNames[index].title,
                                        style: TextStyle(
                                            color: index == routesProvider.currentTab
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                      ),

                                      // onTap: () {
                                      //   setState(() {
                                      //     currentTab =  index;
                                      //   });
                                      // },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    )),
                            );
                      }),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
