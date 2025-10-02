#!/bin/bash

# Image Cropper Mobile - Release Preparation Script
# This script prepares everything for a new release

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

VERSION=${1:-"v2.0.0"}

echo -e "${BLUE}=== Image Cropper Mobile - Release Preparation ===${NC}"
echo -e "${BLUE}Preparing release: $VERSION${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found. Please run this script from the Flutter project root.${NC}"
    exit 1
fi

# Check if git is initialized and we're in a git repo
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not in a git repository. Please initialize git first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found Flutter project${NC}"

# Check git status
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️ You have uncommitted changes:${NC}"
    git status --short
    echo ""
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Aborted by user${NC}"
        exit 1
    fi
fi

# Show current project information
echo -e "${BLUE}📱 Project Information:${NC}"
PROJECT_NAME=$(grep "^name:" pubspec.yaml | cut -d' ' -f2)
PROJECT_VERSION=$(grep "^version:" pubspec.yaml | cut -d' ' -f2)
echo -e "${GREEN}  Name: $PROJECT_NAME${NC}"
echo -e "${GREEN}  Version: $PROJECT_VERSION${NC}"
echo ""

# Create changelog entry
echo -e "${YELLOW}📝 Release Notes for $VERSION${NC}"
echo ""
cat > CHANGELOG_ENTRY.md << EOF
## [$VERSION] - $(date +%Y-%m-%d)

### ✨ New Features
- **🤖 AI Image Upscaler**: Revolutionary AI-powered image upscaling with 2x, 4x, and 8x scale factors
- **🔧 Quality Enhancement**: Advanced AI quality enhancement options for superior image results
- **📊 Progress Tracking**: Real-time progress indicators with detailed status updates
- **🔑 Secure API Management**: Environment-based API key configuration for production security

### 🎨 UI/UX Improvements
- Modern animated upscaler widget with smooth progress visualization
- Enhanced error handling with user-friendly feedback messages
- Improved settings panel for upscale configuration options
- Seamless integration with existing image cropping workflow

### 🔧 Technical Enhancements
- Robust BLoC pattern implementation for upscaler state management
- Comprehensive error handling and input validation
- Optimized image processing pipeline with better memory management
- Enhanced service architecture with proper dependency injection

### 🛠️ Developer Experience
- Added automated build and release workflow
- Improved project structure and code organization
- Enhanced documentation and inline comments
- Better testing infrastructure preparation

### 🔒 Security & Performance
- Environment-based API key configuration
- No hardcoded credentials in source code
- Secure fallback handling for API key management
- Optimized network requests with proper timeout handling

EOF

echo -e "${GREEN}✅ Release notes created${NC}"
echo ""

# Commit all changes
echo -e "${YELLOW}💾 Committing changes...${NC}"
git add .
git commit -m "feat: Add AI Image Upscaler feature for $VERSION

- Implement AI-powered image upscaling with multiple scale factors
- Add comprehensive BLoC state management for upscaler
- Create modern UI components with progress tracking
- Set up secure API key configuration
- Add automated build and release workflows
- Update documentation and release preparation

Closes: AI upscaler feature implementation
Version: $VERSION" || echo "No changes to commit"

echo -e "${GREEN}✅ Changes committed${NC}"

# Create and push tag
echo -e "${YELLOW}🏷️ Creating release tag $VERSION...${NC}"
git tag -a "$VERSION" -m "Release $VERSION - AI Image Upscaler

## What's New in $VERSION

🤖 **AI Image Upscaler**: Revolutionary new feature that uses AI to enhance and upscale images with multiple scale factors (2x, 4x, 8x)

🎨 **Enhanced UI**: Modern, animated interface with real-time progress tracking and improved user experience

🔧 **Technical Improvements**: Robust state management, better error handling, and optimized performance

🔒 **Security**: Secure API key management and environment-based configuration

This release represents a major step forward in AI-powered image processing capabilities!"

echo -e "${GREEN}✅ Tag created: $VERSION${NC}"

# Show next steps
echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "1. Push the tag to trigger automated build:"
echo -e "   ${YELLOW}git push origin $VERSION${NC}"
echo ""
echo "2. Monitor GitHub Actions for build completion:"
echo -e "   ${YELLOW}https://github.com/$(git config remote.origin.url | sed 's/.*github.com[:/]\([^/]*\/[^/]*\).*/\1/' | sed 's/\.git$//')/actions${NC}"
echo ""
echo "3. The release will be automatically created with APK files"
echo ""
echo "4. Optionally, run local build to test:"
echo -e "   ${YELLOW}./build_release.sh${NC}"
echo ""

# Show git information
echo -e "${BLUE}📊 Git Status:${NC}"
echo -e "${GREEN}  Current Branch: $(git branch --show-current)${NC}"
echo -e "${GREEN}  Latest Commit: $(git log -1 --oneline)${NC}"
echo -e "${GREEN}  Latest Tag: $VERSION${NC}"
echo ""

echo -e "${GREEN}🎉 Release preparation completed!${NC}"
echo -e "${YELLOW}Push the tag when you're ready to trigger the automated build and release.${NC}"