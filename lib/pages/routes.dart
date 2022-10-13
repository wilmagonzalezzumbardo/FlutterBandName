import 'package:fl_11_bandname/pages/status.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'manto.dart';

class MenuOptions {
  final String route;
  final IconData icon;
  final String name;
  final Widget screen;
  final Color color;

  MenuOptions(
      {required this.route,
      required this.icon,
      required this.name,
      required this.screen,
      required this.color});
}

class AppRoutes {
  static const initialRoute = "home";
  static final menuOptions = <MenuOptions>[
    MenuOptions(
      route: 'home',
      name: 'Home Screen',
      screen: const HomeScreen(),
      icon: Icons.home,
      color: Colors.red,
    ),
    MenuOptions(
      route: 'status',
      name: 'Status Page',
      screen: const StatusPage(),
      icon: Icons.home,
      color: Colors.red,
    ),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoute() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }
    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print(settings);
    return MaterialPageRoute(
      builder: (context) => const MantoScreen(),
    );
  }
}