import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Models/settings/sync_status.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SyncState extends ChangeNotifier {
  final FlutterSecureStorage _storage;
  final DB _db;

  SyncStatus _status = SyncStatus(SyncConnectionStatus.stopped);
  SyncStatus get status => _status;

  SyncState({FlutterSecureStorage? storage, DB? db})
      : _storage = storage ?? const FlutterSecureStorage(),
        _db = db ?? DB();

  Future<void> init() async {
    _db.replicatorStatus.addListener(_updateStatus);
    await _checkInitialStatus();
  }

  @override
  void dispose() {
    _db.replicatorStatus.removeListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus() {
    final cblStatus = _db.replicatorStatus.value;
    if (cblStatus == null) {
      _status = SyncStatus(SyncConnectionStatus.stopped);
    } else {
      switch (cblStatus.activity) {
        case ReplicatorActivityLevel.stopped:
          _status = SyncStatus(SyncConnectionStatus.stopped);
          break;
        case ReplicatorActivityLevel.offline:
          _status = SyncStatus(SyncConnectionStatus.disconnected, error: "Offline");
          break;
        case ReplicatorActivityLevel.connecting:
          _status = SyncStatus(SyncConnectionStatus.connecting);
          break;
        case ReplicatorActivityLevel.idle:
          _status = SyncStatus(SyncConnectionStatus.connected);
          break;
        case ReplicatorActivityLevel.busy:
          _status = SyncStatus(SyncConnectionStatus.connected); // Or a new "syncing" state
          break;
      }
      if (cblStatus.error != null) {
        _status = SyncStatus(SyncConnectionStatus.disconnected, error: cblStatus.error!.message);
      }
    }
    notifyListeners();
  }

  Future<void> _checkInitialStatus() async {
    final credentials = await getCredentials();
    if (credentials['username'] == null || credentials['password'] == null) {
      _status = SyncStatus(SyncConnectionStatus.noCredentials);
      notifyListeners();
    } else {
      // If credentials exist, the replicator will start automatically
      // and the listener will pick up the status.
    }
  }


  static const _usernameKey = 'sync_username';
  static const _passwordKey = 'sync_password';

  Future<void> saveCredentials(String username, String password) async {
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _passwordKey, value: password);
    await _db.startReplication(); // Restart replication with new credentials
    notifyListeners();
  }

  Future<Map<String, String?>> getCredentials() async {
    final username = await _storage.read(key: _usernameKey);
    final password = await _storage.read(key: _passwordKey);
    return {'username': username, 'password': password};
  }
}
