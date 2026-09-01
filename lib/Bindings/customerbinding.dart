import 'package:contol_officer_app/Controller/customerController.dart';
import 'package:get/get.dart';

class AllCustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllCustomersController(), permanent: true);
  }
}
