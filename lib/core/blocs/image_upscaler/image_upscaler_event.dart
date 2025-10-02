part of 'image_upscaler_bloc.dart';

abstract class ImageUpscalerEvent extends Equatable {
  const ImageUpscalerEvent();

  @override
  List<Object?> get props => [];
}

class UpscaleImageEvent extends ImageUpscalerEvent {
  final File imageFile;
  final int scaleFactor;
  final bool enhanceQuality;

  const UpscaleImageEvent({
    required this.imageFile,
    this.scaleFactor = 2,
    this.enhanceQuality = true,
  });

  @override
  List<Object?> get props => [imageFile, scaleFactor, enhanceQuality];
}

class UpdateUpscaleProgressEvent extends ImageUpscalerEvent {
  final double progress;

  const UpdateUpscaleProgressEvent(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ResetUpscalerEvent extends ImageUpscalerEvent {
  const ResetUpscalerEvent();
}

class ValidateApiKeyEvent extends ImageUpscalerEvent {
  const ValidateApiKeyEvent();
}

class LoadSupportedScaleFactorsEvent extends ImageUpscalerEvent {
  const LoadSupportedScaleFactorsEvent();
}