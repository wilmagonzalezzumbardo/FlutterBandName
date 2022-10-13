import 'package:fl_11_bandname/pages/routes.dart';
import 'package:fl_11_bandname/pages/status.dart';
import 'package:fl_11_bandname/services/sockets_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 


//void main() => runApp(MyApp());
void main() => runApp(ManejadorEstado());

class ManejadorEstado extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider
    (
      providers: 
      [
        ChangeNotifierProvider
        (
          create: (_) => new SocketService(),
        ),
      ],
      child: MyApp(),
    );
  }
}

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