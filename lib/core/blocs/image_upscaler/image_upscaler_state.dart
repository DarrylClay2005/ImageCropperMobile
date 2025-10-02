part of 'image_upscaler_bloc.dart';

class ImageUpscalerState extends Equatable {
  final UpscaleStatus status;
  final File? upscaledImage;
  final double progress;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;
  final bool isApiKeyValid;
  final List<int> supportedScaleFactors;

  const ImageUpscalerState({
    this.status = UpscaleStatus.idle,
    this.upscaledImage,
    this.progress = 0.0,
    this.errorMessage,
    this.metadata,
    this.isApiKeyValid = true,
    this.supportedScaleFactors = const [2, 4, 8],
  });

  ImageUpscalerState copyWith({
    UpscaleStatus? status,
    File? upscaledImage,
    double? progress,
    String? errorMessage,
    Map<String, dynamic>? metadata,
    bool? isApiKeyValid,
    List<int>? supportedScaleFactors,
  }) {
    return ImageUpscalerState(
      status: status ?? this.status,
      upscaledImage: upscaledImage ?? this.upscaledImage,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
      isApiKeyValid: isApiKeyValid ?? this.isApiKeyValid,
      supportedScaleFactors: supportedScaleFactors ?? this.supportedScaleFactors,
    );
  }

  bool get isLoading => 
      status == UpscaleStatus.uploading || 
      status == UpscaleStatus.processing || 
      status == UpscaleStatus.downloading;
  
  bool get hasError => status == UpscaleStatus.error;
  bool get isCompleted => status == UpscaleStatus.completed;
  bool get hasUpscaledImage => upscaledImage != null;

  String get statusMessage {
    switch (status) {
      case UpscaleStatus.idle:
        return 'Ready to upscale image';
      case UpscaleStatus.uploading:
        return 'Uploading image... ${(progress * 100).toInt()}%';
      case UpscaleStatus.processing:
        return 'AI processing image... ${(progress * 100).toInt()}%';
      case UpscaleStatus.downloading:
        return 'Downloading result... ${(progress * 100).toInt()}%';
      case UpscaleStatus.completed:
        return 'Image upscaled successfully!';
      case UpscaleStatus.error:
        return errorMessage ?? 'An error occurred';
    }
  }

  String get progressDescription {
    switch (status) {
      case UpscaleStatus.uploading:
        return 'Uploading your image to our AI servers';
      case UpscaleStatus.processing:
        return 'AI is enhancing your image quality';
      case UpscaleStatus.downloading:
        return 'Downloading your enhanced image';
      case UpscaleStatus.completed:
        return 'Your image has been successfully enhanced';
      case UpscaleStatus.error:
        return 'Something went wrong during processing';
      default:
        return 'Select an image to start upscaling';
    }
  }

  @override
  List<Object?> get props => [
        status,
        upscaledImage,
        progress,
        errorMessage,
        metadata,
        isApiKeyValid,
        supportedScaleFactors,
      ];
}