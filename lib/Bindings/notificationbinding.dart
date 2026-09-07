import 'package:contol_officer_app/Controller/notificationController.dart';
import 'package:get/get.dart';

class OfficerNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OfficerNotificationController(), permanent: true);
  }
}