import 'package:contol_officer_app/API%20Service/apiClient.dart';
import 'package:contol_officer_app/Controller/Auth/authController.dart';
import 'package:contol_officer_app/Controller/Nav/navbar_controller.dart';
import 'package:contol_officer_app/Controller/profileController.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/Routes/route_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final apiClient = await Get.putAsync(() => ApiClient().init());

  Get.put(BottomNavBarController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(ProfileController(), permanent: true);

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

      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
