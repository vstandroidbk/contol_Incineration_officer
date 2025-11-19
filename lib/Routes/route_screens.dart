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
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:flutter/material.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    //authentication
    AppRoutes.login: (context) => const LoginScreen(),
    AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
    AppRoutes.emailVerification: (context) => const EmailVerificationScreen(),
    AppRoutes.createNewPassword: (context) => const CreateNewPasswordScreen(),

    //home
    AppRoutes.homeview: (context) => const Homeview(),

    //notification
    AppRoutes.notifications : (context) => const Notifications() ,

    //reports
    AppRoutes.reports: (context) => const Report(),

    //Concern
    AppRoutes.concern: (context) => const Concern(),

    //field
    AppRoutes.field: (context) => const Field(),

    //profile
    AppRoutes.profile: (context) => const Profile(),
    AppRoutes.editProfile: (context)=> const Editprofile()
  };
}
