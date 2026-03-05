import 'package:contol_officer_app/API%20Service/networkHelper.dart';
import 'package:contol_officer_app/Controller/Auth/authController.dart';
import 'package:contol_officer_app/Controller/Nav/navbar_controller.dart';
import 'package:contol_officer_app/utils/snackbar.dart';
import 'package:contol_officer_app/utils/validation.dart';
import 'package:contol_officer_app/widgets/auth_header.dart';
import 'package:contol_officer_app/widgets/text_field.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController _authController = Get.find();

  bool _obscureText = true;
  String? _usernameError;
  String? _passwordError;

  void _validateAndLogin() async {
    FocusScope.of(context).unfocus();

    final usernameError = ValidationUtil.validateRequired(
      usernameController.text.trim(),
      fieldName: "Username",
    );

    final passwordError = ValidationUtil.validatePassword(
      passwordController.text.trim(),
    );

    setState(() {
      _usernameError = usernameError;
      _passwordError = passwordError;
    });

    // ⛔ Validation failed → SHOW SNACKBAR + STOP
    if (usernameError != null || passwordError != null) {
      AppSnackBar.error(
        context: context,
        message: usernameError ?? passwordError!,
      );
      return;
    }

    // ✅ Check internet BEFORE calling API — single snackbar, no duplication
    final hasInternet = await NetworkHelper.hasInternet();
    if (!hasInternet) {
      if (!mounted) return;
      AppSnackBar.error(context: context, message: "No internet connection.");
      return;
    }

    /// 🚀 Call Login API
    final res = await _authController.login(
      userLoginDetail: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    // 3️⃣ Backend failure → snackbar
    if (res["status"] != "SUCCESS") {
      AppSnackBar.error(
        context: context,
        message: res["message"] ?? "Invalid email or password",
      );
      return;
    }

    // 4️⃣ Success
    AppSnackBar.success(
      context: context,
      message: res["message"] ?? "Login successful",
    );

    /// ✅ Login success → navigate
    Get.find<BottomNavBarController>().changeTab(0);
    Get.offAllNamed(AppRoutes.dashboard);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Officer Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          "Access your regional management portal",
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

                  CustomTextField(
                    label: "Username",
                    hintText: "Enter username",
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    isRequired: true,
                    errorText: _usernameError,
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    label: "Password",
                    hintText: "Enter password",
                    controller: passwordController,
                    isPassword: true,
                    obscureText: _obscureText,
                    isRequired: true,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    errorText: _passwordError,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.forgotPassword);
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),

                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _authController.isLoading.value
                            ? null
                            : _validateAndLogin,
                        child: _authController.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  _buildInfoCard(
                    color: AppColors.primary.withOpacity(0.9),
                    icon: Icons.shield_outlined,
                    title: "Secure Access",
                    message: "Your credentials are encrypted and protected.",
                    textColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    color: AppColors.secondary.withOpacity(0.9),
                    icon: LucideIcons.badgeInfo,
                    title: "Need Help?",
                    message: "Contact admin support for login assistance.",
                    textColor: Colors.black,
                    iconColor: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required Color color,
    IconData? icon,
    String? assetIcon,
    required String title,
    required String message,
    required Color textColor,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: iconColor, size: 35)
          else if (assetIcon != null)
            Image.asset(assetIcon, height: 35, width: 35, color: iconColor),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                Text(message, style: TextStyle(fontSize: 14, color: textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
