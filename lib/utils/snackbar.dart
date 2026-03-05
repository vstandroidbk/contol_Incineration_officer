import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppSnackBar {
  /// ✅ SUCCESS
  static void success({
    BuildContext? context,
    required String message,
    int duration = 3,
  }) {
    _show(
      context,
      _CompactSnackBar(
        message: message,
        backgroundColor: AppColors.primary.withOpacity(0.9),
        icon: LucideIcons.partyPopper,
      ),
      duration,
    );
  }

  /// ❌ ERROR
  static void error({
    BuildContext? context,
    required String message,
    int duration = 3,
  }) {
    _show(
      context,
      _CompactSnackBar(
        message: message,
        backgroundColor: Colors.red.withOpacity(0.9),
        icon: Icons.error,
      ),
      duration,
    );
  }

  /// ℹ️ INFO
  static void info({
    BuildContext? context,
    required String message,
    int duration = 3,
  }) {
    _show(
      context,
      _CompactSnackBar(
        message: message,
        backgroundColor: Colors.blue.withOpacity(0.9),
        icon: Icons.info,
      ),
      duration,
    );
  }


//warning

 static void warning({
    BuildContext? context,
    required String message,
    int duration = 3,
  }) {
    _show(
      context,
      _CompactSnackBar(
        message: message,
        backgroundColor: AppColors.container2.withOpacity(0.9),
        icon: Icons.error,
      ),
      duration,
    );
  }


 static void _show(
    BuildContext? context,
    Widget snackBar,
    int duration,
  ) {
    // Attempt to find the overlay
   final targetContext = context ?? Get.context ?? Get.overlayContext;

    if (targetContext == null) return;

    // 2. Find Overlay safely
    final overlay = Overlay.of(targetContext);
    
    // Safety check: if overlay is null, use Get.overlayContext
    showTopSnackBar(
      overlay,
      snackBar,
      displayDuration: Duration(seconds: duration),
      dismissType: DismissType.onSwipe,
      dismissDirection: const [DismissDirection.up],
    );
  }
}

/// 🎯 COMPACT DESIGN (reduced vertical padding)
class _CompactSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;

  const _CompactSnackBar({
    required this.message,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(
          vertical: 14,   // 🔥 THIS controls height
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
