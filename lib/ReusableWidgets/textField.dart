import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final Color hintColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final String? errorText;
  final bool enabled;
  final bool readOnly;  // NEW
  final VoidCallback? onTap;  // NEW

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.hintColor = AppColors.bodytextColor,
    this.borderColor = AppColors.textfieldBorder,
    this.focusedBorderColor = const Color(0xFF4A90E2),
    this.errorText,
    this.enabled = true,
    this.readOnly = false,  // NEW - default false
    this.onTap,  // NEW
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;
    final bool isMultiline = keyboardType == TextInputType.multiline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),

        Container(
          height: MediaQuery.of(context).size.height*0.047,
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? Colors.red : borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword ? obscureText : false,
            enabled: enabled,
            readOnly: readOnly,  // NEW - use the parameter
            onTap: onTap,  // NEW - use the parameter

            /// BIGGER TEXT AREA FOR MULTILINE
            minLines: isMultiline ? 2 : 1,
            maxLines: isMultiline ? 4 : 1,

            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: hintColor.withOpacity(0.6),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.lighttextColor,
                ),
                onPressed: onToggleVisibility,
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13
              ),
            ),
          ),
        ),

        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}