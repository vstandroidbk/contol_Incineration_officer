import 'package:contol_officer_app/Controller/profileController.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/snackbar.dart'; // 👈 adjust path as per your project
import 'package:contol_officer_app/utils/validation.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _confirmError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

   Future<void> _handleSubmit() async {
    final confirmResult = ValidationUtil.validateConfirmPassword(
      _newPasswordController.text,
      _confirmPasswordController.text,
    );

    setState(() {
      _confirmError = confirmResult;
    });

    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid || confirmResult != null) return;

    final res = await _profileController.updatePassword(
      currentPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return; // 👈 guard right after the async gap

    if (res["status"] == "SUCCESS") {
      _showSnackbarSafely(
        success: true,
        message: res["message"] ?? "Password changed successfully.",
      );

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) Get.back();
      });
    } else {
      _showSnackbarSafely(
        success: false,
        message: res["message"] ?? "Unable to change password.",
      );
    }
  }

  /// 🔐 Safely shows a snackbar — passes explicit widget context so
  /// Overlay.of() finds a valid ancestor (Get.context alone fails here
  /// because it points to the Navigator's own context, which sits
  /// ABOVE the Overlay, not below it).
  void _showSnackbarSafely({required bool success, required String message}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (success) {
        AppSnackBar.success(context: context, message: message);
      } else {
        AppSnackBar.error(context: context, message: message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Change Password"),
      body: SafeArea(
        child: Obx(
          () => AbsorbPointer(
            absorbing: _profileController.isChangingPassword.value,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Update your password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Enter your current password and choose a new one.",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.bodytextColor.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Current Password
                    CustomTextField(
                      label: "Current Password",
                      hintText: "Enter current password",
                      controller: _currentPasswordController,
                      isPassword: true,
                      obscureText: _obscureCurrent,
                      onToggleVisibility: () {
                        setState(() => _obscureCurrent = !_obscureCurrent);
                      },
                      isRequired: true,
                      validator: (value) =>
                          ValidationUtil.validatePassword(value ?? ""),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 New Password
                    CustomTextField(
                      label: "New Password",
                      hintText: "Enter new password",
                      controller: _newPasswordController,
                      isPassword: true,
                      obscureText: _obscureNew,
                      onToggleVisibility: () {
                        setState(() => _obscureNew = !_obscureNew);
                      },
                      isRequired: true,
                      validator: (value) =>
                          ValidationUtil.validatePasswordonly(value ?? ""),
                      onChanged: (value) {
                        // live-clear confirm error if user edits new password
                        if (_confirmError != null) {
                          setState(() => _confirmError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Confirm Password
                    CustomTextField(
                      label: "Confirm New Password",
                      hintText: "Re-enter new password",
                      controller: _confirmPasswordController,
                      isPassword: true,
                      obscureText: _obscureConfirm,
                      onToggleVisibility: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                      isRequired: true,
                      errorText: _confirmError,
                      validator: (value) =>
                          ValidationUtil.validateConfirmPassword(
                            _newPasswordController.text,
                            value ?? "",
                          ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _profileController.isChangingPassword.value
                            ? null
                            : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _profileController.isChangingPassword.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Update Password"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
