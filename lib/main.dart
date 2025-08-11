import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;
// Animation imports removed for compatibility

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Cropper Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Color(0xFF00D4FF),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _animationController.forward();
    
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ImageCropperHome(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
              Color(0xFF00D4FF),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D4FF).withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.crop_original,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Image Cropper Mobile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'V1.0.4.b - Enhanced Export Edition',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF00D4FF),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const CircularProgressIndicator(
                        color: Color(0xFF00D4FF),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ImageCropperHome extends StatefulWidget {
  @override
  _ImageCropperHomeState createState() => _ImageCropperHomeState();
}

class _ImageCropperHomeState extends State<ImageCropperHome> with TickerProviderStateMixin {
  File? _selectedImage;
  File? _croppedImage;
  CropShape _selectedShape = CropShape.circle;
  ExportTemplate? _selectedTemplate;
  CustomResolution? _customResolution;
  bool _isProcessing = false;
  bool _isImageLoading = false;
  double _processingProgress = 0.0;
  String? _exportPath;
  String? _customSaveDirectory;
  
  late AnimationController _buttonAnimationController;
  late AnimationController _imageAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _imageSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeExportFolder();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeInOut),
    );
    
    _imageSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _imageAnimationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _imageAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeExportFolder() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _exportPath = '${appDir.path}/Image Crop Exports';
      
      final defaultDir = Directory(_exportPath!);
      if (!await defaultDir.exists()) {
        await defaultDir.create(recursive: true);
      }
    } catch (e) {
      final appDir = await getApplicationDocumentsDirectory();
      _exportPath = appDir.path;
    }
  }

  Future<void> _pickImageFromFiles() async {
    setState(() {
      _isImageLoading = true;
    });
    
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        
        setState(() {
          _selectedImage = File(result.files.single.path!);
          _croppedImage = null;
          _isImageLoading = false;
        });
        
        _imageAnimationController.forward();
        
        _showSuccessSnackBar('Image loaded successfully! Choose a shape and template to crop.');
      } else {
        setState(() {
          _isImageLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });
      _showErrorSnackBar('Error loading image: $e');
    }
  }

  Future<void> _cropImageWithProgress() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _processingProgress = 0.0;
    });

    try {
      // Simulate progress updates
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _processingProgress = i / 100;
        });
      }

      final bytes = await _selectedImage!.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      
      if (originalImage != null) {
        final croppedImage = await _applyCropShapeWithTemplate(originalImage);
        
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png');
        await tempFile.writeAsBytes(img.encodePng(croppedImage));
        
        setState(() {
          _croppedImage = tempFile;
          _isProcessing = false;
          _processingProgress = 0.0;
        });
        
        _showSuccessSnackBar('Image cropped successfully! Ready for export.');
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _processingProgress = 0.0;
      });
      _showErrorSnackBar('Error processing image: $e');
    }
  }

  Future<img.Image> _applyCropShapeWithTemplate(img.Image originalImage) async {
    int width, height;
    
    // Apply template dimensions or custom resolution
    if (_selectedTemplate != null) {
      width = _selectedTemplate!.width;
      height = _selectedTemplate!.height;
    } else if (_customResolution != null) {
      width = _customResolution!.width;
      height = _customResolution!.height;
    } else {
      // Default behavior - use minimum dimension for square crop
      final size = math.min(originalImage.width, originalImage.height);
      width = height = size;
    }
    
    // Resize original image to fit template
    final resizedImage = img.copyResize(originalImage, width: width, height: height);
    
    // Apply shape cropping
    return _applyCropShape(resizedImage, _selectedShape, width, height);
  }

  Future<img.Image> _applyCropShape(img.Image originalImage, CropShape shape, int targetWidth, int targetHeight) async {
    final centerX = originalImage.width ~/ 2;
    final centerY = originalImage.height ~/ 2;
    final radius = math.min(targetWidth, targetHeight) ~/ 2;
    
    final croppedImage = img.Image(
      width: targetWidth,
      height: targetHeight,
      numChannels: 4,
    );
    img.fill(croppedImage, color: img.ColorRgba8(0, 0, 0, 0));
    
    for (int y = 0; y < targetHeight; y++) {
      for (int x = 0; x < targetWidth; x++) {
        final dx = x - targetWidth ~/ 2;
        final dy = y - targetHeight ~/ 2;
        
        bool isInside = false;
        
        switch (shape) {
          case CropShape.circle:
            isInside = (dx * dx + dy * dy) <= (radius * radius);
            break;
          case CropShape.rectangle:
            isInside = true;
            break;
          case CropShape.square:
            final squareRadius = math.min(radius, radius);
            isInside = dx.abs() <= squareRadius && dy.abs() <= squareRadius;
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
          case CropShape.oval:
            isInside = _isInsideOval(dx, dy, targetWidth ~/ 2, targetHeight ~/ 2);
            break;
        }
        
        if (isInside) {
          final srcX = centerX - targetWidth ~/ 2 + x;
          final srcY = centerY - targetHeight ~/ 2 + y;
          
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
    final equation = math.pow((x * x + y * y - 1), 3) - x * x * y * y * y;
    return equation <= 0.1;
  }

  bool _isInsideStar(int dx, int dy, int radius) {
    final angle = math.atan2(dy, dx);
    final distance = math.sqrt(dx * dx + dy * dy);
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

  bool _isInsideOval(int dx, int dy, int radiusX, int radiusY) {
    final x = dx / radiusX.toDouble();
    final y = dy / radiusY.toDouble();
    return (x * x + y * y) <= 1.0;
  }

  Future<void> _selectSaveDirectory() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Choose Export Directory',
        lockParentWindow: true,
      );
      
      if (result != null) {
        setState(() {
          _customSaveDirectory = result;
        });
        
        _showSuccessSnackBar('Export directory set: ${result.split('/').last}');
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting directory: $e');
    }
  }

  Future<void> _showExportOptionsDialog() async {
    if (_croppedImage == null) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: const [
              Icon(Icons.save_alt, color: Color(0xFF00D4FF)),
              SizedBox(width: 12),
              Text(
                'Export Options',
                style: TextStyle(color: Color(0xFF00D4FF)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose how you want to export your cropped image:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              
              // Quick Export Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _exportImageToDefault();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.flash_on, color: Colors.white),
                  label: const Text(
                    'Quick Export',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              Text(
                'Export to default directory',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Custom Location Button
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _exportImageWithLocationPicker();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  side: const BorderSide(color: Color(0xFF00D4FF), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.folder_outlined, color: Color(0xFF00D4FF)),
                label: const Text(
                  'Choose Location',
                  style: TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              Text(
                'Pick a custom directory for export',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              
              if (_customSaveDirectory != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Export Directory:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _customSaveDirectory!.split('/').last,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF00D4FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportImageToDefault() async {
    if (_croppedImage == null) return;

    try {
      final saveDirectory = _exportPath;
      if (saveDirectory == null) {
        _showErrorSnackBar('No default directory available');
        return;
      }
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final templateSuffix = _selectedTemplate?.name ?? _selectedShape.name;
      final fileName = 'cropped_${templateSuffix}_$timestamp.png';
      final exportFile = File('$saveDirectory/$fileName');
      
      await _croppedImage!.copy(exportFile.path);
      
      _showSuccessSnackBar('Image exported successfully!\nSaved to: Image Crop Exports');
    } catch (e) {
      _showErrorSnackBar('Export failed: $e');
    }
  }

  Future<void> _exportImageWithLocationPicker() async {
    if (_croppedImage == null) return;

    try {
      // First, let user pick a directory
      final result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Choose Export Directory',
        lockParentWindow: true,
      );
      
      if (result != null) {
        // Update the custom save directory
        setState(() {
          _customSaveDirectory = result;
        });
        
        // Now export to the selected directory
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final templateSuffix = _selectedTemplate?.name ?? _selectedShape.name;
        final fileName = 'cropped_${templateSuffix}_$timestamp.png';
        final exportFile = File('$result/$fileName');
        
        await _croppedImage!.copy(exportFile.path);
        
        _showSuccessSnackBar('Image exported successfully!\nSaved to: ${result.split('/').last}');
      }
    } catch (e) {
      _showErrorSnackBar('Export failed: $e');
    }
  }

  void _showCustomResolutionDialog() {
    final widthController = TextEditingController();
    final heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Custom Resolution',
          style: TextStyle(color: Color(0xFF00D4FF)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widthController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Width (px)',
                labelStyle: TextStyle(color: Color(0xFF00D4FF)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00D4FF)),
                ),
              ),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Height (px)',
                labelStyle: TextStyle(color: Color(0xFF00D4FF)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00D4FF)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final width = int.tryParse(widthController.text);
              final height = int.tryParse(heightController.text);
              
              if (width != null && height != null && width > 0 && height > 0) {
                setState(() {
                  _customResolution = CustomResolution(width: width, height: height);
                  _selectedTemplate = null; // Clear template selection
                });
                Navigator.of(context).pop();
                _showSuccessSnackBar('Custom resolution set: ${width}x${height}px');
              } else {
                _showErrorSnackBar('Please enter valid dimensions');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00D4FF)),
            child: const Text('Apply', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _animateButton() {
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Image Cropper Mobile V1.0.4',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF0A0A0A),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
              Color(0xFF0A0A0A),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 20),
              _buildImagePreview(),
              const SizedBox(height: 20),
              _buildTemplateSelection(),
              const SizedBox(height: 20),
              _buildShapeSelection(),
              const SizedBox(height: 20),
              _buildProcessingIndicator(),
              const SizedBox(height: 20),
              _buildControlButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 10,
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF2A2A2A),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.crop_original,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Professional Image Cropper',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'V1.0.4 - Enhanced Edition',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00D4FF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _buttonScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _buttonScaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _animateButton();
                    _pickImageFromFiles();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: _isImageLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.photo_library, color: Colors.white),
                  label: Text(
                    _isImageLoading ? 'Loading Image...' : 'Select Image',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _showCustomResolutionDialog,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            side: const BorderSide(color: Color(0xFF00D4FF), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          icon: const Icon(Icons.tune, color: Color(0xFF00D4FF)),
          label: Text(
            _customResolution != null
                ? 'Custom: ${_customResolution!.width}x${_customResolution!.height}'
                : 'Custom Resolution',
            style: const TextStyle(color: Color(0xFF00D4FF)),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage == null) {
      return Card(
        elevation: 5,
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF333333)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 60,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 10),
              Text(
                'No Image Selected',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_imageSlideAnimation),
      child: Card(
        elevation: 10,
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Image Preview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (_croppedImage != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'CROPPED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00D4FF), width: 2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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
    );
  }

  Widget _buildTemplateSelection() {
    return Card(
      elevation: 5,
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Export Templates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExportTemplate.values.map((template) {
                final isSelected = _selectedTemplate == template;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTemplate = template;
                      _customResolution = null; // Clear custom resolution
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00D4FF)
                          : const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00D4FF)
                            : const Color(0xFF555555),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          template.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          '${template.width}x${template.height}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.black54 : Colors.grey,
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
    );
  }

  Widget _buildShapeSelection() {
    return Card(
      elevation: 5,
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Crop Shapes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                            )
                          : null,
                      color: isSelected ? null : const Color(0xFF333333),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00D4FF)
                            : const Color(0xFF555555),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00D4FF).withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          shape.icon,
                          size: 30,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          shape.displayName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey,
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
    );
  }

  Widget _buildProcessingIndicator() {
    if (!_isProcessing) return const SizedBox.shrink();

    return Card(
      elevation: 5,
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF00D4FF),
            ),
            const SizedBox(height: 16),
            const Text(
              'Processing Image...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _processingProgress,
              backgroundColor: const Color(0xFF333333),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_processingProgress * 100).toInt()}%',
              style: const TextStyle(
                color: Color(0xFF00D4FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Column(
      children: [
        if (_selectedImage != null && !_isProcessing) ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Colors.green, Color(0xFF4CAF50)],
              ),
            ),
            child: ElevatedButton.icon(
              onPressed: _cropImageWithProgress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.crop, color: Colors.white),
              label: Text(
                'Crop ${_selectedShape.displayName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (_croppedImage != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: _showExportOptionsDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(Icons.save_alt, color: Colors.white),
                label: const Text(
                  'Export Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _croppedImage = null;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  side: const BorderSide(color: Colors.orange, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.orange),
                label: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                    _croppedImage = null;
                    _selectedShape = CropShape.circle;
                    _selectedTemplate = null;
                    _customResolution = null;
                  });
                  _imageAnimationController.reset();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(Icons.clear_all, color: Colors.red),
                label: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Enhanced Enums and Classes
enum CropShape {
  circle,
  rectangle,
  square,
  heart,
  star,
  hexagon,
  diamond,
  oval,
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
    }
  }
}

enum ExportTemplate {
  instagram,
  instagramStory,
  youtubeThumbnail,
  youtubeBanner,
  facebookPost,
  facebookCover,
  twitterPost,
  twitterHeader,
  linkedinPost,
  linkedinBanner,
  tiktok,
  pinterest,
}

extension ExportTemplateExtension on ExportTemplate {
  String get displayName {
    switch (this) {
      case ExportTemplate.instagram:
        return 'Instagram Post';
      case ExportTemplate.instagramStory:
        return 'IG Story';
      case ExportTemplate.youtubeThumbnail:
        return 'YT Thumbnail';
      case ExportTemplate.youtubeBanner:
        return 'YT Banner';
      case ExportTemplate.facebookPost:
        return 'FB Post';
      case ExportTemplate.facebookCover:
        return 'FB Cover';
      case ExportTemplate.twitterPost:
        return 'Twitter Post';
      case ExportTemplate.twitterHeader:
        return 'Twitter Header';
      case ExportTemplate.linkedinPost:
        return 'LinkedIn Post';
      case ExportTemplate.linkedinBanner:
        return 'LinkedIn Banner';
      case ExportTemplate.tiktok:
        return 'TikTok';
      case ExportTemplate.pinterest:
        return 'Pinterest';
    }
  }

  int get width {
    switch (this) {
      case ExportTemplate.instagram:
        return 1080;
      case ExportTemplate.instagramStory:
        return 1080;
      case ExportTemplate.youtubeThumbnail:
        return 1280;
      case ExportTemplate.youtubeBanner:
        return 2560;
      case ExportTemplate.facebookPost:
        return 1200;
      case ExportTemplate.facebookCover:
        return 1200;
      case ExportTemplate.twitterPost:
        return 1024;
      case ExportTemplate.twitterHeader:
        return 1500;
      case ExportTemplate.linkedinPost:
        return 1200;
      case ExportTemplate.linkedinBanner:
        return 1584;
      case ExportTemplate.tiktok:
        return 1080;
      case ExportTemplate.pinterest:
        return 1000;
    }
  }

  int get height {
    switch (this) {
      case ExportTemplate.instagram:
        return 1080;
      case ExportTemplate.instagramStory:
        return 1920;
      case ExportTemplate.youtubeThumbnail:
        return 720;
      case ExportTemplate.youtubeBanner:
        return 1440;
      case ExportTemplate.facebookPost:
        return 630;
      case ExportTemplate.facebookCover:
        return 630;
      case ExportTemplate.twitterPost:
        return 512;
      case ExportTemplate.twitterHeader:
        return 500;
      case ExportTemplate.linkedinPost:
        return 627;
      case ExportTemplate.linkedinBanner:
        return 396;
      case ExportTemplate.tiktok:
        return 1920;
      case ExportTemplate.pinterest:
        return 1500;
    }
  }

  String get name => toString().split('.').last;
}

class CustomResolution {
  final int width;
  final int height;

  CustomResolution({required this.width, required this.height});
}
