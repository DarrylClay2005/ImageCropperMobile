import 'package:shared_preferences/shared_preferences.dart';

// Services
import 'image_upscaler_service.dart';

class SimpleServiceLocator {
  static final SimpleServiceLocator _instance = SimpleServiceLocator._internal();
  static SimpleServiceLocator get instance => _instance;

  SimpleServiceLocator._internal();

  SharedPreferences? _sharedPreferences;
  ImageUpscalerService? _upscalerService;

  T call<T extends Object>() {
    if (T == SharedPreferences) {
      return _sharedPreferences as T;
    } else if (T == ImageUpscalerService) {
      return _upscalerService as T;
    }
    throw Exception('Service not registered: $T');
  }

  Future<void> init() async {
    // Initialize SharedPreferences
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      print('Failed to initialize SharedPreferences: $e');
    }

    // Initialize ImageUpscalerService
    _upscalerService = ImageUpscalerServiceImpl();
  }

  void reset() {
    _sharedPreferences = null;
    _upscalerService = null;
  }
}
