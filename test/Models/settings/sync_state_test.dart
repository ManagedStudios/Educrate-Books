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

      // Default mock for reading from storage returns null
      when(() => mockStorage.read(key: any(named: 'key'))).thenAnswer((_) async => null);
      // Default mock for writing to storage does nothing
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) async {});
    });

    tearDown(() {
      replicatorStatusNotifier.dispose();
      syncState.dispose();
    });

    test('initial status is stopped', () {
      expect(syncState.status.status, SyncConnectionStatus.stopped);
    });

    group('init', () {
      test('sets status to noCredentials if username is missing', () async {
        when(() => mockStorage.read(key: 'sync_password')).thenAnswer((_) async => 'pass');
        when(() => mockStorage.read(key: 'sync_url')).thenAnswer((_) async => 'url');
        await syncState.init();
        expect(syncState.status.status, SyncConnectionStatus.noCredentials);
      });

      test('sets status to noCredentials if password is missing', () async {
        when(() => mockStorage.read(key: 'sync_username')).thenAnswer((_) async => 'user');
        when(() => mockStorage.read(key: 'sync_url')).thenAnswer((_) async => 'url');
        await syncState.init();
        expect(syncState.status.status, SyncConnectionStatus.noCredentials);
      });

      test('sets status to noCredentials if url is missing', () async {
        when(() => mockStorage.read(key: 'sync_username')).thenAnswer((_) async => 'user');
        when(() => mockStorage.read(key: 'sync_password')).thenAnswer((_) async => 'pass');
        await syncState.init();
        expect(syncState.status.status, SyncConnectionStatus.noCredentials);
      });

      test('does not set status to noCredentials if all details are stored', () async {
        when(() => mockStorage.read(key: 'sync_username')).thenAnswer((_) async => 'user');
        when(() => mockStorage.read(key: 'sync_password')).thenAnswer((_) async => 'pass');
        when(() => mockStorage.read(key: 'sync_url')).thenAnswer((_) async => 'url');

        await syncState.init();

        expect(syncState.status.status, isNot(SyncConnectionStatus.noCredentials));
        expect(syncState.status.status, SyncConnectionStatus.stopped);
      });
    });


    group('saveCredentials', () {
      test('saves all credentials and restarts replication', () async {
        await syncState.saveCredentials('user', 'pass', 'url');

        verify(() => mockStorage.write(key: 'sync_username', value: 'user')).called(1);
        verify(() => mockStorage.write(key: 'sync_password', value: 'pass')).called(1);
        verify(() => mockStorage.write(key: 'sync_url', value: 'url')).called(1);
        verify(() => mockDb.startReplication()).called(1);
      });
    });
  });
}
