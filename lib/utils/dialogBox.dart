import 'dart:ui';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static void show({
    required String title,
    required String message,
    Color textColor= Colors.black,
    String confirmText = "OK",
    String cancelText = "Cancel",
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDismissible = true,
    Duration? autoDismissDuration, // ⬅ auto dismiss support
  }) {
    Get.dialog(
      TweenAnimationBuilder(
        duration: const Duration(milliseconds: 250), // ⬅ animation duration
        tween: Tween(begin: 0.8, end: 1.0),
        curve: Curves.fastOutSlowIn,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // ⬅ background blur
          child: Dialog(
           
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary, width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            if (onCancel != null) onCancel();
                          },
                          child: Text(
                            cancelText,
                            style: TextStyle(
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            if (onConfirm != null) onConfirm();
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
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(0.25), // ⬅ dimmed background
    );

    // Auto-dismiss logic
    if (autoDismissDuration != null) {
      Future.delayed(autoDismissDuration, () {
        if (Get.isDialogOpen == true) Get.back();
      });
    }
  }
}
