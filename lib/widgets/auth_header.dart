import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.36;

    return ClipPath(
      clipper: TripleWaveClipper(),
      child: Stack(
        children: [
          // 1. Background image
          Container(
            height: headerHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login-bg.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // // // 2. Gradient overlay
          Container(
            height: headerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradient1.withOpacity(0.1),
                  AppColors.gradient2.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 3. Content
          SizedBox(
            height: headerHeight,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 0.2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo/recycle-logo.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.fitWidth,
                    ),
                  ),

                  // Company Name
                  const Text(
                    "Continental Petroleums Ltd",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: AppColors.gradient1,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                        Shadow(
                          color: AppColors.gradient2,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4),

                  // Tagline
                  Text(
                    "Application for Waste Management",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: AppColors.gradient1,
                          blurRadius: 4,
                          offset: Offset(2, 4),
                        ),
                        Shadow(
                          color: AppColors.gradient2,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
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

// --- RESPONSIVE CLIPPER --- //
class TripleWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double baseDip = size.height * 0.12;
    final double shallowDip = size.height * 0.045;
    final double deepDip = size.height * 0.22;

    path.lineTo(0, size.height - baseDip);

    path.quadraticBezierTo(
      size.width * 0.17,
      size.height - shallowDip,
      size.width * 0.34,
      size.height - baseDip,
    );

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height - deepDip,
      size.width * 0.66,
      size.height - baseDip,
    );

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
