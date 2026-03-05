import 'package:contol_officer_app/Controller/Auth/authController.dart';
import 'package:contol_officer_app/utils/snackbar.dart';
import 'package:contol_officer_app/widgets/auth_header.dart';
import 'package:contol_officer_app/widgets/text_field.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String? emailError; // <-- store validation error text

  //coontroller
  final AuthController _authController = Get.put(AuthController());

  void _validateAndProceed() async {
    final email = emailController.text.trim();
    final error = ValidationUtil.validateEmail(email);

    setState(() {
      emailError = error;
    });

    if (error != null) {
      AppSnackBar.error(context: context, message: error);
      return;
    }

    final res = await _authController.forgotPswrd(email);

    if (!mounted) return;

    if (res["status"] == "SUCCESS") {
      AppSnackBar.success(context: context, message: res["message"]);

      Get.toNamed(AppRoutes.emailVerification, arguments: {"email": email});
    } else {
      AppSnackBar.error(
        context: context,
        message: res["message"] ?? "Failed to send OTP",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Header
          const Positioned(top: 0, left: 0, right: 0, child: AuthHeader()),

          // Scrollable form area
          Positioned.fill(
            top: height * 0.33,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Forgot",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          "Forgot your account password",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.lighttextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Text Field with validator
                  CustomTextField(
                    label: "Email",
                    hintText: "Enter email",
                    isRequired: true,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText:
                        emailError, // <-- dynamically show validation error
                  ),

                  const SizedBox(height: 25),

                  // Buttons
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
                        child: Obx(
                          () => ElevatedButton(
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
                            onPressed: _authController.isLoading.value
                                ? null
                                : _validateAndProceed,
                            child: _authController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Next"),
                          ),
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
