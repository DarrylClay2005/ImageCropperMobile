import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/image_service.dart';
import '../models/crop_shape.dart';
import '../utils/app_theme.dart';

class ShapeSelectionWidget extends StatelessWidget {
  const ShapeSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageService>(
      builder: (context, imageService, child) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: CropShape.values.map((shape) {
            final isSelected = imageService.selectedShape == shape;
            final isEnabled = imageService.hasImage && !imageService.isProcessing;
            
            return _ShapeButton(
              shape: shape,
              isSelected: isSelected,
              isEnabled: isEnabled,
              onTap: () {
                if (isEnabled) {
                  imageService.setShape(shape);
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class _ShapeButton extends StatelessWidget {
  final CropShape shape;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _ShapeButton({
    required this.shape,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppTheme.primaryBlue.withOpacity(0.1)
                  : AppTheme.lightBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? AppTheme.primaryBlue
                    : AppTheme.lightBackground.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ] : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Shape Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryBlue
                          : AppTheme.mediumBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        shape.icon,
                        style: TextStyle(
                          fontSize: 20,
                          color: isSelected 
                              ? AppTheme.darkBackground
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Shape Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          shape.displayName,
                          style: TextStyle(
                            color: isSelected 
                                ? AppTheme.primaryBlue
                                : isEnabled 
                                    ? AppTheme.textPrimary
                                    : AppTheme.textDisabled,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          shape.description,
                          style: TextStyle(
                            color: isEnabled 
                                ? AppTheme.textSecondary
                                : AppTheme.textDisabled,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Selection Indicator
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: AppTheme.darkBackground,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
