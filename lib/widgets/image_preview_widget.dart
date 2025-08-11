import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../services/image_service.dart';
import '../utils/app_theme.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageService>(
      builder: (context, imageService, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.mediumBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightBackground,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildContent(imageService),
          ),
        );
      },
    );
  }

  Widget _buildContent(ImageService imageService) {
    if (imageService.isProcessing) {
      return _buildProcessingView(imageService);
    } else if (imageService.hasCroppedImage) {
      return _buildImageView(imageService.croppedImage!);
    } else if (imageService.hasImage) {
      return _buildImageView(imageService.originalImage!);
    } else {
      return _buildPlaceholderView();
    }
  }

  Widget _buildProcessingView(ImageService imageService) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitFadingCube(
            color: AppTheme.primaryBlue,
            size: 50.0,
          ),
          const SizedBox(height: 24),
          Text(
            imageService.processingMessage,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Please wait...',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageView(File imageFile) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.file(
          imageFile,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
        
        // Overlay for cropped images
        Consumer<ImageService>(
          builder: (context, imageService, child) {
            if (imageService.hasCroppedImage) {
              return Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        imageService.selectedShape.icon,
                        style: const TextStyle(
                          color: AppTheme.darkBackground,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        imageService.selectedShape.displayName,
                        style: const TextStyle(
                          color: AppTheme.darkBackground,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildPlaceholderView() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightBackground,
              border: Border.all(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 40,
              color: AppTheme.textSecondary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Select an Image',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Choose a photo from your gallery or camera\nto start cropping into beautiful shapes',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'JPG • PNG • GIF • BMP',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
