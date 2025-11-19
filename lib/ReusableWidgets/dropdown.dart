import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

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
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,  
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.lighttextColor,
            ),
          ),

        if (label.isNotEmpty) const SizedBox(height: 3),

        IntrinsicWidth(               
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 6,
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.textfieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : AppColors.textfieldBorder,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: hasError ? Colors.red :AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorText: errorText,
            ),
            icon: const Icon(Icons.keyboard_arrow_down, size: 18,color: AppColors.bodytextColor,),
            style: const TextStyle(fontSize: 13),
            isDense: true,
            isExpanded: false,           
            onChanged: onChanged,
            hint: Text(
              hintText,
              style: TextStyle(
                color: AppColors.bodytextColor.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bodytextColor
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

/// New CustomDropdownField2 matching CustomTextField design

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
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? Colors.red : AppColors.textfieldBorder,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.bodytextColor,
              ),
              iconSize: 24,
              hint: Text(
                hintText,
                style: TextStyle(
                  color: AppColors.bodytextColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
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
              onChanged: enabled ? onChanged : null,
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