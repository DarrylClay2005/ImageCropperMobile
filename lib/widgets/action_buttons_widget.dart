import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/image_service.dart';
import '../utils/app_theme.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageService>(
      builder: (context, imageService, child) {
        return Row(
          children: [
            // Select Image Button
            Expanded(
              child: _ActionButton(
                icon: Icons.photo_library,
                label: 'Select Image',
                onPressed: () => _showImageSourceDialog(context, imageService),
                enabled: !imageService.isProcessing,
                isPrimary: !imageService.hasImage,
              ),
            ),
            
            if (imageService.hasImage) ...[
              const SizedBox(width: 12),
              
              // Crop Button
              Expanded(
                child: _ActionButton(
                  icon: Icons.crop,
                  label: 'Crop ${imageService.selectedShape.displayName}',
                  onPressed: () => _cropImage(context, imageService),
                  enabled: !imageService.isProcessing,
                  isPrimary: true,
                ),
              ),
            ],
            
            if (imageService.hasCroppedImage) ...[
              const SizedBox(width: 12),
              
              // Save Button
              Expanded(
                child: _ActionButton(
                  icon: Icons.save_alt,
                  label: 'Save',
                  onPressed: () => _saveImage(context, imageService),
                  enabled: !imageService.isProcessing,
                  isPrimary: false,
                  color: AppTheme.success,
                ),
              ),
            ],
            
            if (imageService.hasImage) ...[
              const SizedBox(width: 12),
              
              // Reset/Clear Button
              Expanded(
                child: _ActionButton(
                  icon: imageService.hasCroppedImage ? Icons.refresh : Icons.clear,
                  label: imageService.hasCroppedImage ? 'Reset' : 'Clear',
                  onPressed: () => _resetImage(context, imageService),
                  enabled: !imageService.isProcessing,
                  isPrimary: false,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext context, ImageService imageService) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.mediumBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/kowalski.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Image Source',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onPressed: () {
                      Navigator.pop(context);
                      _selectImage(context, imageService, ImageSource.gallery);
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: _SourceButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onPressed: () {
                      Navigator.pop(context);
                      _selectImage(context, imageService, ImageSource.camera);
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage(BuildContext context, ImageService imageService, ImageSource source) async {
    try {
      await imageService.pickImage(source);
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to select image: $e');
      }
    }
  }

  Future<void> _cropImage(BuildContext context, ImageService imageService) async {
    try {
      await imageService.cropImage();
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to crop image: $e');
      }
    }
  }

  Future<void> _saveImage(BuildContext context, ImageService imageService) async {
    try {
      final path = await imageService.saveImage();
      if (context.mounted) {
        _showSuccessDialog(context, 'Image saved successfully!\\nSaved to: $path');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to save image: $e');
      }
    }
  }

  void _resetImage(BuildContext context, ImageService imageService) {
    if (imageService.hasCroppedImage) {
      imageService.resetImage();
    } else {
      imageService.clearImages();
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: AppTheme.warning),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isPrimary;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.isPrimary = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? (isPrimary ? AppTheme.primaryBlue : AppTheme.mediumBackground);
    final textColor = isPrimary || color != null ? AppTheme.darkBackground : AppTheme.textPrimary;
    
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? buttonColor : AppTheme.lightBackground,
          foregroundColor: enabled ? textColor : AppTheme.textDisabled,
          elevation: enabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Material(
        color: AppTheme.lightBackground,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
