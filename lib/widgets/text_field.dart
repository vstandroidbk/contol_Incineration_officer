import 'package:contol_officer_app/utils/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final Color hintColor;
  final Color borderColor;
  final String? errorText;
  final bool enabled;
  final String? fixedSuffix;
  final bool isRequired;

  // NEW FIELDS FOR DROPDOWN
  final List<String>? unitList;
  final String? selectedUnit;
  final ValueChanged<String>? onUnitChanged;

  final List<TextInputFormatter>? inputFormatters;

  // NEW UPLOAD ICON FIELD
  final bool showUploadIcon;
  final bool showCalendarIcon;
  final VoidCallback? onUploadTap;
  final ValueChanged<String>? onChanged;

  final String? Function(String?)? validator;

  //same value copy-paste checkbox
  final bool showCheckbox;
  final bool checkboxValue;
  final ValueChanged<bool?>? onCheckboxChanged;
  final String? checkboxLabel;

  final TextCapitalization textCapitalization;

  final List<String>? prefixList; // NEW
  final String? selectedPrefix;
  final ValueChanged<String>? onPrefixChanged; // NEW

  final Widget? suffixIcon; // ✅ NEW

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
    this.errorText,
    this.enabled = true,

    this.validator,

    this.onChanged,
    // dropdown params
    this.unitList,
    this.selectedUnit,
    this.onUnitChanged,

    // upload params
    this.showUploadIcon = false,
    this.onUploadTap,
    this.showCalendarIcon = false,
    this.fixedSuffix,

    this.inputFormatters,

    // ✅ checkbox (NEW)
    this.showCheckbox = false,
    this.checkboxValue = false,
    this.onCheckboxChanged,
    this.checkboxLabel,

    this.isRequired = false,

    this.textCapitalization = TextCapitalization.none,
    this.prefixList,
    this.selectedPrefix,
    this.onPrefixChanged,

    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // ✅ Local error — drives border color & message independently of Flutter Form
  String? _localError;

  // ✅ Guards against parent pushing errorText back in after user already typed
  bool _userHasTyped = false;

  @override
  void initState() {
    super.initState();
    _localError = widget.errorText;

    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    final value = widget.controller.text;

    if (mounted) {
      setState(() {
        _localError = null;
        _userHasTyped = true;
      });
    }
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ Only accept incoming errorText if user hasn't already typed
    if (oldWidget.errorText != widget.errorText) {
      setState(() {
        _localError = _userHasTyped ? null : widget.errorText;
      });
    }
  }

  // 🔁 Validator wrapper (same as dropdown)
  String? _wrappedValidator(String? value) {
    if (widget.validator == null) return null;

    final result = widget.validator!(value);
    if (result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _localError = result;
            _userHasTyped = false; // re-arm so next typing can clear again
          });
        }
      });
    }
    return result;
  }

  // ✅ User typed — clear ALL error indicators immediately (same logic as dropdown selection)
  void _handleChange(String value) {
    setState(() {
      _localError = null;
      _userHasTyped = true;
    });

    widget.onChanged?.call(value);
  }

  // ✅ Handle unit dropdown change
  void _handleUnitChange(String? value) {
    if (value == null) return;

    setState(() {
      _localError = null;
      _userHasTyped = true;
    });

    widget.onUnitChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _localError != null && _localError!.isNotEmpty;
    final bool isMultiline = widget.keyboardType == TextInputType.multiline;

    Widget? suffix =
        widget.suffixIcon; // 👈 give priority to external suffixIcon

    // --- SUFFIX LOGIC ---
    if (suffix == null) {
      if (widget.unitList != null && widget.unitList!.isNotEmpty) {
        suffix = DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: widget.selectedUnit,
            onChanged: _handleUnitChange,
            items: widget.unitList!
                .map(
                  (unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(
                      unit,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      } else if (widget.isPassword) {
        suffix = IconButton(
          icon: Icon(
            widget.obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.lighttextColor,
          ),
          onPressed: widget.onToggleVisibility,
        );
      } else if (widget.showUploadIcon) {
        suffix = IconButton(
          icon: const Icon(Icons.upload_file, color: AppColors.primary),
          onPressed: widget.onUploadTap,
        );
      } else if (widget.showCalendarIcon) {
        suffix = IconButton(
          icon: const Icon(Icons.calendar_month, color: AppColors.primary),
          onPressed: widget.onUploadTap,
        );
      } else if (widget.fixedSuffix != null && widget.fixedSuffix!.isNotEmpty) {
        suffix = SizedBox(
          width: 40,
          child: Center(
            child: Text(
              widget.fixedSuffix!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }
    }

    // NEW PREFIX LOGIC
    Widget? prefix;
    if (widget.prefixList != null && widget.prefixList!.isNotEmpty) {
      prefix = Container(
        margin: const EdgeInsets.only(right: 8, left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: widget.borderColor.withOpacity(0.5)),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: widget.selectedPrefix,
            onChanged: (value) {
              if (value != null) widget.onPrefixChanged?.call(value);
            },
            items: widget.prefixList!
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                .toList(),
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.zero,
              width: 80, // Adjust width based on your MR, MS, MRS needs
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            ),
            iconStyleData: IconStyleData(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: AppColors.bodytextColor,
              ),
            ),
          ),
        ),
      );
    }

    // 🎨 DISABLED STATE STYLING
    final Color effectiveBorderColor = !widget.enabled
        ? widget.borderColor.withOpacity(0.3)
        : widget.borderColor;

    final Color effectiveBackgroundColor = !widget.enabled
        ? Colors.grey.shade100
        : Colors.transparent;

    final Color effectiveTextColor = !widget.enabled
        ? AppColors.bodytextColor.withOpacity(0.7)
        : AppColors.bodytextColor;

    final Color effectiveHintColor = !widget.enabled
        ? widget.hintColor.withOpacity(0.3)
        : widget.hintColor.withOpacity(0.5);

    return FormField<String>(
      validator: _wrappedValidator,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: widget.controller.text,
      builder: (fieldState) {
        // 🔥 IMPORTANT: Sync controller → FormField
        if (fieldState.value != widget.controller.text) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (fieldState.mounted) {
              fieldState.didChange(widget.controller.text);
            }
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: widget.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      // 🎨 Label opacity when disabled
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                    children: [
                      if (widget.isRequired)
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),

                if (widget.showCheckbox) ...[
                  const Spacer(),
                  Checkbox(
                    value: widget.checkboxValue,
                    onChanged: widget.onCheckboxChanged,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  if (widget.checkboxLabel != null)
                    Text(
                      (widget.checkboxLabel!),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.bodytextColor.withOpacity(0.6),
                      ),
                    ),
                ],
              ],
            ),

            const SizedBox(height: 4),

            Container(
              decoration: BoxDecoration(
                // 🎨 Background color changes when disabled
                color: effectiveBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  // ✅ Border color now controlled by _localError
                  color: hasError ? AppColors.error : effectiveBorderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                textCapitalization: widget.textCapitalization,
                obscureText: widget.isPassword ? widget.obscureText : false,
                enabled: widget.enabled,
                readOnly: !widget.enabled,
                minLines: isMultiline ? 2 : 1,
                maxLines: isMultiline ? 4 : 1,
                inputFormatters: widget.inputFormatters,
                onChanged: (value) {
                  fieldState.didChange(value);
                  _handleChange(value);
                },

                style: TextStyle(
                  // 🎨 Text color when disabled vs enabled
                  color: effectiveTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon: prefix,
                  hintStyle: TextStyle(
                    // 🎨 Hint color distinctly lighter when disabled
                    color: effectiveHintColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  suffixIcon: suffix,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  // 🎨 Disabled hint text style
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),

            // ✅ Custom error rendering — fully controlled by _localError
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _localError ?? '',
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
