import 'package:contol_officer_app/API%20Service/networkHelper.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _subtitleController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _startApp();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _titleSlide =
        Tween<Offset>(begin: const Offset(-0.8, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
        );
    _titleFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeIn));

    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0.0, 1.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _subtitleController,
            curve: Curves.easeOutCubic,
          ),
        );
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeIn),
    );
  }

  void _startAnimations() async {
    _logoController.forward();

    // ✅ Check internet right away, parallel to logo animation
    final hasInternet = await NetworkHelper.hasInternet();
    if (!hasInternet && mounted) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _showNoInternetSnackbar();
    }

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) _titleController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) _subtitleController.forward();
  }

  // ✅ Wait for splash to finish, then decide where to go
  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    try {
      final userId = await AppSession.getUserId();
      debugPrint("🔍 [Splash] userId → $userId");

      if (userId != null && userId.isNotEmpty) {
        // ✅ User is logged in → go to dashboard
        debugPrint("✅ [Splash] Logged in → navigating to dashboard");
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        // ❌ No user found → go to login
        debugPrint("❌ [Splash] No user → navigating to login");
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      debugPrint("CRITICAL [Splash] Error: $e");
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void _showNoInternetSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.error.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Internet Connection",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Please check your connection to use the latest features.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    'assets/logo/contol-logo.png',
                    height: 130,
                    width: 130,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleFade,
                  child: const Text(
                    "Incineration Officer Contol",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.container4,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SlideTransition(
                position: _subtitleSlide,
                child: FadeTransition(
                  opacity: _subtitleFade,
                  child: const Text(
                    "Lubricants-Accelerating Performance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
