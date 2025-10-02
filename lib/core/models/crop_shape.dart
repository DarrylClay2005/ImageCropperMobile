import 'package:flutter/material.dart';

enum CropShape {
  circle,
  rectangle,
  square,
  heart,
  star,
  hexagon,
  diamond,
  oval,
  triangle,
  pentagon,
  custom,
}

extension CropShapeExtension on CropShape {
  String get displayName {
    switch (this) {
      case CropShape.circle:
        return 'Circle';
      case CropShape.rectangle:
        return 'Rectangle';
      case CropShape.square:
        return 'Square';
      case CropShape.heart:
        return 'Heart';
      case CropShape.star:
        return 'Star';
      case CropShape.hexagon:
        return 'Hexagon';
      case CropShape.diamond:
        return 'Diamond';
      case CropShape.oval:
        return 'Oval';
      case CropShape.triangle:
        return 'Triangle';
      case CropShape.pentagon:
        return 'Pentagon';
      case CropShape.custom:
        return 'Custom';
    }
  }

  IconData get icon {
    switch (this) {
      case CropShape.circle:
        return Icons.circle_outlined;
      case CropShape.rectangle:
        return Icons.rectangle_outlined;
      case CropShape.square:
        return Icons.square_outlined;
      case CropShape.heart:
        return Icons.favorite_outline;
      case CropShape.star:
        return Icons.star_outline;
      case CropShape.hexagon:
        return Icons.hexagon_outlined;
      case CropShape.diamond:
        return Icons.diamond_outlined;
      case CropShape.oval:
        return Icons.circle_outlined;
      case CropShape.triangle:
        return Icons.change_history_outlined;
      case CropShape.pentagon:
        return Icons.pentagon_outlined;
      case CropShape.custom:
        return Icons.brush_outlined;
    }
  }

  Color get primaryColor {
    switch (this) {
      case CropShape.circle:
        return const Color(0xFF00D4FF);
      case CropShape.rectangle:
        return const Color(0xFF4CAF50);
      case CropShape.square:
        return const Color(0xFFFF9800);
      case CropShape.heart:
        return const Color(0xFFE91E63);
      case CropShape.star:
        return const Color(0xFFFFC107);
      case CropShape.hexagon:
        return const Color(0xFF9C27B0);
      case CropShape.diamond:
        return const Color(0xFF00BCD4);
      case CropShape.oval:
        return const Color(0xFF3F51B5);
      case CropShape.triangle:
        return const Color(0xFFFF5722);
      case CropShape.pentagon:
        return const Color(0xFF8BC34A);
      case CropShape.custom:
        return const Color(0xFF607D8B);
    }
  }

  String get description {
    switch (this) {
      case CropShape.circle:
        return 'Perfect for profile pictures and avatars';
      case CropShape.rectangle:
        return 'Ideal for banners and headers';
      case CropShape.square:
        return 'Great for social media posts';
      case CropShape.heart:
        return 'Perfect for romantic and love themes';
      case CropShape.star:
        return 'Eye-catching for highlights and awards';
      case CropShape.hexagon:
        return 'Modern geometric design';
      case CropShape.diamond:
        return 'Elegant and sophisticated look';
      case CropShape.oval:
        return 'Soft and professional appearance';
      case CropShape.triangle:
        return 'Dynamic and energetic feel';
      case CropShape.pentagon:
        return 'Unique and memorable shape';
      case CropShape.custom:
        return 'Create your own unique shape';
    }
  }
}