# Image Shape Cropper Mobile 📱✂️

<div align="center">

![Kowalski Icon](assets/images/kowalski.png)

**Professional Image Cropping Tool for Android**  
*Made by Darryl Clay - HeavenlyCodingPalace*

[![Platform](https://img.shields.io/badge/platform-Android-green?style=for-the-badge)](https://android.com)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue?style=for-the-badge)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-orange?style=for-the-badge)](#)

</div>

---

## 🌟 Features

**Image Shape Cropper Mobile** is a modern, native Android application that allows you to crop your images into beautiful, creative shapes with an intuitive mobile-first interface and smooth user experience.

### ✨ Available Crop Shapes
- **Circle** ● - Perfect for profile pictures and avatars
- **Square** ■ - Clean square crops for social media
- **Heart** ♥ - Romantic heart shapes for special moments
- **Star** ★ - Eye-catching 5-pointed star designs
- **Hexagon** ⬢ - Modern geometric hexagonal crops
- **Diamond** ♦ - Elegant diamond-cut appearance

### 📱 Mobile-Optimized Features
- **Native Android Experience** - Built with Flutter for smooth performance
- **Dark Theme Interface** - Easy on the eyes with HeavenlyCodingPalace branding
- **Touch-Friendly UI** - Optimized for mobile interaction
- **Camera & Gallery Support** - Select images from gallery or take new photos
- **Progress Animations** - Beautiful loading indicators and smooth transitions
- **Kowalski Mascot** - Featuring the beloved penguin throughout the app! 🐧

### 🎨 Technical Excellence
- **High-Quality Processing** - Advanced image algorithms for perfect crops
- **Multiple Formats** - Support for JPG, PNG, GIF, BMP
- **Memory Optimized** - Efficient handling of large images
- **Permission Management** - Smart handling of camera and storage permissions

---

## 📱 Screenshots

### Splash Screen
*Beautiful animated loading with Kowalski and company branding*

### Main Interface
*Clean, dark-themed mobile interface with shape selection*

### Crop Results
*High-quality crops with transparent backgrounds*

---

## 🚀 Installation

### Prerequisites
- Android 5.0 (API level 21) or higher
- ~50MB available storage
- Camera permission (for taking photos)
- Storage permission (for saving images)

### Download Options

#### Option 1: APK Release (Recommended)
1. Download the latest APK from [Releases](https://github.com/DarrylClay2005/Image-Cropper-Mobile/releases)
2. Enable "Unknown Sources" in Android Settings
3. Install the APK file
4. Launch "Image Shape Cropper" from your app drawer

#### Option 2: Build from Source
```bash
git clone https://github.com/DarrylClay2005/Image-Cropper-Mobile.git
cd Image-Cropper-Mobile
flutter pub get
flutter build apk --release
```

---

## 🎯 How to Use

### Quick Start Guide

1. **Launch the App**
   - Open "Image Shape Cropper" from your app drawer
   - Enjoy the beautiful Kowalski splash screen

2. **Select an Image**
   - Tap "Select Image" on the main screen
   - Choose "Gallery" to pick existing photos or "Camera" to take new ones
   - Grant camera/storage permissions when prompted

3. **Choose Your Shape**
   - Browse the 6 available crop shapes
   - Tap any shape to select it (Circle is selected by default)
   - Each shape shows an icon and description

4. **Crop Your Image**
   - Tap "Crop [Shape Name]" to start the cropping process
   - Watch the beautiful progress animation
   - The cropped image will replace the original in the preview

5. **Save Your Creation**
   - Tap "Save" to export your cropped image
   - The image is saved to your device storage
   - Success dialog shows the save location

6. **Additional Options**
   - "Reset" - Return to the original image to try different shapes
   - "Clear" - Remove the current image and start fresh

### Pro Tips
- **Best Quality**: PNG format preserves transparency for shaped crops
- **Performance**: Works great with images up to 4MP
- **Creative Uses**: Perfect for profile pics, social media, artistic effects

---

## 🛠️ System Requirements

### Minimum Requirements
- **Android**: 5.0 (API level 21) or higher
- **RAM**: 2GB minimum (4GB recommended)
- **Storage**: 50MB free space
- **Camera**: Optional, for taking new photos

### Optimal Performance
- **Android**: 8.0+ for best experience
- **RAM**: 4GB+ for large image processing
- **Storage**: 100MB+ for multiple saved images

---

## 🏗️ Development

### Technology Stack
- **Framework**: Flutter 3.10+
- **Language**: Dart 3.0+
- **Image Processing**: dart:image library
- **State Management**: Provider pattern
- **UI Components**: Material Design 3

### Architecture
```
lib/
├── main.dart                 # App entry point
├── models/
│   └── crop_shape.dart       # Shape definitions
├── screens/
│   ├── splash_screen.dart    # Animated splash
│   └── home_screen.dart      # Main interface
├── services/
│   └── image_service.dart    # Image processing logic
├── widgets/
│   ├── shape_selection_widget.dart    # Shape picker
│   ├── image_preview_widget.dart      # Image display
│   └── action_buttons_widget.dart     # Control buttons
└── utils/
    └── app_theme.dart        # HeavenlyCodingPalace styling
```

### Building from Source

#### Prerequisites
- Flutter 3.10+ installed
- Android Studio / VS Code
- Android SDK configured

#### Build Commands
```bash
# Get dependencies
flutter pub get

# Debug build
flutter run

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### Development Setup
```bash
git clone https://github.com/DarrylClay2005/Image-Cropper-Mobile.git
cd Image-Cropper-Mobile
flutter pub get
flutter run
```

---

## 🎨 Design Philosophy

### Visual Design
- **Dark Theme**: Professional blue (#00d4ff) on dark backgrounds
- **Mobile-First**: Designed specifically for touch interaction
- **Material Design 3**: Following Android design guidelines
- **Kowalski Branding**: Consistent penguin mascot throughout

### User Experience
- **Intuitive Flow**: Select → Crop → Save workflow
- **Visual Feedback**: Animations and progress indicators
- **Error Handling**: Graceful error recovery with clear messages
- **Permission Management**: Smart handling of sensitive permissions

### Performance
- **Memory Efficient**: Optimized for mobile devices
- **Background Processing**: Non-blocking UI during operations
- **Image Optimization**: Smart resizing and compression

---

## 📋 Permissions

The app requests the following permissions:

### Required Permissions
- **INTERNET** - For potential future online features
- **READ_EXTERNAL_STORAGE** - To access gallery images
- **READ_MEDIA_IMAGES** - Android 13+ media access

### Optional Permissions
- **CAMERA** - To take new photos (only requested when using camera)
- **WRITE_EXTERNAL_STORAGE** - To save cropped images (Android 10+)

### Privacy Notice
- All image processing happens locally on your device
- No images are uploaded to external servers
- No personal data is collected or transmitted

---

## 🔮 Roadmap

### Version 1.1 (Planned)
- [ ] Batch processing multiple images
- [ ] Custom crop sizes and ratios
- [ ] Image filters and effects
- [ ] Share directly to social media
- [ ] Cloud storage integration

### Version 1.2 (Future)
- [ ] Custom shape uploads (SVG support)
- [ ] Advanced editing tools
- [ ] Widget for home screen
- [ ] Multi-language support

---

## 🤝 Contributing

We welcome contributions from the community!

### How to Contribute
1. Fork the repository
2. Create a feature branch: `git checkout -b amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin amazing-feature`
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guidelines
- Maintain the HeavenlyCodingPalace design theme
- Test on multiple Android versions
- Update documentation for new features

---

## 🐛 Bug Reports & Support

- **Issues**: [GitHub Issues](https://github.com/DarrylClay2005/Image-Cropper-Mobile/issues)
- **Feature Requests**: [GitHub Discussions](https://github.com/DarrylClay2005/Image-Cropper-Mobile/discussions)

### Common Issues
- **Permissions**: Grant camera/storage permissions in Android Settings
- **Large Images**: Try smaller images if processing seems slow
- **Crashes**: Restart the app and try again

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
Copyright (c) 2024 Darryl Clay - HeavenlyCodingPalace
```

---

## 🏢 About HeavenlyCodingPalace

**HeavenlyCodingPalace** creates professional mobile and desktop applications with beautiful, user-friendly interfaces. Our mission is to make powerful tools accessible to everyone, everywhere.

### Our Apps
- **Image Shape Cropper** (Desktop) - Linux application
- **Image Shape Cropper Mobile** (Android) - This app
- More amazing apps coming soon!

---

## 🙏 Acknowledgments

- **Flutter Team** - Amazing cross-platform framework
- **Dart Image Library** - Powerful image processing
- **Material Design** - Beautiful Android design system
- **Kowalski** - For being an awesome mascot! 🐧
- **Open Source Community** - Tools that made this possible

---

## 📊 Stats

<div align="center">

![GitHub stars](https://img.shields.io/github/stars/DarrylClay2005/Image-Cropper-Mobile?style=social)
![GitHub forks](https://img.shields.io/github/forks/DarrylClay2005/Image-Cropper-Mobile?style=social)
![GitHub downloads](https://img.shields.io/github/downloads/DarrylClay2005/Image-Cropper-Mobile/total?style=social)

</div>

---

<div align="center">

**Made with ❤️ by Darryl Clay - HeavenlyCodingPalace**

*Create beautiful cropped images on the go with professional quality!* ✨📱

</div>
