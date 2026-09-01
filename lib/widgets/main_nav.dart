import 'package:contol_officer_app/Controller/Nav/navbar_controller.dart';
import 'package:contol_officer_app/View/Customers/customers.dart';
import 'package:contol_officer_app/View/Home/homeview.dart';
import 'package:contol_officer_app/View/Reports/report.dart';
import 'package:contol_officer_app/View/profile/profile.dart';
import 'package:contol_officer_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final navController = Get.find<BottomNavBarController>();

  final List<Widget> screens = [Homeview(), Customers(),  Report(), Profile()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navController.currentIndex.value != 0) {
          navController.changeTab(0);
          return false;
        }
        return true;
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
