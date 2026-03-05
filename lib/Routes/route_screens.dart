import 'package:contol_officer_app/Bindings/authbinding.dart';
import 'package:contol_officer_app/Splash/splashScreen.dart';
import 'package:contol_officer_app/View/Concern/concern.dart';
import 'package:contol_officer_app/View/Field/field.dart';
import 'package:contol_officer_app/View/Home/homeview.dart';
import 'package:contol_officer_app/View/Notifications/notifications.dart';
import 'package:contol_officer_app/View/Reports/report.dart';
import 'package:contol_officer_app/View/authentication/email_verify.dart';
import 'package:contol_officer_app/View/authentication/forgotpswrd.dart';
import 'package:contol_officer_app/View/authentication/login.dart';
import 'package:contol_officer_app/View/authentication/new_password.dart';
import 'package:contol_officer_app/View/profile/edit_profile.dart';
import 'package:contol_officer_app/View/profile/profile.dart';
import 'package:contol_officer_app/widgets/main_nav.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static final routes = <GetPage>[
    //authentication
  
    GetPage(name: AppRoutes.login, page: () => const LoginScreen(),binding: AuthBinding()),
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
      name: AppRoutes.splash,
      page: () => SplashScreen()
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
