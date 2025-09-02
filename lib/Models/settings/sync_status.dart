enum SyncConnectionStatus {
  noCredentials,
  connected,
  disconnected,
  connecting,
  stopped
}

class SyncStatus {
  final SyncConnectionStatus status;
  final String? error;

  SyncStatus(this.status, {this.error});
}
