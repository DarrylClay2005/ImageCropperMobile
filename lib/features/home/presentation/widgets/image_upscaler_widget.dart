import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/blocs/image_cropper/image_cropper_bloc.dart';
import '../../../../core/blocs/image_upscaler/image_upscaler_bloc.dart';
import '../../../../core/services/image_upscaler_service.dart';
import '../../../../core/theme/app_theme.dart';

class ImageUpscalerWidget extends StatefulWidget {
  const ImageUpscalerWidget({super.key});

  @override
  State<ImageUpscalerWidget> createState() => _ImageUpscalerWidgetState();
}

class _ImageUpscalerWidgetState extends State<ImageUpscalerWidget> {
  int _selectedScaleFactor = 2;
  bool _enhanceQuality = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageCropperBloc, ImageCropperState>(
      builder: (context, cropperState) {
        return BlocConsumer<ImageUpscalerBloc, ImageUpscalerState>(
          listener: (context, state) {
            if (state.hasError) {
              _showErrorSnackBar(context, state.errorMessage!);
            } else if (state.isCompleted) {
              _showSuccessSnackBar(context, 'Image upscaled successfully!');
            }
          },
          builder: (context, upscalerState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.backgroundMedium,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.accentCyan.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  
                  if (upscalerState.isLoading)
                    _buildProgressIndicator(upscalerState)
                  else if (upscalerState.hasUpscaledImage)
                    _buildResultSection(upscalerState)
                  else
                    _buildUpscaleControls(cropperState, upscalerState),
                  
                  const SizedBox(height: 20),
                  _buildActionButtons(cropperState, upscalerState),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentCyan.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.auto_fix_high_rounded,
            color: AppTheme.accentCyan,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Image Upscaler',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Enhance image quality with AI technology',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentCyan.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.stars_rounded,
                color: AppTheme.accentCyan,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                'AI POWERED',
                style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentCyan,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(ImageUpscalerState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: state.progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentCyan),
                ),
              ),
              Column(
                children: [
                  Icon(
                    Icons.auto_fix_high_rounded,
                    color: AppTheme.accentCyan,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(state.progress * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentCyan,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            state.statusMessage,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            state.progressDescription,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: Colors.grey.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentCyan),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection(ImageUpscalerState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.successColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppTheme.successColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Image Enhanced Successfully!',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (state.metadata != null) ...[
            _buildMetadataRow('Scale Factor', '${state.metadata!['scale_factor']}x'),
            if (state.metadata!['processing_time'] != null)
              _buildMetadataRow('Processing Time', '${state.metadata!['processing_time']}s'),
            if (state.metadata!['original_size'] != null)
              _buildMetadataRow('Original Size', '${state.metadata!['original_size']}MB'),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.successColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpscaleControls(ImageCropperState cropperState, ImageUpscalerState upscalerState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upscale Settings',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        
        // Scale Factor Selection
        Text(
          'Scale Factor',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        
        Row(
          children: upscalerState.supportedScaleFactors.map((factor) {
            final isSelected = _selectedScaleFactor == factor;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedScaleFactor = factor),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.accentCyan.withOpacity(0.2)
                        : AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected 
                          ? AppTheme.accentCyan 
                          : Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${factor}x',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.accentCyan : Colors.white54,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Enhancement Options
        Row(
          children: [
            Checkbox(
              value: _enhanceQuality,
              onChanged: (value) => setState(() => _enhanceQuality = value ?? true),
              activeColor: AppTheme.accentCyan,
            ),
            Text(
              'AI Quality Enhancement',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        if (!upscalerState.isApiKeyValid)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.errorColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: AppTheme.errorColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'API key validation failed. Service may be unavailable.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(ImageCropperState cropperState, ImageUpscalerState upscalerState) {
    final hasSourceImage = cropperState.hasImage || cropperState.hasCroppedImage;
    final canUpscale = hasSourceImage && !upscalerState.isLoading;
    
    return Row(
      children: [
        if (hasSourceImage && !upscalerState.hasUpscaledImage) ...[
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accentCyan, AppTheme.accentCyan.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: canUpscale ? () => _startUpscale(cropperState) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.auto_fix_high_rounded, color: Colors.white),
                label: Text(
                  upscalerState.isLoading ? 'Processing...' : 'Upscale with AI ${_selectedScaleFactor}x',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
        ],
        
        if (upscalerState.hasUpscaledImage) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.read<ImageUpscalerBloc>().add(const ResetUpscalerEvent()),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.warningColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: Icon(Icons.refresh_rounded, color: AppTheme.warningColor, size: 18),
              label: Text(
                'Reset',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warningColor,
                ),
              ),
            ),
          ),
        ] else if (!hasSourceImage) ...[
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  'Select an image to upscale',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _startUpscale(ImageCropperState cropperState) {
    final sourceImage = cropperState.croppedImage ?? cropperState.originalImage;
    if (sourceImage != null) {
      context.read<ImageUpscalerBloc>().add(
        UpscaleImageEvent(
          imageFile: sourceImage,
          scaleFactor: _selectedScaleFactor,
          enhanceQuality: _enhanceQuality,
        ),
      );
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}