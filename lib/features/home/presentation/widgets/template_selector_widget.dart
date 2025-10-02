import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/blocs/image_cropper/image_cropper_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/export_template.dart';

class TemplateSelectorWidget extends StatelessWidget {
  const TemplateSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageCropperBloc, ImageCropperState>(
      builder: (context, state) {
        // Group templates by category
        final templatesByCategory = _groupTemplatesByCategory();
        
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dashboard_customize_rounded,
                    color: AppTheme.primaryBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Export Templates',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Text(
                    'Optimized for social media platforms',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (state.selectedTemplate != null)
                    GestureDetector(
                      onTap: () {
                        context.read<ImageCropperBloc>().add(const SelectTemplateEvent(null));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Clear',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Category Sections
              ...templatesByCategory.entries.map((entry) {
                return _buildCategorySection(
                  context: context,
                  categoryName: entry.key,
                  templates: entry.value,
                  selectedTemplate: state.selectedTemplate,
                );
              }).toList(),
              
              // Custom Resolution Option
              _buildCustomResolutionOption(context, state),
            ],
          ),
        );
      },
    );
  }

  Map<String, List<ExportTemplate>> _groupTemplatesByCategory() {
    final Map<String, List<ExportTemplate>> grouped = {};
    
    for (final template in ExportTemplate.values) {
      final category = template.category;
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(template);
    }
    
    return grouped;
  }

  Widget _buildCategorySection({
    required BuildContext context,
    required String categoryName,
    required List<ExportTemplate> templates,
    required ExportTemplate? selectedTemplate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: templates.map((template) {
            final isSelected = selectedTemplate == template;
            return _buildTemplateChip(
              context: context,
              template: template,
              isSelected: isSelected,
              onTap: () {
                context.read<ImageCropperBloc>().add(SelectTemplateEvent(template));
              },
            );
          }).toList(),
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTemplateChip({
    required BuildContext context,
    required ExportTemplate template,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? template.brandColor.withOpacity(0.2)
              : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? template.brandColor 
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              template.icon,
              color: isSelected ? template.brandColor : Colors.white54,
              size: 16,
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  template.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? template.brandColor : Colors.white54,
                  ),
                ),
                Text(
                  template.aspectRatio,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: isSelected 
                        ? template.brandColor.withOpacity(0.7) 
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomResolutionOption(BuildContext context, ImageCropperState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: state.customWidth != null
              ? AppTheme.primaryBlue
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Custom Resolution',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              if (state.customWidth != null)
                Text(
                  '${state.customWidth}×${state.customHeight}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Set your own width and height dimensions',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          ElevatedButton.icon(
            onPressed: () => _showCustomResolutionDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue.withOpacity(0.2),
              foregroundColor: AppTheme.primaryBlue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: Text(
              state.customWidth != null ? 'Edit' : 'Set Custom',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomResolutionDialog(BuildContext context) {
    final widthController = TextEditingController();
    final heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Custom Resolution',
          style: GoogleFonts.inter(
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widthController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Width (px)',
                labelStyle: GoogleFonts.inter(color: AppTheme.primaryBlue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Height (px)',
                labelStyle: GoogleFonts.inter(color: AppTheme.primaryBlue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
                ),
              ),
            ),
          ],
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
              final width = int.tryParse(widthController.text);
              final height = int.tryParse(heightController.text);
              
              if (width != null && height != null && width > 0 && height > 0) {
                context.read<ImageCropperBloc>().add(
                  SetCustomResolutionEvent(width: width, height: height),
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
            ),
            child: Text(
              'Apply',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}