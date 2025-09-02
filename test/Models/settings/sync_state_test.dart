import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Models/settings/sync_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/sync_status.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class MockDB extends Mock implements DB {}

class _TestException extends CouchbaseLiteException {
  _TestException(String message, String domain, int code)
      : super(message, domain, code);
}

void main() {
  group('SyncState', () {
    late SyncState syncState;
    late MockFlutterSecureStorage mockStorage;
    late MockDB mockDb;
    late ValueNotifier<ReplicatorStatus?> replicatorStatusNotifier;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      mockDb = MockDB();
      replicatorStatusNotifier = ValueNotifier<ReplicatorStatus?>(null);

      when(() => mockDb.replicatorStatus).thenReturn(replicatorStatusNotifier);
      when(() => mockDb.startReplication()).thenAnswer((_) async {});

      syncState = SyncState(storage: mockStorage, db: mockDb);

      when(() => mockStorage.read(key: any(named: 'key'))).thenAnswer((_) async => null);
    });

    tearDown(() {
      replicatorStatusNotifier.dispose();
      syncState.dispose();
    });

    test('initial status is stopped', () {
      expect(syncState.status.status, SyncConnectionStatus.stopped);
    });

    group('init', () {
      test('sets status to noCredentials if no credentials are stored', () async {
        when(() => mockStorage.read(key: 'sync_username')).thenAnswer((_) async => null);
        when(() => mockStorage.read(key: 'sync_password')).thenAnswer((_) async => null);

        await syncState.init();

        expect(syncState.status.status, SyncConnectionStatus.noCredentials);
      });

      test('does not set status to noCredentials if credentials are stored', () async {
        when(() => mockStorage.read(key: 'sync_username')).thenAnswer((_) async => 'user');
        when(() => mockStorage.read(key: 'sync_password')).thenAnswer((_) async => 'pass');

        await syncState.init();

        expect(syncState.status.status, isNot(SyncConnectionStatus.noCredentials));
        expect(syncState.status.status, SyncConnectionStatus.stopped);
      });
    });

    group('status updates from notifier', () {
      test('updates status to connecting', () async {
        await syncState.init();
        final status = ReplicatorStatus(
          ReplicatorActivityLevel.connecting,
          ReplicatorProgress(0, 0),
          null,
        );
        replicatorStatusNotifier.value = status;
        expect(syncState.status.status, SyncConnectionStatus.connecting);
      });

      test('updates status to connected (idle)', () async {
        await syncState.init();
        final status = ReplicatorStatus(
          ReplicatorActivityLevel.idle,
          ReplicatorProgress(10, 10),
          null,
        );
        replicatorStatusNotifier.value = status;
        expect(syncState.status.status, SyncConnectionStatus.connected);
      });

      test('updates status to disconnected with error', () async {
        await syncState.init();
        final error = _TestException("test error", "TEST", 500);
        final status = ReplicatorStatus(
          ReplicatorActivityLevel.offline,
          ReplicatorProgress(0, 0),
          error,
        );
        replicatorStatusNotifier.value = status;
        expect(syncState.status.status, SyncConnectionStatus.disconnected);
        expect(syncState.status.error, "test error");
      });
    });

    group('saveCredentials', () {
      test('saves credentials and restarts replication', () async {
        when(() => mockStorage.write(key: 'sync_username', value: 'user')).thenAnswer((_) async {});
        when(() => mockStorage.write(key: 'sync_password', value: 'pass')).thenAnswer((_) async {});

        await syncState.saveCredentials('user', 'pass');

        verify(() => mockStorage.write(key: 'sync_username', value: 'user')).called(1);
        verify(() => mockStorage.write(key: 'sync_password', value: 'pass')).called(1);
        verify(() => mockDb.startReplication()).called(1);
      });
    });
  });
}
