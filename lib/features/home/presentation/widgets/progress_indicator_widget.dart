import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/blocs/image_cropper/image_cropper_bloc.dart';
import '../../../../core/theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageCropperBloc, ImageCropperState>(
      builder: (context, state) {
        if (!state.isLoading) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.backgroundMedium,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Circular Progress Indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: state.progress,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(state.status),
                      ),
                    ),
                  ),
                  Text(
                    '${(state.progress * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getProgressColor(state.status),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Status Message
              Text(
                state.statusMessage,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Sub Message
              Text(
                _getSubMessage(state.status),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Linear Progress Indicator
              LinearProgressIndicator(
                value: state.progress,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(state.status),
                ),
                minHeight: 6,
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getProgressColor(ImageCropperStatus status) {
    switch (status) {
      case ImageCropperStatus.picking:
        return AppTheme.primaryBlue;
      case ImageCropperStatus.processing:
        return AppTheme.warningColor;
      case ImageCropperStatus.saving:
        return AppTheme.successColor;
      default:
        return AppTheme.primaryBlue;
    }
  }

  String _getSubMessage(ImageCropperStatus status) {
    switch (status) {
      case ImageCropperStatus.picking:
        return 'Accessing image source...';
      case ImageCropperStatus.processing:
        return 'Applying shape transformation...';
      case ImageCropperStatus.saving:
        return 'Writing to storage...';
      default:
        return 'Please wait...';
    }
  }
}