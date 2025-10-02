part of 'image_cropper_bloc.dart';

enum ImageCropperStatus {
  initial,
  picking,
  imageSelected,
  processing,
  cropped,
  saving,
  saved,
  error,
}

class ImageCropperState extends Equatable {
  final ImageCropperStatus status;
  final File? originalImage;
  final File? croppedImage;
  final CropShape selectedShape;
  final ExportTemplate? selectedTemplate;
  final int? customWidth;
  final int? customHeight;
  final double progress;
  final String? errorMessage;
  final String? savedPath;

  const ImageCropperState({
    this.status = ImageCropperStatus.initial,
    this.originalImage,
    this.croppedImage,
    this.selectedShape = CropShape.circle,
    this.selectedTemplate,
    this.customWidth,
    this.customHeight,
    this.progress = 0.0,
    this.errorMessage,
    this.savedPath,
  });

  ImageCropperState copyWith({
    ImageCropperStatus? status,
    File? originalImage,
    File? croppedImage,
    CropShape? selectedShape,
    ExportTemplate? selectedTemplate,
    int? customWidth,
    int? customHeight,
    double? progress,
    String? errorMessage,
    String? savedPath,
  }) {
    return ImageCropperState(
      status: status ?? this.status,
      originalImage: originalImage ?? this.originalImage,
      croppedImage: croppedImage ?? this.croppedImage,
      selectedShape: selectedShape ?? this.selectedShape,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      customWidth: customWidth ?? this.customWidth,
      customHeight: customHeight ?? this.customHeight,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      savedPath: savedPath ?? this.savedPath,
    );
  }

  bool get hasImage => originalImage != null;
  bool get hasCroppedImage => croppedImage != null;
  bool get isProcessing => status == ImageCropperStatus.processing;
  bool get isSaving => status == ImageCropperStatus.saving;
  bool get isLoading => isProcessing || isSaving || status == ImageCropperStatus.picking;
  bool get hasError => status == ImageCropperStatus.error;
  bool get canCrop => hasImage && !isLoading;
  bool get canSave => hasCroppedImage && !isLoading;

  int get outputWidth {
    if (customWidth != null) return customWidth!;
    if (selectedTemplate != null) return selectedTemplate!.width;
    return 1080; // Default
  }

  int get outputHeight {
    if (customHeight != null) return customHeight!;
    if (selectedTemplate != null) return selectedTemplate!.height;
    return 1080; // Default
  }

  String get outputResolution => '${outputWidth}x${outputHeight}';

  String get statusMessage {
    switch (status) {
      case ImageCropperStatus.initial:
        return 'Select an image to get started';
      case ImageCropperStatus.picking:
        return 'Loading image...';
      case ImageCropperStatus.imageSelected:
        return 'Image loaded! Choose a shape and crop';
      case ImageCropperStatus.processing:
        return 'Processing image... ${(progress * 100).toInt()}%';
      case ImageCropperStatus.cropped:
        return 'Image cropped successfully!';
      case ImageCropperStatus.saving:
        return 'Saving image... ${(progress * 100).toInt()}%';
      case ImageCropperStatus.saved:
        return 'Image saved successfully!';
      case ImageCropperStatus.error:
        return errorMessage ?? 'An error occurred';
    }
  }

  @override
  List<Object?> get props => [
        status,
        originalImage,
        croppedImage,
        selectedShape,
        selectedTemplate,
        customWidth,
        customHeight,
        progress,
        errorMessage,
        savedPath,
      ];
}