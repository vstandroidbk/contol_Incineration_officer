import 'package:contol_officer_app/API Service/apiClient.dart';
import 'package:contol_officer_app/API Service/apiUrls.dart';
import 'package:get/get.dart';

class OfficerNotificationService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Map<String, dynamic>> getOfficerNotifications() async {
    return await _apiClient.post(ApiUrls.getOfficerNotifications, body: {});
  }

  /// 🔹 Mark all officer notifications as read
  Future<Map<String, dynamic>> readAllOfficerNotifications() async {
    return await _apiClient.post(ApiUrls.readAllOfficerNotifications, body: {});
  }

  Future<Map<String, dynamic>> deleteOfficerNotification(
    String notificationId,
  ) async {
    return await _apiClient.post(
      ApiUrls.deleteOfficerNotification,
      body: {'notificationId': notificationId},
    );
  }
}
