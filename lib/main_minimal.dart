import 'package:flutter/material.dart';

void main() {
  runApp(const ImageCropperApp());
}

class ImageCropperApp extends StatelessWidget {
  const ImageCropperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Cropper Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Cropper Pro v2.0.0'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.crop_original,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'AI-Powered Image Cropper',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'v2.0.0 - Revolutionary Edition',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '🤖 AI Image Upscaler\n✂️ Professional Cropping\n🎨 Modern UI Design\n🔒 Secure API Integration',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Full app features available in production build!'),
              backgroundColor: Colors.blue,
            ),
          );
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}