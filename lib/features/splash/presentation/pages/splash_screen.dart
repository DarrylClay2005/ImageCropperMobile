import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/pages/home_screen.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _startAnimations();
    _navigateToHome();
  }

  void _startAnimations() {
    _mainController.forward();
    _particleController.repeat();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 1200),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundDark,
              AppTheme.backgroundMedium,
              AppTheme.primaryBlue.withOpacity(0.1),
              AppTheme.backgroundDark,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacing
              const Spacer(flex: 2),
              
              // Main logo section
              Expanded(
                flex: 6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App icon with animations
                      _buildAppIcon(),
                      
                      const SizedBox(height: 32),
                      
                      // App title
                      _buildAppTitle(),
                      
                      const SizedBox(height: 16),
                      
                      // Version and tagline
                      _buildVersionInfo(),
                      
                      const SizedBox(height: 48),
                      
                      // Loading indicator
                      _buildLoadingIndicator(),
                    ],
                  ),
                ),
              ),
              
              // Bottom section
              Expanded(
                flex: 1,
                child: _buildBottomInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue,
                AppTheme.primaryBlueDark,
                AppTheme.accentCyan,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.crop_original_rounded,
            size: 80,
            color: Colors.white,
          ),
        )
            .animate(controller: _mainController)
            .scale(
              duration: 1200.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0.3, 0.3),
              end: const Offset(1.0, 1.0),
            )
            .fadeIn(
              duration: 800.ms,
              curve: Curves.easeOut,
            )
            .then()
            .shimmer(
              duration: 2000.ms,
              color: Colors.white.withOpacity(0.6),
            );
      },
    );
  }

  Widget _buildAppTitle() {
    return Column(
      children: [
        Text(
          'Image Cropper Pro',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 800.ms)
            .slideY(
              begin: 0.3,
              end: 0,
              curve: Curves.easeOutCubic,
              duration: 800.ms,
              delay: 600.ms,
            ),
        
        const SizedBox(height: 8),
        
        Text(
          'AI-Powered Image Processing',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryBlue,
            letterSpacing: 0.5,
          ),
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 600.ms)
            .slideY(
              begin: 0.2,
              end: 0,
              curve: Curves.easeOut,
              duration: 600.ms,
              delay: 800.ms,
            ),
      ],
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundMedium,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        'Version 2.0.0 - Revolutionary Edition',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecondary,
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 1000.ms, duration: 600.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 600.ms,
          delay: 1000.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryBlue,
            ),
          ),
        )
            .animate(controller: _particleController)
            .fadeIn(delay: 1200.ms)
            .then()
            .rotate(
              duration: 2000.ms,
              curve: Curves.linear,
            ),
        
        const SizedBox(height: 16),
        
        Text(
          'Loading amazing features...',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.textTertiary,
          ),
        )
            .animate()
            .fadeIn(delay: 1400.ms, duration: 600.ms)
            .then()
            .shimmer(
              duration: 2000.ms,
              color: AppTheme.primaryBlue.withOpacity(0.5),
            ),
      ],
    );
  }

  Widget _buildBottomInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified,
              size: 16,
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'Professional Grade',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Made with ❤️ by DarrylClay',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 2000.ms, duration: 800.ms)
        .slideY(
          begin: 0.5,
          end: 0,
          duration: 800.ms,
          delay: 2000.ms,
          curve: Curves.easeOut,
        );
  }
}