import 'dart:io';

class ApiConfig {
  // Private constructor
  ApiConfig._();
  
  static const String _upscalerApiKeyEnv = 'UPSCALER_API_KEY';
  static const String _defaultUpscalerApiKey = 'paat-9RAdj3vIHGONDNrL8vU1p8zhfcS';
  
  /// Gets the upscaler API key from environment or falls back to default
  /// In production, this should be loaded from secure storage or environment variables
  static String get upscalerApiKey {
    // Try to get from environment first (for production)
    final envKey = Platform.environment[_upscalerApiKeyEnv];
    if (envKey != null && envKey.isNotEmpty) {
      return envKey;
    }
    
    // Fallback to default key (for development/demo)
    return _defaultUpscalerApiKey;
  }
  
  // API Endpoints
  static const String upscalerBaseUrl = 'https://api.upscaler.ai';
  static const String upscaleEndpoint = '/v1/upscale';
  
  // API Settings
  static const int requestTimeoutSeconds = 60;
  static const int maxImageSizeMB = 10;
  static const List<String> supportedFormats = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Upscaler Options
  static const Map<String, dynamic> defaultUpscaleOptions = {
    'scale_factor': 2,
    'enhance_quality': true,
    'preserve_transparency': true,
    'noise_reduction': true,
  };
}