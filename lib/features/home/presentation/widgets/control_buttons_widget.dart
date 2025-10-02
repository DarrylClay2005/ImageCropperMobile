import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/blocs/image_cropper/image_cropper_bloc.dart';
import '../../../../core/theme/app_theme.dart';

class ControlButtonsWidget extends StatelessWidget {
  const ControlButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageCropperBloc, ImageCropperState>(
      builder: (context, state) {
        return Column(
          children: [
            // Primary action buttons
            Row(
              children: [
                // Pick Image Button
                Expanded(
                  child: _buildPrimaryButton(
                    context: context,
                    onPressed: () => _showImageSourceDialog(context),
                    icon: state.isLoading && state.status == ImageCropperStatus.picking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
                    label: state.isLoading && state.status == ImageCropperStatus.picking
                        ? 'Loading...'
                        : 'Select Image',
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDark],
                    ),
                  ),
                ),
                
                if (state.canCrop) ...[
                  const SizedBox(width: 12),
                  
                  // Crop Button
                  Expanded(
                    child: _buildPrimaryButton(
                      context: context,
                      onPressed: () => context.read<ImageCropperBloc>().add(const CropImageEvent()),
                      icon: const Icon(Icons.crop_rounded, color: Colors.white),
                      label: 'Crop ${state.selectedShape.displayName}',
                      gradient: const LinearGradient(
                        colors: [AppTheme.successColor, Color(0xFF66BB6A)],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Secondary action buttons
            Row(
              children: [
                if (state.canSave) ...[
                  // Save Button
                  Expanded(
                    child: _buildSecondaryButton(
                      context: context,
                      onPressed: () => _showSaveDialog(context),
                      icon: const Icon(Icons.save_alt_rounded),
                      label: 'Save Image',
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                ],
                
                // Reset Button
                Expanded(
                  child: _buildSecondaryButton(
                    context: context,
                    onPressed: state.hasImage ? () => context.read<ImageCropperBloc>().add(const ResetImageEvent()) : null,
                    icon: const Icon(Icons.refresh_rounded),
                    label: 'Reset',
                    color: AppTheme.warningColor,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Clear All Button
                Expanded(
                  child: _buildSecondaryButton(
                    context: context,
                    onPressed: state.hasImage ? () => context.read<ImageCropperBloc>().add(const ClearAllEvent()) : null,
                    icon: const Icon(Icons.clear_all_rounded),
                    label: 'Clear All',
                    color: AppTheme.errorColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
    required Gradient gradient,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        icon: icon,
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
    required Color color,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: onPressed != null ? color : Colors.grey, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      icon: Icon(
        icon.icon,
        color: onPressed != null ? color : Colors.grey,
        size: 18,
      ),
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: onPressed != null ? color : Colors.grey,
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundMedium,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            Row(
              children: [
                _buildSourceOption(
                  context: context,
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  source: ImageSource.gallery,
                ),
                const SizedBox(width: 16),
                _buildSourceOption(
                  context: context,
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  source: ImageSource.camera,
                ),
                const SizedBox(width: 16),
                _buildSourceOption(
                  context: context,
                  icon: Icons.folder_rounded,
                  label: 'Files',
                  source: ImageSource.files,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          context.read<ImageCropperBloc>().add(PickImageEvent(source));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primaryBlue, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Save Image',
          style: GoogleFonts.inter(
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Save the cropped image to your device?',
          style: GoogleFonts.inter(
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ImageCropperBloc>().add(const SaveImageEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
            ),
            child: Text(
              'Save',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}