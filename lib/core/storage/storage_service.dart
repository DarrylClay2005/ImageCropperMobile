import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<bool> saveBool(String key, bool value);
  bool? getBool(String key);
  Future<bool> saveString(String key, String value);
  String? getString(String key);
  Future<bool> saveInt(String key, int value);
  int? getInt(String key);
  Future<bool> saveDouble(String key, double value);
  double? getDouble(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}

class StorageServiceImpl implements StorageService {
  final SharedPreferences _prefs;

  StorageServiceImpl(this._prefs);

  @override
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  @override
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  @override
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    return await _prefs.clear();
  }
}