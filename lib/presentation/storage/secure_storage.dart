import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  static const _key = 'email';

  Future<String?> get({String? key}) async {
    return await _storage.read(key: key ?? _key);
  }

  Future<void> set(String value, {String? key}) async {
    return await _storage.write(key: key ?? _key, value: value);
  }

  Future<void> delete({required String key}) async {
    if (await get() != null) {
      return await _storage.delete(key: key);
    }
  }

  Future<void> deleteAll() async {
    return await _storage.deleteAll();
  }
}
