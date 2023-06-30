import 'package:ewg_maker_checker/providers/routes_provider.dart';
import 'package:ewg_maker_checker/views/clients/maker_checker_page.dart';
import 'package:ewg_maker_checker/views/dashboard/dashboard_page.dart';
import 'package:ewg_maker_checker/views/dynamic_updates/dynamic_updates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:provider/provider.dart';

import 'client_details/client_details_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  // String selectedRoute = "";
  Map<String, dynamic> routes = {
    "/dashboard": DashboardPage(),
    "/makerChecker": MakerCheckerPage(),
    "/dynamicUpdates": DynamicUpdatesPage(),
    "/clientDetails": ClientDetailsPage()
  };

  String dropdownValue = 'Pending';

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutesProvider>(
      builder: (context, RoutesProvider routesProvider, _) {
        return AdminScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('JM Financial', style: TextStyle(color: Colors.white, fontFamily: 'Bold'),),
            backgroundColor: Color(0xff461257),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          sideBar: SideBar(
            backgroundColor: Color(0xff9F4BBB),
            activeBackgroundColor: Colors.deepPurple,
            //activeBackgroundColor: Color(0xff8A3DA3),
            activeTextStyle: TextStyle(color: Colors.white, fontSize: 14),
            textStyle: TextStyle(color: Colors.white, fontSize: 14),
            borderColor: Colors.transparent,
            items: const [
              AdminMenuItem(
                title: 'Dashboard',
                route: '/dashboard',
              ),
              AdminMenuItem(
                title: 'Client',
                // icon: Icons.file_copy,
                children: [
                  /*AdminMenuItem(
                    title: 'Client',
                    route: '/a',
                  ),*/
                  AdminMenuItem(
                    title: 'Onboard new clients',
                    route: '/a',
                  ),
                  AdminMenuItem(
                    title: 'Maker / Checker',
                    route: '/makerChecker',
                  ),
                  AdminMenuItem(
                    title: 'All Clients',
                    route: '/clientDetails',
                  ),
                  /*AdminMenuItem(
                    title: 'Approved Clients',
                    route: '/clientDetails',
                  ),
                  AdminMenuItem(
                    title: 'Rejected Clients',
                    route: '/clientDetails',
                  ),*/
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
            selectedRoute: routesProvider.selectedRoute,
            // routesProvider.selectedRoute: '/makerChecker',
            onSelected: (item) {
              /// `routesProvider.setSelectedRoute(item.route!);` is setting the selected route in the
              /// `RoutesProvider` to the route of the selected menu item. The `!` operator is used to
              /// assert that `item.route` is not null, since it is a non-nullable type.
              routesProvider.setSelectedRoute(item.route!);
              //AppCubit.get(context).screenSelector(item);

            },
          ),
          body: SingleChildScrollView(
            child: routes[routesProvider.selectedRoute],
          ),
        );
      }
    );
  }
}

