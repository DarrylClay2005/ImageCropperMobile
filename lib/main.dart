import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Cropper Mobile',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4FF),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Color(0xFF00D4FF),
        ),
      ),
      home: ImageCropperHome(),
    );
  }
}

class ImageCropperHome extends StatefulWidget {
  @override
  _ImageCropperHomeState createState() => _ImageCropperHomeState();
}

class _ImageCropperHomeState extends State<ImageCropperHome> {
  File? _selectedImage;
  File? _croppedImage;
  CropShape _selectedShape = CropShape.circle;
  bool _isProcessing = false;
  String? _exportPath;

  @override
  void initState() {
    super.initState();
    _initializeExportFolder();
  }

  Future<void> _initializeExportFolder() async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        await _createExportFolder();
      }
    } catch (e) {
      print('Error initializing export folder: $e');
    }
  }

  Future<void> _createExportFolder() async {
    try {
      Directory? externalDir;
      if (Platform.isAndroid) {
        // Try to get DCIM directory first, fallback to Pictures
        final List<Directory?> dirs = [
          Directory('/storage/emulated/0/DCIM/Image Crop Exports'),
          Directory('/storage/emulated/0/Pictures/Image Crop Exports'),
        ];
        
        for (Directory? dir in dirs) {
          if (dir != null) {
            try {
              if (!await dir.exists()) {
                await dir.create(recursive: true);
              }
              // Test write access
              final testFile = File('${dir.path}/.test');
              await testFile.writeAsString('test');
              await testFile.delete();
              
              externalDir = dir;
              break;
            } catch (e) {
              print('Cannot access ${dir.path}: $e');
              continue;
            }
          }
        }
      }
      
      if (externalDir == null) {
        // Fallback to app directory
        final appDir = await getApplicationDocumentsDirectory();
        externalDir = Directory('${appDir.path}/Image Crop Exports');
        if (!await externalDir.exists()) {
          await externalDir.create(recursive: true);
        }
      }
      
      _exportPath = externalDir.path;
      print('Export folder created/verified at: $_exportPath');
    } catch (e) {
      print('Error creating export folder: $e');
      // Set fallback path
      final appDir = await getApplicationDocumentsDirectory();
      _exportPath = '${appDir.path}/Image Crop Exports';
    }
  }

  Future<void> _pickImageFromFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedImage = File(result.files.single.path!);
          _croppedImage = null; // Reset cropped image
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selected successfully! Choose a shape to crop.'),
            backgroundColor: Color(0xFF00D4FF),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cropImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final bytes = await _selectedImage!.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      
      if (originalImage != null) {
        final croppedImage = await _applyCropShape(originalImage, _selectedShape);
        
        // Save cropped image to temp location
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png');
        await tempFile.writeAsBytes(img.encodePng(croppedImage));
        
        setState(() {
          _croppedImage = tempFile;
          _isProcessing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image cropped successfully! Tap Export to save.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cropping image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<img.Image> _applyCropShape(img.Image originalImage, CropShape shape) async {
    final size = math.min(originalImage.width, originalImage.height);
    final centerX = originalImage.width ~/ 2;
    final centerY = originalImage.height ~/ 2;
    final radius = size ~/ 2;
    
    // Create a new image with transparent background
    final croppedImage = img.Image(
      width: size,
      height: size,
      numChannels: 4, // RGBA
    );
    img.fill(croppedImage, color: img.ColorRgba8(0, 0, 0, 0)); // Transparent
    
    // Apply shape mask
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final dx = x - radius;
        final dy = y - radius;
        
        bool isInside = false;
        
        switch (shape) {
          case CropShape.circle:
            isInside = (dx * dx + dy * dy) <= (radius * radius);
            break;
          case CropShape.square:
            isInside = true; // Square is just the full size
            break;
          case CropShape.heart:
            isInside = _isInsideHeart(dx, dy, radius);
            break;
          case CropShape.star:
            isInside = _isInsideStar(dx, dy, radius);
            break;
          case CropShape.hexagon:
            isInside = _isInsideHexagon(dx, dy, radius);
            break;
          case CropShape.diamond:
            isInside = _isInsideDiamond(dx, dy, radius);
            break;
        }
        
        if (isInside) {
          final srcX = centerX - radius + x;
          final srcY = centerY - radius + y;
          
          if (srcX >= 0 && srcX < originalImage.width && 
              srcY >= 0 && srcY < originalImage.height) {
            final pixel = originalImage.getPixel(srcX, srcY);
            croppedImage.setPixel(x, y, pixel);
          }
        }
      }
    }
    
    return croppedImage;
  }

  bool _isInsideHeart(int dx, int dy, int radius) {
    final x = dx / (radius * 0.8);
    final y = dy / (radius * 0.8);
    
    // Heart equation: (x^2 + y^2 - 1)^3 - x^2*y^3 <= 0
    final equation = math.pow((x * x + y * y - 1), 3) - x * x * y * y * y;
    return equation <= 0.1;
  }

  bool _isInsideStar(int dx, int dy, int radius) {
    final angle = math.atan2(dy, dx);
    final distance = math.sqrt(dx * dx + dy * dy);
    
    // 5-pointed star
    final starAngle = (angle + math.pi / 2) % (2 * math.pi / 5);
    final maxRadius = radius * (0.5 + 0.5 * math.cos(starAngle * 5 - math.pi));
    
    return distance <= maxRadius;
  }

  bool _isInsideHexagon(int dx, int dy, int radius) {
    final x = dx.abs();
    final y = dy.abs();
    return (x * 0.866025 + y * 0.5) <= radius;
  }

  bool _isInsideDiamond(int dx, int dy, int radius) {
    return (dx.abs() + dy.abs()) <= radius;
  }

  Future<void> _exportImage() async {
    if (_croppedImage == null || _exportPath == null) return;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'cropped_${_selectedShape.name}_$timestamp.png';
      final exportFile = File('$_exportPath/$fileName');
      
      await _croppedImage!.copy(exportFile.path);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image exported to: ${exportFile.path}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetImage() {
    setState(() {
      _croppedImage = null;
    });
  }

  void _clearAll() {
    setState(() {
      _selectedImage = null;
      _croppedImage = null;
      _selectedShape = CropShape.circle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Cropper Mobile V1.0.2'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.crop_original,
                      size: 60,
                      color: Color(0xFF00D4FF),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Professional Image Cropper',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'V1.0.2 - HeavenlyCodingPalace',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF00D4FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // File Selection
            ElevatedButton.icon(
              onPressed: _pickImageFromFiles,
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse Files'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: const Color(0xFF00D4FF),
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            // Image Preview
            if (_selectedImage != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Image Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00D4FF)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _croppedImage ?? _selectedImage!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Shape Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Choose Crop Shape',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: CropShape.values.map((shape) {
                          final isSelected = _selectedShape == shape;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedShape = shape;
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected 
                                    ? const Color(0xFF00D4FF) 
                                    : Colors.grey,
                                  width: 2,
                                ),
                                color: isSelected 
                                  ? const Color(0xFF00D4FF).withOpacity(0.1)
                                  : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    shape.icon,
                                    size: 30,
                                    color: isSelected 
                                      ? const Color(0xFF00D4FF) 
                                      : Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    shape.displayName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected 
                                        ? const Color(0xFF00D4FF) 
                                        : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Action Buttons
              Column(
                children: [
                  if (_isProcessing)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFF00D4FF),
                            ),
                            SizedBox(height: 12),
                            Text('Processing image...'),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    ElevatedButton.icon(
                      onPressed: _cropImage,
                      icon: const Icon(Icons.crop),
                      label: Text('Crop ${_selectedShape.displayName}'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    if (_croppedImage != null) ...[
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _exportImage,
                        icon: const Icon(Icons.save_alt),
                        label: const Text('Export Image'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: const Color(0xFF00D4FF),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _resetImage,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _clearAll,
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear All'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Image Selected',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap "Browse Files" to select an image from your device',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum CropShape {
  circle,
  square,
  heart,
  star,
  hexagon,
  diamond,
}

extension CropShapeExtension on CropShape {
  String get displayName {
    switch (this) {
      case CropShape.circle:
        return 'Circle';
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
    }
  }

  IconData get icon {
    switch (this) {
      case CropShape.circle:
        return Icons.circle_outlined;
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
    }
  }
}
