import 'package:dar/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _initializeAnimations();
    _startAnimationSequence();
    _navigateToHome();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    // Pulse animation for logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    // Start logo animation
    _logoController.forward();

    // Wait a bit, then start text animation
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      _textController.forward();
    }

    // Start pulse animation after logo is fully visible
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      // Stop pulse animation before navigation
      _pulseController.stop();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            _buildBackgroundElements(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoScaleAnimation,
                      _logoFadeAnimation,
                      _pulseAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale:
                            _logoScaleAnimation.value * _pulseAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4ECDC4,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.home_rounded,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Animated app name
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _textFadeAnimation,
                      child: Column(
                        children: [
                          const Text(
                            'DarTech',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Smart Home Solutions',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading indicator
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Floating circles
        Positioned(
          top: 100,
          right: 50,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_pulseAnimation.value - 1.0) * 0.3,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF4ECDC4).withOpacity(0.1),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 150,
          left: 30,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.6 + (_pulseAnimation.value - 1.0) * 0.2,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF44A08D).withOpacity(0.1),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 200,
          left: 40,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.9 + (_pulseAnimation.value - 1.0) * 0.1,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
