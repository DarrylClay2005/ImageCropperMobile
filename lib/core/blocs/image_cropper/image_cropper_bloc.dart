import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart' as picker;

import '../../models/crop_shape.dart';
import '../../models/export_template.dart';
import '../../../services/image_service.dart';

part 'image_cropper_event.dart';
part 'image_cropper_state.dart';

class ImageCropperBloc extends Bloc<ImageCropperEvent, ImageCropperState> {
  final ImageService _imageService;
  final picker.ImagePicker _imagePicker = picker.ImagePicker();

  ImageCropperBloc(this._imageService) : super(const ImageCropperState()) {
    on<PickImageEvent>(_onPickImage);
    on<CropImageEvent>(_onCropImage);
    on<SaveImageEvent>(_onSaveImage);
    on<SelectShapeEvent>(_onSelectShape);
    on<SelectTemplateEvent>(_onSelectTemplate);
    on<SetCustomResolutionEvent>(_onSetCustomResolution);
    on<ResetImageEvent>(_onResetImage);
    on<ClearAllEvent>(_onClearAll);
    on<UpdateProgressEvent>(_onUpdateProgress);
  }

  void _onPickImage(PickImageEvent event, Emitter<ImageCropperState> emit) async {
    emit(state.copyWith(
      status: ImageCropperStatus.picking,
      errorMessage: null,
    ));

    try {
      picker.ImageSource source;
      switch (event.source) {
        case AppImageSource.gallery:
          source = picker.ImageSource.gallery;
          break;
        case AppImageSource.camera:
          source = picker.ImageSource.camera;
          break;
        case AppImageSource.files:
          // For file picker, use gallery as fallback
          source = picker.ImageSource.gallery;
          break;
      }

      final picker.XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 95,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        emit(state.copyWith(
          status: ImageCropperStatus.imageSelected,
          originalImage: imageFile,
          croppedImage: null,
        ));
      } else {
        // User cancelled selection
        emit(state.copyWith(
          status: ImageCropperStatus.initial,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: ImageCropperStatus.error,
        errorMessage: 'Failed to pick image: ${error.toString()}',
      ));
    }
  }

  void _onCropImage(CropImageEvent event, Emitter<ImageCropperState> emit) async {
    if (state.originalImage == null) return;

    emit(state.copyWith(
      status: ImageCropperStatus.processing,
      progress: 0.0,
      errorMessage: null,
    ));

    try {
      // Set the selected shape in the service
      _imageService.setShape(state.selectedShape);
      
      // Load the image into the service
      _imageService.setOriginalImage(state.originalImage);
      
      // Progress updates
      emit(state.copyWith(progress: 0.2));
      await Future.delayed(const Duration(milliseconds: 300));
      
      emit(state.copyWith(progress: 0.5));
      await Future.delayed(const Duration(milliseconds: 400));
      
      // Perform the actual cropping
      await _imageService.cropImage();
      
      emit(state.copyWith(progress: 0.8));
      await Future.delayed(const Duration(milliseconds: 200));
      
      emit(state.copyWith(progress: 1.0));
      await Future.delayed(const Duration(milliseconds: 100));

      // Update state with cropped image
      emit(state.copyWith(
        status: ImageCropperStatus.cropped,
        croppedImage: _imageService.croppedImage,
        progress: 0.0,
      ));

    } catch (error) {
      emit(state.copyWith(
        status: ImageCropperStatus.error,
        errorMessage: 'Failed to crop image: ${error.toString()}',
        progress: 0.0,
      ));
    }
  }

  void _onSaveImage(SaveImageEvent event, Emitter<ImageCropperState> emit) async {
    if (state.croppedImage == null) return;

    emit(state.copyWith(
      status: ImageCropperStatus.saving,
      progress: 0.0,
      errorMessage: null,
    ));

    try {
      // Set the cropped image in service
      _imageService.setCroppedImage(state.croppedImage);
      
      emit(state.copyWith(progress: 0.3));
      await Future.delayed(const Duration(milliseconds: 200));
      
      emit(state.copyWith(progress: 0.6));
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Perform actual saving
      final savedPath = await _imageService.saveImage();
      
      emit(state.copyWith(progress: 1.0));
      await Future.delayed(const Duration(milliseconds: 100));

      emit(state.copyWith(
        status: ImageCropperStatus.saved,
        savedPath: savedPath,
        progress: 0.0,
      ));

    } catch (error) {
      emit(state.copyWith(
        status: ImageCropperStatus.error,
        errorMessage: 'Failed to save image: ${error.toString()}',
        progress: 0.0,
      ));
    }
  }

  void _onSelectShape(SelectShapeEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(
      selectedShape: event.shape,
      croppedImage: null, // Clear cropped image when shape changes
    ));

  }

  void _onSelectTemplate(SelectTemplateEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(
      selectedTemplate: event.template,
      customWidth: null,
      customHeight: null,
      croppedImage: null, // Clear cropped image when template changes
    ));

  }

  void _onSetCustomResolution(SetCustomResolutionEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(
      customWidth: event.width,
      customHeight: event.height,
      selectedTemplate: null, // Clear template when custom resolution is set
      croppedImage: null, // Clear cropped image when resolution changes
    ));

  }

  void _onResetImage(ResetImageEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(
      croppedImage: null,
      status: ImageCropperStatus.imageSelected,
      errorMessage: null,
      progress: 0.0,
      savedPath: null,
    ));

    // Event logged
  }

  void _onClearAll(ClearAllEvent event, Emitter<ImageCropperState> emit) {
    emit(const ImageCropperState());

    // Event logged
  }

  void _onUpdateProgress(UpdateProgressEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(progress: event.progress));
  }
}