import 'package:contol_officer_app/Controller/navBar_controller.dart';
import 'package:contol_officer_app/Modules/Concern/concern.dart';
import 'package:contol_officer_app/Modules/Field/field.dart';
import 'package:contol_officer_app/Modules/Home/homeview.dart';
import 'package:contol_officer_app/Modules/Reports/report.dart';
import 'package:contol_officer_app/Modules/profile/profile.dart';
import 'package:contol_officer_app/ReusableWidgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final navController = Get.find<BottomNavBarController>();

  final List<Widget> screens = [
    Homeview(),
    Report(),
    Concern(),
    Field(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navController.currentIndex.value != 0) {
          navController.changeTab(0);
          return false;
        }
        return true; // exit app if already on Home
      },
      child: Obx(() {
        return Scaffold(
          body: screens[navController.currentIndex.value],
          bottomNavigationBar: BottomNavBarDesign(),
        );
      }),
    );
  }
}
