import 'dart:async';
import 'package:contol_officer_app/Controller/notificationController.dart';
import 'package:contol_officer_app/model/notificationModel.dart';
import 'package:contol_officer_app/utils/dialog_box.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/widgets/loader.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final OfficerNotificationController controller =
      Get.find<OfficerNotificationController>();

  @override
  void initState() {
    super.initState();
    // Refresh every time this screen is opened so the list stays current.
    controller.fetchOfficerNotifications();
  }

  void _confirmMarkAllRead() {
    CustomDialog.show(
      title: 'Mark all as read?',
      message:
          'This will mark all your notifications as read. This action cannot be undone.',
      confirmText: 'Mark all read',
      cancelText: 'Cancel',
      onConfirm: () {
        controller.markAllAsRead();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Recent Notifications', showBack: true),
      body: Obx(
        () => LoaderWrapper(
          isLoading: controller.isLoading.value,
          shimmerItems: 10,
          showCard: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.errorMessage.value.isNotEmpty) {
      return _buildMessageState(
        context: context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: controller.errorMessage.value,
        showRetry: true,
      );
    }

    if (controller.notifications.isEmpty) {
      return _buildMessageState(
        context: context,
        icon: Icons.notifications_none,
        iconColor: AppColors.textfieldBorder,
        message: 'No notifications yet',
        showRetry: false,
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(height: 1, color: AppColors.textfieldBorder),
              ),
              const SizedBox(width: 10),
              Obx(
                () => TextButton.icon(
                  onPressed: controller.isMarkingAllRead.value
                      ? null
                      : _confirmMarkAllRead,
                  icon: controller.isMarkingAllRead.value
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.done_all, size: 18),
                  label: const Text(
                    'Mark all read',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = controller.notifications[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: _deleteBackground(),
                  confirmDismiss: (_) => _confirmDelete(item.id),
                  child: NotificationCard(
                    item: item,
                    onTap: () => _openMemberDetails(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
    );
  }

  Future<bool> _confirmDelete(String notificationId) async {
    final completer = Completer<bool>();

    CustomDialog.show(
      title: 'Delete notification?',
      message:
          'This notification will be permanently removed. This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        final success = await controller.deleteNotification(notificationId);
        if (!completer.isCompleted) completer.complete(success);
      },
      onCancel: () {
        if (!completer.isCompleted) completer.complete(false);
      },
      isDismissible: false, // force explicit choice so Dismissible doesn't hang
    );

    return completer.future;
  }

  Widget _buildMessageState({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String message,
    required bool showRetry,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: iconColor),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.bodytextColor, fontSize: 14),
            ),
            if (showRetry) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.fetchOfficerNotifications,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

void _openMemberDetails(OfficerNotificationModel item) {
  Get.toNamed(
    '/customer-details',
    arguments: {
      'memberId': item.membershipId,    
      'customerId': item.membershipId,   
      'companyName': item.industryName, 
    },
  );
}
}

class NotificationCard extends StatelessWidget {
  final OfficerNotificationModel item;
  final VoidCallback onTap;

  const NotificationCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool unread = !item.read;
    final Color iconColor = unread ? AppColors.primary : AppColors.secondary;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textfieldBorder),
          color: unread ? AppColors.primary.withOpacity(0.03) : Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.receipt_long_outlined,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.industryName,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.bodytextColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.bodytextColor,
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subject,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: AppColors.bodytextColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      _statChip(
                        'Allocated',
                        item.allocated.display,
                        AppColors.primary,
                      ),
                      _statChip(
                        'Utilized',
                        item.utilized.display,
                        AppColors.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
