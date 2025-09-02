import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SyncState extends ChangeNotifier {
  final FlutterSecureStorage _storage;

  SyncState({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  static const _usernameKey = 'sync_username';
  static const _passwordKey = 'sync_password';

  Future<void> saveCredentials(String username, String password) async {
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _passwordKey, value: password);
    notifyListeners();
  }

  Future<Map<String, String?>> getCredentials() async {
    final username = await _storage.read(key: _usernameKey);
    final password = await _storage.read(key: _passwordKey);
    return {'username': username, 'password': password};
  }
}
