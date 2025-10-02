import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/blocs/image_cropper/image_cropper_bloc.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/crop_shape.dart';
import '../../../../core/models/export_template.dart';
import '../widgets/shape_selector_widget.dart';
import '../widgets/template_selector_widget.dart';
import '../widgets/image_preview_widget.dart';
import '../widgets/control_buttons_widget.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/image_upscaler_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  
  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Start animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundDark,
              AppTheme.backgroundMedium,
              AppTheme.backgroundDark,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: BlocListener<ImageCropperBloc, ImageCropperState>(
            listener: (context, state) {
              _handleStateChanges(state);
            },
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                _buildHeaderSection(),
                _buildMainContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(ImageCropperState state) {
    if (state.hasError) {
      _showErrorSnackBar(state.errorMessage!);
    } else if (state.status == ImageCropperStatus.saved) {
      _showSuccessSnackBar('Image saved successfully!');
    } else if (state.status == ImageCropperStatus.cropped) {
      _showSuccessSnackBar('Image cropped successfully!');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.backgroundMedium,
                AppTheme.backgroundMedium.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.primaryBlue,
                    AppTheme.primaryBlueDark,
                  ],
                ),
              ),
              child: const Icon(
                Icons.crop_original_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Image Cropper Pro',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ).animate(controller: _headerController)
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.5, end: 0, curve: Curves.easeOutCubic),
        centerTitle: false,
      ),
      actions: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.themeMode == ThemeMode.dark 
                    ? Icons.light_mode_rounded 
                    : Icons.dark_mode_rounded,
                color: AppTheme.primaryBlue,
              ),
              onPressed: () {
                context.read<ThemeBloc>().add(const ToggleThemeEvent());
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.info_outline_rounded,
            color: AppTheme.primaryBlue,
          ),
          onPressed: _showAboutDialog,
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.backgroundMedium,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 48,
              color: AppTheme.primaryBlue,
            ).animate(controller: _headerController)
                .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut)
                .then()
                .shimmer(duration: 2000.ms, color: AppTheme.primaryBlue.withOpacity(0.3)),
            
            const SizedBox(height: 16),
            
            Text(
              'AI-Powered Image Cropping',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ).animate(controller: _headerController)
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
            
            const SizedBox(height: 8),
            
            Text(
              'Transform your images with professional-grade cropping tools',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ).animate(controller: _headerController)
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Image Preview Section
          const ImagePreviewWidget()
              .animate(controller: _contentController)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
          
          const SizedBox(height: 24),
          
          // Control Buttons
          const ControlButtonsWidget()
              .animate(controller: _contentController)
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
          
          const SizedBox(height: 24),
          
          // Progress Indicator
          const ProgressIndicatorWidget()
              .animate(controller: _contentController)
              .fadeIn(delay: 300.ms, duration: 600.ms),
          
          const SizedBox(height: 24),
          
          // Template Selector
          const TemplateSelectorWidget()
              .animate(controller: _contentController)
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
          
          const SizedBox(height: 24),
          
          // Shape Selector
          const ShapeSelectorWidget()
              .animate(controller: _contentController)
              .fadeIn(delay: 500.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
          
          const SizedBox(height: 24),
          
          // AI Image Upscaler
          const ImageUpscalerWidget()
              .animate(controller: _contentController)
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
          
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDark],
                ),
              ),
              child: const Icon(
                Icons.crop_original_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'About',
              style: GoogleFonts.inter(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Image Cropper Pro v2.0.0',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'A revolutionary image cropping application with AI-powered features and professional-grade tools.',
              style: GoogleFonts.inter(
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '✨ Features:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...const [
              '• 11+ Professional crop shapes',
              '• 24+ Export templates for social media',
              '• AI-powered image upscaler',
              '• AI-powered image enhancement',
              '• Custom resolution support',
              '• High-quality image processing',
              '• Modern Material Design 3 UI',
            ].map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                feature,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            )),
            const SizedBox(height: 16),
            Text(
              'Made with ❤️ by DarrylClay',
              style: GoogleFonts.inter(
                fontStyle: FontStyle.italic,
                color: AppTheme.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}