import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller for transition
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Fade out animation for transition
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate checking authentication tokens
      setState(() {
        _initializationStatus = 'Checking authentication...';
      });
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate loading user preferences
      setState(() {
        _initializationStatus = 'Loading preferences...';
      });
      await Future.delayed(const Duration(milliseconds: 600));

      // Simulate preparing cached data
      setState(() {
        _initializationStatus = 'Preparing data...';
      });
      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Ready!';
      });

      // Wait a moment before navigation
      await Future.delayed(const Duration(milliseconds: 500));

      // Start fade out animation
      await _fadeAnimationController.forward();

      // Navigate based on authentication status
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors
      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Initialization failed';
      });

      // Show retry option after 5 seconds
      await Future.delayed(const Duration(seconds: 5));
      _showRetryOption();
    }
  }

  void _navigateToNextScreen() {
    // Mock authentication check
    final bool isAuthenticated = _checkAuthenticationStatus();
    final bool isFirstTime = _checkFirstTimeUser();

    if (mounted) {
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      } else if (isFirstTime) {
        Navigator.pushReplacementNamed(context, '/registration-screen');
      } else {
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    }
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check - in real app, check stored tokens
    return false; // For demo, always return false to show login flow
  }

  bool _checkFirstTimeUser() {
    // Mock first-time user check - in real app, check shared preferences
    return true; // For demo, assume first-time user
  }

  void _showRetryOption() {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Connection Error',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            content: Text(
              'Unable to initialize the app. Please check your internet connection and try again.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _retryInitialization();
                },
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _initializationStatus = 'Retrying...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE91E63), // Dark pink
                    Color(0xFFFCE4EC), // Light pink
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer to push content to center
                    const Spacer(flex: 2),

                    // Logo section with animation
                    AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Opacity(
                            opacity: _logoOpacityAnimation.value,
                            child: Column(
                              children: [
                                // App Logo
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'search',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 12.w,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 3.h),

                                // App Name
                                Text(
                                  'Lostify',
                                  style: AppTheme
                                      .lightTheme.textTheme.displaySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),

                                SizedBox(height: 1.h),

                                // App Tagline
                                Text(
                                  'Find What\'s Lost, Return What\'s Found',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.surface
                                        .withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(flex: 1),

                    // Loading section
                    if (_isInitializing) ...[
                      // Loading indicator
                      SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.surface,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Loading status text
                      Text(
                        _initializationStatus,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ] else ...[
                      // Ready state
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 1.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.surface
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.colorScheme.surface,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _initializationStatus,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Spacer(flex: 2),

                    // Version info
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Text(
                        'Version 1.0.0',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
