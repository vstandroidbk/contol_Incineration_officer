import 'package:contol_officer_app/ReusableWidgets/authHeader.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());
  bool hasError = false;

  void _validateOTP() {
    String otp = otpControllers.map((c) => c.text.trim()).join();
    if (otp.length < 4) {
      setState(() {
        hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the full 4-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        hasError = false;
      });
      Get.toNamed(AppRoutes.createNewPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                    "Verification Email",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "To continue, please enter the OTP we've sent to your email ID.",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lighttextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "customer@gmail.com",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // OTP boxes with validation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        width: width * 0.15,
                        height: 55,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: otpControllers[index].text.isNotEmpty
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.8),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TextField(
                          controller: otpControllers[index],
                          focusNode: otpFocusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            setState(() {}); // refresh background color
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(
                                context,
                              ).requestFocus(otpFocusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(
                                context,
                              ).requestFocus(otpFocusNodes[index - 1]);
                            }
                          },
                        ),
                      );
                    }),
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
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Back"),
                        ),
                      ),
                      const SizedBox(width: 10),
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
                          onPressed: _validateOTP,
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
