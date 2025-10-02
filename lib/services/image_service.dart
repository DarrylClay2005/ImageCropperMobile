import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import '../core/models/crop_shape.dart';

class ImageService extends ChangeNotifier {
  File? _originalImage;
  File? _croppedImage;
  bool _isProcessing = false;
  String _processingMessage = '';
  CropShape _selectedShape = CropShape.circle;

  // Getters
  File? get originalImage => _originalImage;
  File? get croppedImage => _croppedImage;
  bool get isProcessing => _isProcessing;
  String get processingMessage => _processingMessage;
  CropShape get selectedShape => _selectedShape;
  bool get hasImage => _originalImage != null;
  bool get hasCroppedImage => _croppedImage != null;

  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      _setProcessing(true, 'Selecting image...');
      
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 95,
      );

      if (pickedFile != null) {
        _setProcessing(true, 'Loading image...');
        await Future.delayed(const Duration(milliseconds: 500));
        
        _originalImage = File(pickedFile.path);
        _croppedImage = null; // Reset cropped image
        
        _setProcessing(false, '');
        notifyListeners();
      } else {
        _setProcessing(false, '');
      }
    } catch (e) {
      _setProcessing(false, '');
      throw Exception('Failed to pick image: $e');
    }
  }

  // Set selected crop shape
  void setShape(CropShape shape) {
    _selectedShape = shape;
    notifyListeners();
  }

  // Set original image (for use with BLoC)
  void setOriginalImage(File? image) {
    _originalImage = image;
    _croppedImage = null; // Reset cropped image
    notifyListeners();
  }

  // Set cropped image (for use with BLoC)
  void setCroppedImage(File? image) {
    _croppedImage = image;
    notifyListeners();
  }

  // Crop image with selected shape
  Future<void> cropImage() async {
    if (_originalImage == null) return;

    try {
      _setProcessing(true, 'Preparing ${_selectedShape.displayName.toLowerCase()} crop...');
      await Future.delayed(const Duration(milliseconds: 300));

      // Load and decode image
      _setProcessing(true, 'Processing image...');
      final bytes = await _originalImage!.readAsBytes();
      final originalImg = img.decodeImage(bytes);
      if (originalImg == null) throw Exception('Failed to decode image');

      await Future.delayed(const Duration(milliseconds: 500));
      
      _setProcessing(true, 'Applying ${_selectedShape.displayName.toLowerCase()} mask...');
      
      // Apply crop based on selected shape
      final croppedImg = _applyCropShape(originalImg, _selectedShape);
      
      _setProcessing(true, 'Finalizing image...');
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Save cropped image
      final directory = await getTemporaryDirectory();
      final filename = 'cropped_${_selectedShape.name}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$filename');
      
      await file.writeAsBytes(img.encodePng(croppedImg));
      _croppedImage = file;
      
      _setProcessing(false, '');
      notifyListeners();
      
    } catch (e) {
      _setProcessing(false, '');
      throw Exception('Failed to crop image: $e');
    }
  }

  // Apply crop shape to image
  img.Image _applyCropShape(img.Image image, CropShape shape) {
    // Create square crop first
    final size = math.min(image.width, image.height);
    final left = (image.width - size) ~/ 2;
    final top = (image.height - size) ~/ 2;
    
    final squareImage = img.copyCrop(image, 
        x: left, y: top, width: size, height: size);

    switch (shape) {
      case CropShape.circle:
        return _cropCircle(squareImage);
      case CropShape.rectangle:
        // Rectangle crop - maintain aspect ratio but crop to rectangle
        return _cropRectangle(squareImage);
      case CropShape.square:
        return squareImage;
      case CropShape.heart:
        return _cropHeart(squareImage);
      case CropShape.star:
        return _cropStar(squareImage);
      case CropShape.hexagon:
        return _cropHexagon(squareImage);
      case CropShape.diamond:
        return _cropDiamond(squareImage);
      case CropShape.oval:
        return _cropCircle(squareImage); // Use circle for oval
      case CropShape.triangle:
        return _cropTriangle(squareImage);
      case CropShape.pentagon:
        return _cropPentagon(squareImage);
      case CropShape.custom:
        return squareImage; // Default to square for custom
    }
  }

  // Circle crop
  img.Image _cropCircle(img.Image image) {
    final size = image.width;
    final center = size / 2;
    final radius = center;

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final distance = math.sqrt(
          math.pow(x - center, 2) + math.pow(y - center, 2)
        );
        
        if (distance > radius) {
          image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
        }
      }
    }
    return image;
  }

  // Heart crop
  img.Image _cropHeart(img.Image image) {
    final size = image.width;
    final center = size / 2;
    
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (!_isInsideHeart(x - center, y - center, size)) {
          image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
        }
      }
    }
    return image;
  }

  // Star crop
  img.Image _cropStar(img.Image image) {
    final size = image.width;
    final center = size / 2;
    
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (!_isInsideStar(x - center, y - center, size)) {
          image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
        }
      }
    }
    return image;
  }

  // Hexagon crop
  img.Image _cropHexagon(img.Image image) {
    final size = image.width;
    final center = size / 2;
    
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (!_isInsideHexagon(x - center, y - center, size)) {
          image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
        }
      }
    }
    return image;
  }

  // Diamond crop
  img.Image _cropDiamond(img.Image image) {
    final size = image.width;
    final center = size / 2;
    
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final distance = (x - center).abs() + (y - center).abs();
        if (distance > center * 0.7) {
          image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
        }
      }
    }
    return image;
  }

  // Rectangle crop
  img.Image _cropRectangle(img.Image image) {
    // For rectangle, create 16:9 aspect ratio crop
    final width = image.width;
    final height = (width * 9 / 16).round();
    final top = (image.height - height) ~/ 2;
    
    return img.copyCrop(image, x: 0, y: top, width: width, height: height);
  }

  // Triangle crop
  img.Image _cropTriangle(img.Image image) {
    final size = image.width;
    final center = size / 2;
    
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (!_isInsideTriangle(x - center, y - center, size)) {
          image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
        }
      }
    }
    return image;
  }

  // Pentagon crop
  img.Image _cropPentagon(img.Image image) {
    final size = image.width;
    final center = size / 2;
    
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (!_isInsidePentagon(x - center, y - center, size)) {
          image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
        }
      }
    }
    return image;
  }

  // Helper function for heart shape
  bool _isInsideHeart(double x, double y, int size) {
    final scale = size / 400.0; // Scale factor
    x /= scale;
    y /= scale;
    y += 50; // Offset for better positioning
    
    // Heart equation: (x^2 + y^2 - 1)^3 - x^2 * y^3 = 0
    final eq = math.pow(x * x + y * y - 2500, 3) - x * x * y * y * y;
    return eq <= 0;
  }

  // Helper function for star shape
  bool _isInsideStar(double x, double y, int size) {
    final center = size / 2;
    final angle = math.atan2(y, x);
    final distance = math.sqrt(x * x + y * y);
    
    // Create 5-pointed star
    final starAngle = (angle + math.pi) / (2 * math.pi) * 10;
    final starIndex = starAngle.floor() % 10;
    
    final outerRadius = center * 0.4;
    final innerRadius = center * 0.16;
    
    final targetRadius = (starIndex % 2 == 0) ? outerRadius : innerRadius;
    
    return distance <= targetRadius;
  }

  // Helper function for hexagon shape
  bool _isInsideHexagon(double x, double y, int size) {
    final radius = size * 0.4;
    
    // Check if point is inside regular hexagon
    final dx = x.abs();
    final dy = y.abs();
    
    return dx <= radius && 
           (dx * 0.866025 + dy * 0.5) <= radius; // sqrt(3)/2 ≈ 0.866025
  }

  // Helper function for triangle shape
  bool _isInsideTriangle(double x, double y, int size) {
    final height = size * 0.4;
    final base = size * 0.35;
    
    // Equilateral triangle pointing up
    if (y > height) return false; // Above triangle
    
    // Check if point is inside triangle using barycentric coordinates
    final slope = height / base;
    return (y >= -height * 0.5) && 
           (x >= -base + y / slope) && 
           (x <= base - y / slope);
  }

  // Helper function for pentagon shape
  bool _isInsidePentagon(double x, double y, int size) {
    final radius = size * 0.35;
    final angle = math.atan2(y, x);
    final distance = math.sqrt(x * x + y * y);
    
    // Create 5-sided polygon
    final pentagonAngle = (angle + math.pi) / (2 * math.pi) * 5;
    final pentagonIndex = pentagonAngle.floor() % 5;
    
    // Simple approximation for pentagon
    final maxRadius = radius * (0.9 + 0.1 * math.cos(pentagonAngle * 2 * math.pi));
    
    return distance <= maxRadius;
  }

  // Save cropped image to gallery/external storage
  Future<String> saveImage() async {
    if (_croppedImage == null) throw Exception('No cropped image to save');

    try {
      _setProcessing(true, 'Preparing to save...');
      await Future.delayed(const Duration(milliseconds: 300));

      final directory = await getExternalStorageDirectory() ?? 
                       await getApplicationDocumentsDirectory();
      
      final filename = 'ImageCropper_${_selectedShape.displayName}_${DateTime.now().millisecondsSinceEpoch}.png';
      final newPath = '${directory.path}/$filename';
      
      _setProcessing(true, 'Saving image...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      await _croppedImage!.copy(newPath);
      
      _setProcessing(false, '');
      return newPath;
      
    } catch (e) {
      _setProcessing(false, '');
      throw Exception('Failed to save image: $e');
    }
  }

  // Reset to original image
  void resetImage() {
    _croppedImage = null;
    notifyListeners();
  }

  // Clear all images
  void clearImages() {
    _originalImage = null;
    _croppedImage = null;
    _selectedShape = CropShape.circle;
    notifyListeners();
  }

  // Helper method to set processing state
  void _setProcessing(bool processing, String message) {
    _isProcessing = processing;
    _processingMessage = message;
    notifyListeners();
  }
}
