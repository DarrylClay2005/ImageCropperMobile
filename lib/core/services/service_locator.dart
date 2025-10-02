import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

// BLoCs
import '../blocs/theme/theme_bloc.dart';
import '../blocs/image_cropper/image_cropper_bloc.dart';

// Services
import '../../features/image_processing/data/repositories/image_repository_impl.dart';
import '../../features/image_processing/domain/repositories/image_repository.dart';
import '../../features/image_processing/domain/usecases/crop_image_usecase.dart';
import '../../features/image_processing/domain/usecases/pick_image_usecase.dart';
import '../../features/image_processing/domain/usecases/save_image_usecase.dart';
import '../../features/image_processing/data/datasources/image_local_datasource.dart';
import '../storage/storage_service.dart';
import '../storage/cache_service.dart';
import '../analytics/analytics_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  static ServiceLocator get instance => _instance;

  ServiceLocator._internal();

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

    // Data sources
    _getIt.registerLazySingleton<ImageLocalDatasource>(
      () => ImageLocalDatasourceImpl(_getIt<StorageService>()),
    );

    // Repositories
    _getIt.registerLazySingleton<ImageRepository>(
      () => ImageRepositoryImpl(_getIt<ImageLocalDatasource>()),
    );

    // Use cases
    _getIt.registerLazySingleton<PickImageUsecase>(
      () => PickImageUsecase(_getIt<ImageRepository>()),
    );

    _getIt.registerLazySingleton<CropImageUsecase>(
      () => CropImageUsecase(_getIt<ImageRepository>()),
    );

    _getIt.registerLazySingleton<SaveImageUsecase>(
      () => SaveImageUsecase(_getIt<ImageRepository>()),
    );

    // BLoCs
    _getIt.registerFactory<ThemeBloc>(
      () => ThemeBloc(_getIt<StorageService>()),
    );

    _getIt.registerFactory<ImageCropperBloc>(
      () => ImageCropperBloc(
        pickImageUsecase: _getIt<PickImageUsecase>(),
        cropImageUsecase: _getIt<CropImageUsecase>(),
        saveImageUsecase: _getIt<SaveImageUsecase>(),
        analyticsService: _getIt<AnalyticsService>(),
      ),
    );
  }

  void reset() {
    _getIt.reset();
  }
}