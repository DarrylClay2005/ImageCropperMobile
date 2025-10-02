import 'package:hive/hive.dart';

abstract class CacheService {
  Future<void> put(String key, dynamic value);
  T? get<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
  bool containsKey(String key);
}

class CacheServiceImpl implements CacheService {
  final Box _box;

  CacheServiceImpl(this._box);

  @override
  Future<void> put(String key, dynamic value) async {
    await _box.put(key, value);
  }

  @override
  T? get<T>(String key) {
    return _box.get(key) as T?;
  }

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  bool containsKey(String key) {
    return _box.containsKey(key);
  }
}