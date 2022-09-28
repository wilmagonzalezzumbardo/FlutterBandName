import 'package:fl_11_bandname/pages/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.getAppRoute(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}