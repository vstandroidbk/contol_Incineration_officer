import 'package:contol_officer_app/ReusableWidgets/authHeader.dart';
import 'package:contol_officer_app/ReusableWidgets/textField.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  String? _emailError;
  String? _passwordError;
  void _validateAndLogin() {
    // final email = emailController.text.trim();
    // final password = passwordController.text.trim();

    // final emailError = ValidationUtil.validateEmail(email);
    // final passwordError = ValidationUtil.validatePassword(password);

    // setState(() {
    //   _emailError = emailError;
    //   _passwordError = passwordError;
    // });

    // if (emailError == null && passwordError == null) {
    //   // ✅ All validations passed
    //   if (!mounted) return; // extra safety

    //   //Show snack bar first
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Login successful!")),
    //   );

    // Navigate after a short delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return; // check if widget still exists
    Get.offAllNamed(AppRoutes.dashboard);

    });
    // }
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

                  /// ✅ Email TextField with validator
                  CustomTextField(
                    label: "Email",
                    hintText: "Enter email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                  ),
                  const SizedBox(height: 10),

                  /// ✅ Password TextField with validator
                  CustomTextField(
                    label: "Password",
                    hintText: "Enter password",
                    controller: passwordController,
                    isPassword: true,
                    obscureText: _obscureText,
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

                  /// ✅ Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _validateAndLogin,
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Info Cards
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
