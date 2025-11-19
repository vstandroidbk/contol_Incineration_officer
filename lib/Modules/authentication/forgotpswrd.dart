import 'package:contol_officer_app/ReusableWidgets/authHeader.dart';
import 'package:contol_officer_app/ReusableWidgets/textField.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/validation.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String? emailError; // <-- store validation error text

  void _validateAndProceed() {
    final email = emailController.text.trim();
    final error = ValidationUtil.validateEmail(email);

    setState(() {
      emailError = error; // set error text
    });

    if (error == null) {
      // ✅ Valid email, proceed
      Navigator.pushNamed(context, AppRoutes.emailVerification);
    } else {
      // ❌ Invalid, show snackbar too for feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
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
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          "Forgot your account password",
                          style: TextStyle(
                            fontSize: 16,
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
                          onPressed: () => Navigator.pop(context),
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
                          onPressed: _validateAndProceed,
                          child: const Text("Next"),
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
