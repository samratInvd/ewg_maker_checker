import 'package:ewg_maker_checker/views/clients/maker_checker_page.dart';
import 'package:ewg_maker_checker/views/dashboard/dashboard_page.dart';
import 'package:ewg_maker_checker/views/dynamic_updates/dynamic_updates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  String selectedRoute = "/makerChecker";
  Map<String, dynamic> routes = {
    "/dashboard": DashboardPage(),
    "/makerChecker": MakerCheckerPage(),
    "/dynamicUpdates": DynamicUpdatesPage(),
  };


  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('JM Financial', style: TextStyle(color: Colors.white, fontFamily: 'Bold'),),
        backgroundColor: Color(0xff461257),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      sideBar: SideBar(
        backgroundColor: Color(0xff9F4BBB),
        activeBackgroundColor: Color(0xff9F4BBB),
        // activeBackgroundColor: Color(0xff8A3DA3),
        activeTextStyle: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'SemiBold'),
        textStyle: TextStyle(color: Colors.white, fontSize: 14),
        borderColor: Colors.transparent,
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: '/dashboard',   
          ),
          AdminMenuItem(
            title: 'Clients',
            // icon: Icons.file_copy,
            children: [
              AdminMenuItem(
                title: 'Clients',
                route: '/a',
              ),
              AdminMenuItem(
                title: 'Onboard new clients',
                route: '/a',
              ),
              AdminMenuItem(
                title: 'Maker / Checker',
                route: '/makerChecker',
              ),
            ],
          ),
          AdminMenuItem(
            title: 'Dynamic Updates',
            route: '/dynamicUpdates',   
          ),
          AdminMenuItem(
            title: 'Roles Management',
            route: '/a',   
          ),
          AdminMenuItem(
            title: 'Other',
            route: '/a',   
          ),
          AdminMenuItem(
            title: 'Settings',
            route: '/a',   
          ),
          AdminMenuItem(
            title: 'Research',
            route: '/a',   
          ),
          AdminMenuItem(
            title: 'Downloads',
            route: '/a',   
          ),

        ],
        selectedRoute: selectedRoute,
        // selectedRoute: '/makerChecker',        
        onSelected: (item) {  
          setState(() {
            selectedRoute = item.route!;
          });
        },
      ),
      body: SingleChildScrollView(
        child: routes[selectedRoute],
      ),
    );
  }
}