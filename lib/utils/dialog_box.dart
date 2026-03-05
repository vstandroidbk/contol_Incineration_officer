import 'dart:ui';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static void show({
    required String title,
    required String message,
    Color textColor = Colors.black,
    String confirmText = "OK",
    String cancelText = "Cancel",
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDismissible = true,
    VoidCallback? onClose,
    bool showCloseIcon = false,
    Duration? autoDismissDuration,
  }) {
    Get.dialog(
      Builder(
        builder: (dialogContext) {
          return TweenAnimationBuilder(
            duration: const Duration(milliseconds: 250),
            tween: Tween(begin: 0.8, end: 1.0),
            curve: Curves.fastOutSlowIn,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TITLE (clean, centered)
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // MESSAGE
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),

                          const SizedBox(height: 18),

                          // ACTION BUTTONS
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    onCancel?.call();
                                  },
                                  child: Text(
                                    cancelText,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    onConfirm?.call();
                                  },
                                  child: Text(
                                    confirmText,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ❌ TOP-RIGHT CLOSE ICON (floating)
                    if (showCloseIcon)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          splashRadius: 18,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            //onClose?.call();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(0.25),
    );

    /// Auto-dismiss (Navigator-based)
    if (autoDismissDuration != null) {
      Future.delayed(autoDismissDuration, () {
        if (Get.isDialogOpen == true) {
          Navigator.of(Get.overlayContext!).pop();
        }
      });
    }
  }
}
