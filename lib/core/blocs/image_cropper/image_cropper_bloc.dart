import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/crop_shape.dart';
import '../../models/export_template.dart';
import '../../analytics/analytics_service.dart';

part 'image_cropper_event.dart';
part 'image_cropper_state.dart';

class ImageCropperBloc extends Bloc<ImageCropperEvent, ImageCropperState> {
  final AnalyticsService _analyticsService;

  // Mock use cases - these would be properly injected in a real implementation
  final dynamic pickImageUsecase;
  final dynamic cropImageUsecase;
  final dynamic saveImageUsecase;

  ImageCropperBloc({
    required this.pickImageUsecase,
    required this.cropImageUsecase,
    required this.saveImageUsecase,
    required AnalyticsService analyticsService,
  })  : _analyticsService = analyticsService,
        super(const ImageCropperState()) {
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
      await _analyticsService.logEvent('image_pick_started', {
        'source': event.source.name,
      });

      // Simulate image picking
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Mock successful image picking
      emit(state.copyWith(
        status: ImageCropperStatus.imageSelected,
        originalImage: File('/mock/path/image.jpg'), // Mock file
        croppedImage: null,
      ));

      await _analyticsService.logEvent('image_pick_success', {
        'source': event.source.name,
      });
    } catch (error) {
      emit(state.copyWith(
        status: ImageCropperStatus.error,
        errorMessage: error.toString(),
      ));

      await _analyticsService.logError('image_pick_error', error.toString());
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
      await _analyticsService.logEvent('image_crop_started', {
        'shape': state.selectedShape.name,
        'template': state.selectedTemplate?.name,
        'custom_width': state.customWidth,
        'custom_height': state.customHeight,
      });

      // Simulate progress updates
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        emit(state.copyWith(progress: i / 100));
      }

      // Mock successful cropping
      emit(state.copyWith(
        status: ImageCropperStatus.cropped,
        croppedImage: File('/mock/path/cropped_image.jpg'), // Mock file
        progress: 0.0,
      ));

      await _analyticsService.logEvent('image_crop_success', {
        'shape': state.selectedShape.name,
        'template': state.selectedTemplate?.name,
      });
    } catch (error) {
      emit(state.copyWith(
        status: ImageCropperStatus.error,
        errorMessage: error.toString(),
        progress: 0.0,
      ));

      await _analyticsService.logError('image_crop_error', error.toString());
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
      await _analyticsService.logEvent('image_save_started', {
        'path': event.path,
        'shape': state.selectedShape.name,
        'template': state.selectedTemplate?.name,
      });

      // Simulate saving progress
      for (int i = 0; i <= 100; i += 20) {
        await Future.delayed(const Duration(milliseconds: 150));
        emit(state.copyWith(progress: i / 100));
      }

      emit(state.copyWith(
        status: ImageCropperStatus.saved,
        savedPath: event.path,
        progress: 0.0,
      ));

      await _analyticsService.logEvent('image_save_success', {
        'path': event.path,
        'shape': state.selectedShape.name,
      });
    } catch (error) {
      emit(state.copyWith(
        status: ImageCropperStatus.error,
        errorMessage: error.toString(),
        progress: 0.0,
      ));

      await _analyticsService.logError('image_save_error', error.toString());
    }
  }

  void _onSelectShape(SelectShapeEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(
      selectedShape: event.shape,
      croppedImage: null, // Clear cropped image when shape changes
    ));

    _analyticsService.logEvent('shape_selected', {
      'shape': event.shape.name,
    });
  }

  void _onSelectTemplate(SelectTemplateEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(
      selectedTemplate: event.template,
      customWidth: null,
      customHeight: null,
      croppedImage: null, // Clear cropped image when template changes
    ));

    _analyticsService.logEvent('template_selected', {
      'template': event.template?.name ?? 'none',
      'category': event.template?.category,
    });
  }

  void _onSetCustomResolution(SetCustomResolutionEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(
      customWidth: event.width,
      customHeight: event.height,
      selectedTemplate: null, // Clear template when custom resolution is set
      croppedImage: null, // Clear cropped image when resolution changes
    ));

    _analyticsService.logEvent('custom_resolution_set', {
      'width': event.width,
      'height': event.height,
    });
  }

  void _onResetImage(ResetImageEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(
      croppedImage: null,
      status: ImageCropperStatus.imageSelected,
      errorMessage: null,
      progress: 0.0,
      savedPath: null,
    ));

    _analyticsService.logEvent('image_reset', {});
  }

  void _onClearAll(ClearAllEvent event, Emitter<ImageCropperState> emit) {
    emit(const ImageCropperState());

    _analyticsService.logEvent('all_cleared', {});
  }

  void _onUpdateProgress(UpdateProgressEvent event, Emitter<ImageCropperState> emit) {
    emit(state.copyWith(progress: event.progress));
  }
}