import 'package:contol_officer_app/ReusableWidgets/authHeader.dart';
import 'package:contol_officer_app/ReusableWidgets/textField.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;
  String? newPasswordError;
  String? confirmPasswordError;

  void _validateAndSubmit() {
    setState(() {
      newPasswordError = ValidationUtil.validatePassword(
        newPasswordController.text,
      );
      confirmPasswordError = ValidationUtil.validateConfirmPassword(
        newPasswordController.text,
        confirmPasswordController.text,
      );
    });

    if (newPasswordError == null && confirmPasswordError == null) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: AuthHeader()),
          Positioned.fill(
            top: height * 0.33,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create new Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      "To reset your password, please enter the New Password.",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lighttextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),

                  CustomTextField(
                    label: "New Password",
                    hintText: "Enter password",
                    controller: newPasswordController,
                    isPassword: true,
                    obscureText: _obscureText,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    errorText: newPasswordError, // show error
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Confirm Password",
                    hintText: "Re-enter password",
                    controller: confirmPasswordController,
                    isPassword: true,
                    obscureText: _obscureText,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    errorText: confirmPasswordError, // show error
                  ),

                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.textfieldBorder,
                            ),
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: const Text("Back"),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _validateAndSubmit, // 👈 validation call
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
