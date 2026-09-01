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
  late AnimationController _wasteController;
  late AnimationController _sustainController;
  late AnimationController _globeController;

  late Animation<Offset> _logoSlide;
  late Animation<double> _logoFade;
  late Animation<Offset> _wasteSlide;
  late Animation<double> _wasteFade;
  late Animation<Offset> _sustainSlide;
  late Animation<double> _sustainFade;
  late Animation<double> _globeScale;
  late Animation<double> _globeFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _startApp();
  }

  // ─────────────────────────────────────────
  // ANIMATIONS (design copied from customer app)
   void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, -2.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutExpo),
        );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _wasteController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _wasteSlide =
        Tween<Offset>(begin: const Offset(-1.4, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _wasteController, curve: Curves.easeOutCubic),
        );
    _wasteFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _wasteController, curve: Curves.easeIn));

    _sustainController = AnimationController(
      duration: const Duration(milliseconds: 4500),
      vsync: this,
    );
    _sustainSlide =
        Tween<Offset>(begin: const Offset(1.4, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _sustainController,
            curve: Curves.easeOutCubic,
          ),
        );
    _sustainFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sustainController, curve: Curves.easeIn),
    );

    _globeController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );
    _globeScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _globeController, curve: Curves.easeOutBack),
    );
    _globeFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _globeController, curve: Curves.easeIn));
  }

  void _startAnimations() async {
    NetworkHelper.hasInternet().then((hasInternet) {
      if (!hasInternet && mounted) {
        _showNoInternetSnackbar();
      }
    });
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _wasteController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _sustainController.forward();
    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted) _globeController.forward();
  }

  void _showNoInternetSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.withOpacity(0.6),
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
    _wasteController.dispose();
    _sustainController.dispose();
    _globeController.dispose();
    super.dispose();
  }

 
  // ─────────────────────────────────────────
  // NAVIGATION LOGIC (unchanged from officer app)
  // ─────────────────────────────────────────
  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 5));

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

 

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final double sw = screen.width;
    final double sh = screen.height;
    final bool isLandscape = sw > sh;

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/contol15.png', fit: BoxFit.fill),

          SafeArea(
            child: isLandscape
                ? _buildLandscapeLayout(sw, sh)
                : _buildPortraitLayout(sw, sh),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // PORTRAIT layout (original design)
  // ─────────────────────────────────────────
  Widget _buildPortraitLayout(double sw, double sh) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLogo(sw, sh, isLandscape: false),
                  SizedBox(height: sh * 0.02),
                  _buildWasteManagementTitle(sw, sh, isLandscape: false),
                  SizedBox(height: sh * 0.004),
                  _buildSustainBadge(sw, sh, isLandscape: false),
                ],
              ),
              _buildRecycleGlobe(sw, sh, isLandscape: false),
            ],
          ),
        ),

        _buildBottomPanel(sw, sh, isLandscape: false),
      ],
    );
  }

  // ─────────────────────────────────────────
  // LANDSCAPE layout — side by side, scrollable
  // ─────────────────────────────────────────
  Widget _buildLandscapeLayout(double sw, double sh) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: sh),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LEFT: logo + title + badge
            Expanded(
              flex: 55,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.02,
                  vertical: sh * 0.04,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(sw, sh, isLandscape: true),
                    SizedBox(height: sh * 0.02),
                    _buildWasteManagementTitle(sw, sh, isLandscape: true),
                    SizedBox(height: sh * 0.015),
                    _buildSustainBadge(sw, sh, isLandscape: true),
                  ],
                ),
              ),
            ),
            // RIGHT: globe
            Expanded(
              flex: 45,
              child: Center(
                child: _buildRecycleGlobe(sw, sh, isLandscape: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // LOGO
  // ─────────────────────────────────────────
  Widget _buildLogo(double sw, double sh, {required bool isLandscape}) {
    // In landscape sw > sh, so we use sh-based sizing for fonts to keep them small
    final double logoH = isLandscape ? sh * 0.18 : sh * 0.105;
    final double fontC = isLandscape ? sh * 0.20 : sw * 0.165;
    final double fontSub = isLandscape ? sh * 0.09 : sw * 0.08;
    final double gap = isLandscape ? sw * 0.02 : sw * 0.038;
    final double lineW = isLandscape ? sw * 0.44 : sw * 0.84;

    const List<Shadow> heavyShadow = [
      Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 8, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 16, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 28, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 40, offset: Offset(0, 0)),
    ];

    return SlideTransition(
      position: _logoSlide,
      child: FadeTransition(
        opacity: _logoFade,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/contol-logo.png',
                  height: logoH,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: gap),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..scale(1.0, 1.3)
                    ..setEntry(0, 1, -0.25), // italic tilt to right
                  child: Text(
                    "Contol",
                    style: TextStyle(
                      fontFamily: 'MontserratItalic',
                      color: const Color(0xFF001A72),
                      fontSize: fontC,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1,
                      height: 0.95,
                      shadows: heavyShadow,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "CONTINENTAL PETROLEUMS LTD.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                color: const Color(0xFF001A72),
                fontSize: fontSub,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                height: 0.95,
                shadows: heavyShadow,
              ),
            ),
            SizedBox(height: sh * 0.006),
            Container(height: 2, width: lineW, color: const Color(0xFF001A72)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // WASTE MANAGEMENT TITLE
  // ─────────────────────────────────────────
  Widget _buildWasteManagementTitle(
    double sw,
    double sh, {
    required bool isLandscape,
  }) {
    final double fontW = isLandscape ? sh * 0.22 : sw * 0.181;
    final double fontM = isLandscape ? sh * 0.19 : sw * 0.16;

    const List<Shadow> heavyShadow = [
      Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 8, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 16, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 28, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 40, offset: Offset(0, 0)),
    ];

    return SlideTransition(
      position: _wasteSlide,
      child: FadeTransition(
        opacity: _wasteFade,
        child: Column(
          children: [
            Transform.scale(
              scaleX: 1.2,
              child: Text(
                "WASTE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  color: const Color(0xFF002800),
                  fontSize: fontW,
                  fontWeight: FontWeight.w700,
                  height: 0.82,
                  letterSpacing: 1.2,
                  shadows: heavyShadow,
                ),
              ),
            ),
            SizedBox(height: sh * 0.003),
            Transform.scale(
              scaleX: 1.2,
              child: Text(
                "MANAGEMENT",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  color: const Color(0xFF002800),
                  fontSize: fontM,
                  fontWeight: FontWeight.w700,
                  height: 0.82,
                  letterSpacing: 1.2,
                  shadows: heavyShadow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // SUSTAIN BADGE
  // ─────────────────────────────────────────
  Widget _buildSustainBadge(double sw, double sh, {required bool isLandscape}) {
    final double fontSize = isLandscape ? sh * 0.07 : sw * 0.048;
    final double padH = isLandscape ? sw * 0.015 : sw * 0.032;
    final double padV = isLandscape ? sh * 0.008 : sh * 0.005;
    final double radius = isLandscape ? sh * 0.03 : sw * 0.021;

    return SlideTransition(
      position: _sustainSlide,
      child: FadeTransition(
        opacity: _sustainFade,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
          decoration: BoxDecoration(
            color: const Color(0xFF01245E),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Text(
            "SUSTAIN TODAY, SECURE TOMORROW",
            style: TextStyle(
              fontFamily: 'BebasNeue',
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.4,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // RECYCLE GLOBE
  // ─────────────────────────────────────────
  Widget _buildRecycleGlobe(double sw, double sh, {required bool isLandscape}) {
    final double globeSize = isLandscape ? sh * 0.70 : sw * 0.44;

    return FadeTransition(
      opacity: _globeFade,
      child: ScaleTransition(
        scale: _globeScale,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.18),
                blurRadius: 18,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.10),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ShaderMask(
            blendMode: BlendMode.screen,
            shaderCallback: (bounds) {
              return RadialGradient(
                center: const Alignment(-0.2, -0.3),
                radius: 0.95,
                colors: [
                  Colors.white.withOpacity(0.65), // inner shine
                  Colors.green.withOpacity(0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.15, 1.0],
              ).createShader(bounds);
            },
            child: Image.asset(
              'assets/images/contol2.png',
              fit: BoxFit.contain,
              height: globeSize,
              width: globeSize,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // BOTTOM PANEL
  // ─────────────────────────────────────────
  Widget _buildBottomPanel(double sw, double sh, {required bool isLandscape}) {
    // Hide bottom panel in landscape — no room for it
    if (isLandscape) return const SizedBox.shrink();
    return Image.asset(
      'assets/images/splashBottom.png',
      width: double.infinity,
      //height: sh * 0.17,
      fit: BoxFit.fill,
    );
  }

}
