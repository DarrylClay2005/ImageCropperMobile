import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

// BLoCs
import '../blocs/theme/theme_bloc.dart';
import '../blocs/image_cropper/image_cropper_bloc.dart';
import '../blocs/image_upscaler/image_upscaler_bloc.dart';

// Services
import '../storage/storage_service.dart';
import '../storage/cache_service.dart';
import '../analytics/analytics_service.dart';
import 'image_upscaler_service.dart';

class SimpleServiceLocator {
  static final SimpleServiceLocator _instance = SimpleServiceLocator._internal();
  static SimpleServiceLocator get instance => _instance;

  SimpleServiceLocator._internal();

  final GetIt _getIt = GetIt.instance;

  T call<T extends Object>() => _getIt<T>();

  Future<void> init() async {
    // External dependencies
    final sharedPreferences = await SharedPreferences.getInstance();
    final hiveBox = await Hive.openBox('app_storage');

    _getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    _getIt.registerSingleton<Box>(hiveBox);

    // Core services
    _getIt.registerLazySingleton<StorageService>(
      () => StorageServiceImpl(sharedPreferences),
    );

    _getIt.registerLazySingleton<CacheService>(
      () => CacheServiceImpl(hiveBox),
    );

    _getIt.registerLazySingleton<AnalyticsService>(
      () => AnalyticsServiceImpl(),
    );

    _getIt.registerLazySingleton<ImageUpscalerService>(
      () => ImageUpscalerServiceImpl(),
    );

    // BLoCs
    _getIt.registerFactory<ThemeBloc>(
      () => ThemeBloc(_getIt<StorageService>()),
    );

    _getIt.registerFactory<ImageCropperBloc>(
      () => ImageCropperBloc(
        pickImageUsecase: null, // Mock implementation
        cropImageUsecase: null, // Mock implementation
        saveImageUsecase: null, // Mock implementation
        analyticsService: _getIt<AnalyticsService>(),
      ),
    );

    _getIt.registerFactory<ImageUpscalerBloc>(
      () => ImageUpscalerBloc(
        upscalerService: _getIt<ImageUpscalerService>(),
        analyticsService: _getIt<AnalyticsService>(),
      ),
    );
  }

  void reset() {
    _getIt.reset();
  }
}