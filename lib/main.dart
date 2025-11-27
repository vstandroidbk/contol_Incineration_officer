import 'package:contol_officer_app/Controller/navBar_controller.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/Routes/route_screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 Register controller globally (won't rebuild, reused everywhere)
  Get.put(BottomNavBarController(), permanent: true);
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       title: 'Contol Officer App',
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
        fontFamily: "Manrope", // Apply custom font globally
      ),

     
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}
