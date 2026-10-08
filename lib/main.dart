import 'package:contol_officer_app/API%20Service/apiClient.dart';
import 'package:contol_officer_app/Controller/Auth/authController.dart';
import 'package:contol_officer_app/Controller/Nav/navbar_controller.dart';
import 'package:contol_officer_app/Controller/profileController.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/Routes/route_screens.dart';
import 'package:contol_officer_app/Controller/notificationController.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:contol_officer_app/utils/file_download.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';

//onesignal app id a0591f61-33e7-45d9-baf2-51f5dbea7699
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

SystemChrome.setSystemUIOverlayStyle(
  const SystemUiOverlayStyle(
    // ⬇️ statusBarColor hata diya — Android 15+ pe ye deprecated hai,
    // edge-to-edge mode me bars hamesha transparent hoti hain, color set karna allowed nahi
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  ),
);
  final apiClient = await Get.putAsync(() => ApiClient().init());

  Get.put(BottomNavBarController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  Get.put(OfficerNotificationController(), permanent: true);

  // 🔹 Start listening for native DownloadManager completion/failure
  // callbacks (from MainActivity.kt's registerDownloadCompleteReceiver).
  FileDownloadHelper.initDownloadListener();

  // 🔹 Fire OneSignal init — not awaited, so it won't block first frame.
  initOneSignal();

  runApp(const MyApp());
}

Future<void> initOneSignal() async {
  OneSignal.initialize("a0591f61-33e7-45d9-baf2-51f5dbea7699");
  await OneSignal.Notifications.requestPermission(true);

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    event.notification.display();
    debugPrint("🔔 OneSignal foreground push received");

    // ✅ Controller already registered in main() — this will always run
    Get.find<OfficerNotificationController>().onPushReceived();
  });

  final userId = await AppSession.getUserId();
  if (userId != null && userId.isNotEmpty && userId != "null") {
    OneSignal.login(userId.trim());

    // ✅ Re-enable push subscription in case it was opted out on previous logout
    OneSignal.User.pushSubscription.optIn();

    final pushId = OneSignal.User.pushSubscription.id;
    if (pushId != null && pushId.isNotEmpty) {
      await AppSession.savePlayerId(pushId);
      debugPrint("🚀 Sending to Backend: User $userId has Push ID $pushId");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
