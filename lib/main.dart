import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/Routes/route_screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       title: 'Contol Officer App',
      debugShowCheckedModeBanner: false,
     
      initialRoute: AppRoutes.login,
      routes: AppPages.routes,
    );
  }
}
