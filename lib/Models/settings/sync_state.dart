import 'dart:async';

import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Models/settings/sync_status.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Resources/text.dart';

class SyncState extends ChangeNotifier {
  final FlutterSecureStorage _storage;
  final DB _db;

  String? urlError;
  String? credentialsError;

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
        _status = SyncStatus(SyncConnectionStatus.disconnected, error: cblStatus.error!.toString());

      }
    }
    notifyListeners();
  }

  Future<void> _checkInitialStatus() async {
    final credentials = await getCredentials();
    if (credentials[TextRes.usernameKey] == null
        || credentials[TextRes.passwordKey] == null
        || credentials[TextRes.uriKey] == null) {
      _status = SyncStatus(SyncConnectionStatus.noCredentials);
      notifyListeners();
    } else {
      // If credentials exist, the replicator will start automatically
      // and the listener will pick up the status.
    }
  }

  Future<void> awaitOneSyncCycle() {
    // 1. Immediately return if not currently syncing.
    if (_db.replicatorStatus.value?.activity != ReplicatorActivityLevel.busy) {
      return Future.value();
    }

    // 2. Create a Completer to manually control the Future's lifecycle.
    final completer = Completer<void>();

    // Use `late` to allow the listener to reference itself for removal.
    late final void Function() listener;

    // 3. Define the listener logic.
    listener = () {
      final status = _db.replicatorStatus.value;
      const endStates = [
        ReplicatorActivityLevel.idle,
        ReplicatorActivityLevel.stopped,
        ReplicatorActivityLevel.offline,
      ];

      // 4. Check if the replicator has entered a state that ends the cycle.
      if (endStates.contains(status?.activity)) {
        // 5. Clean up by removing the listener to prevent memory leaks.
        _db.replicatorStatus.removeListener(listener);

        // 6. Complete the Future (only if it hasn't been completed already).
        if (!completer.isCompleted) {
          if (status?.error != null) {
            completer.completeError(status!.error!);
          } else {
            completer.complete();
          }
        }
      }
    };

    // 7. Attach the listener and return the Future for the caller to await.
    _db.replicatorStatus.addListener(listener);
    return completer.future;
  }




  Future<void> saveCredentials(String uri, String username, String password) async {
    await _storage.write(key: TextRes.uriKey, value: uri);
    await _storage.write(key: TextRes.usernameKey, value: username);
    await _storage.write(key: TextRes.passwordKey, value: password);
    clearError();
    Object? error = await _db.checkConnection();
    updateError(error);
    await _db.startReplication(); // Restart replication with new credentials

    notifyListeners();
  }

  Future<Map<String, String?>> getCredentials() async {
    final uri = await _storage.read(key: TextRes.uriKey);
    final username = await _storage.read(key: TextRes.usernameKey);
    final password = await _storage.read(key: TextRes.passwordKey);
    return {TextRes.uriKey: uri, TextRes.usernameKey: username, TextRes.passwordKey: password};
  }

  void updateError(Object? error) {
    if (error is DatabaseException) {
      urlError = TextRes.urlError;
      credentialsError = null;
    } else if (error is HttpException){
      urlError = null;
      credentialsError = TextRes.credentialsError;
    }
  }

  void clearError() {
    urlError = null;
    credentialsError = null;
  }


}
