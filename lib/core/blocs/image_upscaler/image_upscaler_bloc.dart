import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/image_upscaler_service.dart';

part 'image_upscaler_event.dart';
part 'image_upscaler_state.dart';

class ImageUpscalerBloc extends Bloc<ImageUpscalerEvent, ImageUpscalerState> {
  final ImageUpscalerService _upscalerService;

  ImageUpscalerBloc({
    required ImageUpscalerService upscalerService,
  })  : _upscalerService = upscalerService,
        super(const ImageUpscalerState()) {
    on<UpscaleImageEvent>(_onUpscaleImage);
    on<UpdateUpscaleProgressEvent>(_onUpdateProgress);
    on<ResetUpscalerEvent>(_onResetUpscaler);
    on<ValidateApiKeyEvent>(_onValidateApiKey);
    on<LoadSupportedScaleFactorsEvent>(_onLoadSupportedScaleFactors);
    
    // Load supported scale factors on initialization
    add(const LoadSupportedScaleFactorsEvent());
  }

  void _onUpscaleImage(UpscaleImageEvent event, Emitter<ImageUpscalerState> emit) async {
    emit(state.copyWith(
      status: UpscaleStatus.uploading,
      progress: 0.0,
      errorMessage: null,
      upscaledImage: null,
    ));

    try {

      final result = await _upscalerService.upscaleImage(
        imageFile: event.imageFile,
        scaleFactor: event.scaleFactor,
        enhanceQuality: event.enhanceQuality,
        onProgress: (progress) {
          add(UpdateUpscaleProgressEvent(progress));
        },
      );

      if (result.success && result.upscaledImage != null) {
        emit(state.copyWith(
          status: UpscaleStatus.completed,
          upscaledImage: result.upscaledImage,
          progress: 1.0,
          metadata: result.metadata,
        ));

      } else {
        emit(state.copyWith(
          status: UpscaleStatus.error,
          errorMessage: result.errorMessage ?? 'Unknown error occurred',
          progress: 0.0,
        ));

      }
    } catch (error) {
      emit(state.copyWith(
        status: UpscaleStatus.error,
        errorMessage: error.toString(),
        progress: 0.0,
      ));

    }
  }

  void _onUpdateProgress(UpdateUpscaleProgressEvent event, Emitter<ImageUpscalerState> emit) {
    UpscaleStatus newStatus;
    if (event.progress <= 0.3) {
      newStatus = UpscaleStatus.uploading;
    } else if (event.progress <= 0.7) {
      newStatus = UpscaleStatus.processing;
    } else if (event.progress < 1.0) {
      newStatus = UpscaleStatus.downloading;
    } else {
      newStatus = UpscaleStatus.completed;
    }

    emit(state.copyWith(
      progress: event.progress,
      status: newStatus,
    ));
  }

  void _onResetUpscaler(ResetUpscalerEvent event, Emitter<ImageUpscalerState> emit) {
    emit(const ImageUpscalerState());
  }

  void _onValidateApiKey(ValidateApiKeyEvent event, Emitter<ImageUpscalerState> emit) async {
    try {
      final isValid = await _upscalerService.validateApiKey();
      emit(state.copyWith(isApiKeyValid: isValid));
      
      if (!isValid) {
        emit(state.copyWith(
          status: UpscaleStatus.error,
          errorMessage: 'Invalid API key. Please check your configuration.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isApiKeyValid: false,
        status: UpscaleStatus.error,
        errorMessage: 'Failed to validate API key: $e',
      ));
    }
  }

  void _onLoadSupportedScaleFactors(LoadSupportedScaleFactorsEvent event, Emitter<ImageUpscalerState> emit) async {
    try {
      final scaleFactors = await _upscalerService.getSupportedScaleFactors();
      emit(state.copyWith(supportedScaleFactors: scaleFactors));
    } catch (e) {
      // Use default scale factors on error
      emit(state.copyWith(supportedScaleFactors: [2, 4, 8]));
    }
  }
}