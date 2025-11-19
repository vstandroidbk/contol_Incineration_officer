import 'package:contol_officer_app/ReusableWidgets/appBar.dart';
import 'package:contol_officer_app/ReusableWidgets/loader.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Reminder for your meetings',
      description: 'Learn more about managing account info and activity',
      timeAgo: '9 min ago',
      iconColor: AppColors.primary,
      icon: Icons.notifications_none,
      badgeCount: 2,
      badgeColor: AppColors.primary,
    ),
    NotificationItem(
      title: 'Robert mention you!',
      description: 'Learn more about managing account info and activity',
      timeAgo: '14 min ago',
      iconColor: AppColors.secondary,
      icon: Icons.notifications_none,
      badgeCount: 0,
      badgeColor: Colors.transparent,
    ),
    NotificationItem(
      title: 'Reminder for your File',
      description: 'Learn more about managing account info and activity',
      timeAgo: '9 min ago',
      iconColor: AppColors.error,
      icon: Icons.notifications_none,
      badgeCount: 2,
      badgeColor: Colors.green.shade700,
    ),
  ];
   bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate network/data load
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Recent Notifications', showBack: true),
      body: LoaderWrapper(
        isLoading: isLoading,
        shimmerItems: 10,
        showCard: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

                  // Horizontal line
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.textfieldBorder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return NotificationCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textfieldBorder),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: item.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(item.icon, color: item.iconColor, size: 24),
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
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.bodytextColor,
                        ),
                      ),
                    ),
                    Text(
                      item.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.description,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.bodytextColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    if (item.badgeCount > 0) ...[
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: item.badgeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Text(
                          '${item.badgeCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String timeAgo;
  final Color iconColor;
  final IconData icon;
  final int badgeCount;
  final Color badgeColor;

  NotificationItem({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.iconColor,
    required this.icon,
    required this.badgeCount,
    required this.badgeColor,
  });
}
