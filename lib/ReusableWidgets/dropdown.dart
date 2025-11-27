import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:contol_officer_app/utils/colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final String hintText;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.errorText,
    this.hintText = 'Select',
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.lighttextColor),
          ),
        if (label.isNotEmpty) const SizedBox(height: 4),

        DropdownButtonFormField2<String>(
          value: value,
          isExpanded: true,

          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.textfieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.textfieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.primary,
                width: 1.4,
              ),
            ),
            errorText: errorText,
          ),

          hint: Text(
            hintText,
            style: TextStyle(
              color: AppColors.bodytextColor.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          iconStyleData: IconStyleData(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.bodytextColor,
            ),
          ),

          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(left: 0, right: 10),
          ),

          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            elevation: 2,
          ),

          menuItemStyleData: const MenuItemStyleData(
            height: 42,
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),

          onChanged: onChanged,

          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.bodytextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

/// New CustomDropdownField2
class CustomDropdownField2 extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final String hintText;
  final bool enabled;

  const CustomDropdownField2({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.errorText,
    this.hintText = 'Select',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        if (label.isNotEmpty) const SizedBox(height: 6),

        DropdownButtonFormField2<String>(
          value: value,
          isExpanded: true,
          onChanged: enabled ? onChanged : null,

          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textfieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.textfieldBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.primary,
                width: 1.4,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.textfieldBorder.withOpacity(0.5),
              ),
            ),
          ),

          hint: Text(
            hintText,
            style: TextStyle(
              color: AppColors.bodytextColor.withOpacity(0.55),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.bodytextColor,
            ),
          ),

          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(),
          ),

          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),

          menuItemStyleData: const MenuItemStyleData(
            height: 42,
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),

          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodytextColor,
                    ),
                  ),
                ),
              )
              .toList(),
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
