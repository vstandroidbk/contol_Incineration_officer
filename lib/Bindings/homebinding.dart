import 'package:contol_officer_app/Controller/homecontroller.dart';
import 'package:get/get.dart';

class MemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MemberController(), fenix: true);
  }
}