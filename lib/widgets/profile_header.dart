import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class Profileheader extends StatelessWidget {
  final String? profileImageUrl; // 👈 add this

  const Profileheader({super.key, this.profileImageUrl}); // 👈 add this

  static const Color gradient1 = Color(0xFF0C8848);
  static const Color gradient2 = Color(0xFF333F8E);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double headerHeight = screenHeight * 0.20;

    return SizedBox(
      height: headerHeight + 60,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Container(
                  width: double.infinity,
                  height: headerHeight,
                  color: AppColors.gradient1.withOpacity(0.88),
                ),

                Positioned(
                  left: -40,
                  top: headerHeight * 0.4,
                  child: _circle(size: screenWidth * 0.7, opacity: 0.7),
                ),

                Positioned(
                  left: 30,
                  top: headerHeight * 0.1,
                  child: _circle(size: screenWidth * 0.4, opacity: 0.56),
                ),

                Positioned(
                  right: 10,
                  top: headerHeight * -0.2,
                  child: _circle(size: screenWidth * 0.7, opacity: 0.5),
                ),

                Positioned(
                  right: 40,
                  top: headerHeight * -0.1,
                  child: _circle(size: screenWidth * 0.6, opacity: 0.60),
                ),

                Positioned(
                  right: 80,
                  top: headerHeight * -0.01,
                  child: _circle(size: screenWidth * 0.55, opacity: 0.38),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(AppRoutes.editProfile);
                    },
                    icon: const Icon(
                      LucideIcons.edit,
                      size: 18,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Edit",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: Colors.black.withOpacity(0.15),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(0, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // PROFILE IMAGE (CENTER BOTTOM — OUTSIDE HEADER)
          Positioned(
            bottom: 25,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50,
                 backgroundImage:
                    (profileImageUrl != null && profileImageUrl!.isNotEmpty)
                    ? NetworkImage(profileImageUrl!)
                    : null, // 👈 changed — no more asset fallback
                child: (profileImageUrl == null || profileImageUrl!.isEmpty)
                    ? Icon(
                        LucideIcons.user, 
                        size: 30,
                        
                      )
                    : null,
            
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle({required double size, required double opacity}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            gradient1.withOpacity(opacity),
            gradient2.withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}