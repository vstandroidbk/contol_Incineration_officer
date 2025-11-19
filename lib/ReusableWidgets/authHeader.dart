import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.35;

    return ClipPath(
      clipper: TripleWaveClipper(),
      child: Stack(
        children: [
          // Background image container
          Container(
            height: headerHeight,

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg-img.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay
          Container(
            height: headerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradient1.withOpacity(0.9),
                  AppColors.gradient2.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- RESPONSIVE CLIPPER --- //
class TripleWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Slightly deeper wave values
    final double baseDip = size.height * 0.12;   // was 0.10
    final double shallowDip = size.height * 0.045; // was 0.025
    final double deepDip = size.height * 0.22;   // was 0.175

    path.lineTo(0, size.height - baseDip);

    // First wave (gentle curve)
    path.quadraticBezierTo(
      size.width * 0.17,
      size.height - shallowDip,
      size.width * 0.34,
      size.height - baseDip,
    );

    // Second wave (center, more visible dip)
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height - deepDip,
      size.width * 0.66,
      size.height - baseDip,
    );

    // Third wave (gentle again)
    path.quadraticBezierTo(
      size.width * 0.83,
      size.height - shallowDip,
      size.width,
      size.height - baseDip,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

