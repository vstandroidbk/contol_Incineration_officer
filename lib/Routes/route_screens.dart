import 'package:contol_officer_app/Modules/Concern/concern.dart';
import 'package:contol_officer_app/Modules/Field/field.dart';
import 'package:contol_officer_app/Modules/Home/homeview.dart';
import 'package:contol_officer_app/Modules/Notifications/notifications.dart';
import 'package:contol_officer_app/Modules/Reports/report.dart';
import 'package:contol_officer_app/Modules/authentication/email_verifly.dart';
import 'package:contol_officer_app/Modules/authentication/forgotpswrd.dart';
import 'package:contol_officer_app/Modules/authentication/login.dart';
import 'package:contol_officer_app/Modules/authentication/new_password.dart';
import 'package:contol_officer_app/Modules/profile/editProfile.dart';
import 'package:contol_officer_app/Modules/profile/profile.dart';
import 'package:contol_officer_app/ReusableWidgets/mainNav.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static final routes = <GetPage>[
    //authentication
  
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.emailVerification,
      page: () => const EmailVerificationScreen(),
    ),
    GetPage(
      name: AppRoutes.createNewPassword,
      page: () => const CreateNewPasswordScreen(),
    ),

 GetPage(
      name: AppRoutes.dashboard,
      page: () => MainScreen(),
    ),


    //home
    GetPage(name: AppRoutes.homeview, page: () => const Homeview()),

    //notification
    GetPage(name: AppRoutes.notifications, page: () => const Notifications()),
    //reports
    GetPage(name: AppRoutes.reports, page: () => const Report()),

    //Concern
    GetPage(name: AppRoutes.concern, page: () => const Concern()),

    //field
    GetPage(name: AppRoutes.field, page: () => const Field()),

    //profile
    GetPage(name: AppRoutes.profile, page: () => const Profile()),
    GetPage(name: AppRoutes.editProfile, page: () => const Editprofile()),
  ];
}
