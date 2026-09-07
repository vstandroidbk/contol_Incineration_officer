import 'package:contol_officer_app/model/notificationModel.dart';
import 'package:contol_officer_app/services/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfficerNotificationController extends GetxController {
  final OfficerNotificationService _service = OfficerNotificationService();

  var isLoading = false.obs;
  var isMarkingAllRead = false.obs; // ADD THIS
  var errorMessage = ''.obs;
  var notifications = <OfficerNotificationModel>[].obs;

  var isDeleting = false.obs; // ADD near other .obs fields

  int get unreadCount => notifications.where((n) => !n.read).length;

  @override
  void onInit() {
    super.onInit();
    fetchOfficerNotifications();
  }

  Future<void> fetchOfficerNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _service.getOfficerNotifications();

      if (res["status"] == "SUCCESS") {
        if (res["data"] != null) {
          final list = OfficerNotificationListResponse.fromJson(
            res["data"] as List<dynamic>,
          );
          notifications.assignAll(list.notifications);
        } else {
          notifications.clear();
        }
      } else {
        notifications.clear();
        errorMessage.value = res["message"] ?? "Something went wrong.";
      }
    } catch (e) {
      notifications.clear();
      errorMessage.value = "Something went wrong. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Mark all notifications as read, then refresh the list.
  Future<void> markAllAsRead() async {
    if (isMarkingAllRead.value) return;
    try {
      isMarkingAllRead.value = true;

      final res = await _service.readAllOfficerNotifications();

      if (res["status"] == "SUCCESS") {
        await fetchOfficerNotifications(); // re-fetch, gets fresh read flags from API
        Get.snackbar(
          'Success',
          res["message"] ?? 'All notifications marked as read',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          res["message"] ?? 'Could not mark notifications as read',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isMarkingAllRead.value = false;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      isDeleting.value = true;

      final res = await _service.deleteOfficerNotification(notificationId);

      if (res["status"] == "SUCCESS") {
        notifications.removeWhere((n) => n.id == notificationId);
        _showSnackbarSafely(
          'Deleted',
          res["message"] ?? 'Notification deleted',
        );
        return true;
      } else {
        _showSnackbarSafely(
          'Error',
          res["message"] ?? 'Could not delete notification',
        );
        return false;
      }
    } catch (e) {
      _showSnackbarSafely('Error', 'Something went wrong. Please try again.');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  void _showSnackbarSafely(String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (Get.context != null) {
          Get.snackbar(title, message, snackPosition: SnackPosition.TOP);
        }
      });
    });
  }

  Future<void> refresh() => fetchOfficerNotifications();
}
