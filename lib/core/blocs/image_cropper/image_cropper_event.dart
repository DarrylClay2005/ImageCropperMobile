part of 'image_cropper_bloc.dart';

abstract class ImageCropperEvent extends Equatable {
  const ImageCropperEvent();

  @override
  List<Object?> get props => [];
}

enum ImageSource { gallery, camera, files }

class PickImageEvent extends ImageCropperEvent {
  final ImageSource source;

  const PickImageEvent(this.source);

  @override
  List<Object?> get props => [source];
}

class CropImageEvent extends ImageCropperEvent {
  const CropImageEvent();
}

class SaveImageEvent extends ImageCropperEvent {
  final String? path;

  const SaveImageEvent({this.path});

  @override
  List<Object?> get props => [path];
}

class SelectShapeEvent extends ImageCropperEvent {
  final CropShape shape;

  const SelectShapeEvent(this.shape);

  @override
  List<Object?> get props => [shape];
}

class SelectTemplateEvent extends ImageCropperEvent {
  final ExportTemplate? template;

  const SelectTemplateEvent(this.template);

  @override
  List<Object?> get props => [template];
}

class SetCustomResolutionEvent extends ImageCropperEvent {
  final int width;
  final int height;

  const SetCustomResolutionEvent({
    required this.width,
    required this.height,
  });

  @override
  List<Object?> get props => [width, height];
}

class ResetImageEvent extends ImageCropperEvent {
  const ResetImageEvent();
}

class ClearAllEvent extends ImageCropperEvent {
  const ClearAllEvent();
}

class UpdateProgressEvent extends ImageCropperEvent {
  final double progress;

  const UpdateProgressEvent(this.progress);

  @override
  List<Object?> get props => [progress];
}