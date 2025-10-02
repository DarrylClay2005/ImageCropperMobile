#!/bin/bash

# Image Cropper Mobile - Release Build Script
# This script builds a production-ready APK with proper signing

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Image Cropper Mobile - Release Build Script ===${NC}"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo "Please install Flutter: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo -e "${GREEN}✅ Flutter found${NC}"

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo -e "${BLUE}Flutter Version: ${NC}$FLUTTER_VERSION"
echo ""

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean

# Get dependencies
echo -e "${YELLOW}📦 Getting dependencies...${NC}"
flutter pub get

# Analyze code
echo -e "${YELLOW}🔍 Analyzing code...${NC}"
flutter analyze

# Run tests (if any exist)
if [ -d "test" ] && [ "$(ls -A test)" ]; then
    echo -e "${YELLOW}🧪 Running tests...${NC}"
    flutter test
else
    echo -e "${YELLOW}⚠️ No tests found - skipping test execution${NC}"
fi

# Set environment variable for API key (if not already set)
if [ -z "$UPSCALER_API_KEY" ]; then
    echo -e "${YELLOW}⚠️ UPSCALER_API_KEY environment variable not set${NC}"
    echo -e "${YELLOW}Using fallback API key from config${NC}"
    export UPSCALER_API_KEY="paat-9RAdj3vIHGONDNrL8vU1p8zhfcS"
fi

# Build release APK
echo -e "${YELLOW}🏗️ Building release APK...${NC}"
flutter build apk --release --split-per-abi

echo ""
echo -e "${GREEN}✅ Build completed successfully!${NC}"
echo ""

# Show build artifacts
echo -e "${BLUE}📱 Generated APK files:${NC}"
find build/app/outputs/flutter-apk/ -name "*.apk" -exec ls -lh {} \;

echo ""
echo -e "${GREEN}🎉 Release build completed!${NC}"
echo -e "${BLUE}APK files are located in: build/app/outputs/flutter-apk/${NC}"
echo ""

# Calculate APK sizes
echo -e "${BLUE}📊 APK Size Information:${NC}"
for apk in build/app/outputs/flutter-apk/*.apk; do
    if [ -f "$apk" ]; then
        size=$(ls -lh "$apk" | awk '{print $5}')
        basename_apk=$(basename "$apk")
        echo -e "${GREEN}  • $basename_apk: $size${NC}"
    fi
done

echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo "1. Test the APK on various devices"
echo "2. Upload to Play Store or distribute as needed"
echo "3. Create a GitHub release with the APK attached"