import 'package:contol_officer_app/Controller/reportsController.dart';
import 'package:get/get.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportController(), fenix: true);
  }
}