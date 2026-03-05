import 'package:contol_officer_app/Controller/Auth/authController.dart';
import 'package:contol_officer_app/utils/snackbar.dart';
import 'package:contol_officer_app/widgets/auth_header.dart';
import 'package:contol_officer_app/widgets/text_field.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final formKey = GlobalKey<FormState>();

  bool showNew = false;
  bool showConfirm = false;
  String? newPasswordError;
  String? confirmPasswordError;

  //api controller
  final AuthController _authController = Get.find<AuthController>();
 late final String userLoginDetail;

@override
void initState() {
  super.initState();
  userLoginDetail = Get.arguments?["userLoginDetail"] ?? "";
}

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() async {
    if (!formKey.currentState!.validate()) return;

    final res = await _authController.resetPassword(
      userloginDetail: userLoginDetail,
      password: newPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (res["status"] == "SUCCESS") {
      AppSnackBar.success(context: context, message: res["message"]);

      // 🔥 Go back to login & clear stack
      Get.offAllNamed(AppRoutes.login);
    } else {
      AppSnackBar.error(
        context: context,
        message: res["message"] ?? "Password reset failed",
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
          const Positioned(top: 0, left: 0, right: 0, child: AuthHeader()),
          Positioned.fill(
            top: height * 0.33,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
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
                      obscureText: !showNew,
                      onToggleVisibility: () =>
                          setState(() => showNew = !showNew),
                      validator: (v) => ValidationUtil.validatePasswordonly(
                        v ?? '',
                        
                      ),
                      errorText: newPasswordError, // 👈 show error
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Confirm Password",
                      hintText: "Re-enter password",
                      controller: confirmPasswordController,
                      isPassword: true,
                      obscureText: !showConfirm,
                      onToggleVisibility: () =>
                          setState(() => showConfirm = !showConfirm),
                      validator: (v) => ValidationUtil.validateConfirmPassword(
                        newPasswordController.text,
                        v ?? '',
                      ),
                      errorText: confirmPasswordError, // 👈 show error
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
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 2,
                              ),
                              onPressed: _authController.isLoading.value
                                  ? null
                                  : _validateAndSubmit,
                              child: _authController.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text("Save"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
