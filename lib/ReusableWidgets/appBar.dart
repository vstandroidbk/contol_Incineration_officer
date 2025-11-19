import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;

  final String? title;
  final String? subtitle;

  final Widget? rightWidget;

  final bool showBack;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    this.backgroundColor = AppColors.primary,
    this.title,
    this.subtitle,
    this.rightWidget,
    this.showBack = false,
    this.onBackTap,
  });

  bool get _hasTitle => title != null && title!.trim().isNotEmpty;
  bool get _hasSubtitle => subtitle != null && subtitle!.trim().isNotEmpty;

  /// HEIGHT LOGIC
  @override
  Size get preferredSize {
    if (!_hasTitle && !_hasSubtitle) {
      return const Size.fromHeight(40); // ONLY top colored bar
    } else if (_hasTitle && !_hasSubtitle) {
      return const Size.fromHeight(90); // title only
    } else {
      return const Size.fromHeight(120); // title + subtitle
    }
  }

  @override
  Widget build(BuildContext context) {
    // CASE 1 → No title + no subtitle
    if (!_hasTitle && !_hasSubtitle) {
      return Container(
        height: 40,
        width: double.infinity,
        color: backgroundColor,
      );
    }

    // CASE 2 & 3 → Title present (optional subtitle)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TOP COLOR STRIP
        Container(height: 40, width: double.infinity, color: backgroundColor),

        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              // LEFT SECTION
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showBack) ...[
                      GestureDetector(
                        onTap: onBackTap ?? () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: AppColors.bodytextColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // TITLE AND OPTIONAL SUBTITLE
                    Expanded(
                      child: _hasSubtitle
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.bodytextColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.bodytextColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              title!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bodytextColor,
                              ),
                            ),
                    ),
                  ],
                ),
              ),

              // RIGHT SIDE WIDGET
              rightWidget ?? const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
