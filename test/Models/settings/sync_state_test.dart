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
class MockReplicatorStatus extends Mock implements ReplicatorStatus {}

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

      // Mock the getCredentials method by mocking the underlying storage calls
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
        expect(syncState.status.status, SyncConnectionStatus.stopped); // Initial state from notifier
      });
    });

    group('status updates from notifier', () {
      test('updates status to connecting', () async {
        await syncState.init();
        final mockStatus = MockReplicatorStatus();
        when(() => mockStatus.activity).thenReturn(ReplicatorActivityLevel.connecting);
        when(() => mockStatus.error).thenReturn(null);

        replicatorStatusNotifier.value = mockStatus;

        expect(syncState.status.status, SyncConnectionStatus.connecting);
      });

      test('updates status to connected (idle)', () async {
        await syncState.init();
        final mockStatus = MockReplicatorStatus();
        when(() => mockStatus.activity).thenReturn(ReplicatorActivityLevel.idle);
        when(() => mockStatus.error).thenReturn(null);

        replicatorStatusNotifier.value = mockStatus;

        expect(syncState.status.status, SyncConnectionStatus.connected);
      });

      test('updates status to disconnected with error', () async {
        await syncState.init();
        final mockStatus = MockReplicatorStatus();
        final error = CouchbaseLiteException("test error", "TEST", 500);
        when(() => mockStatus.activity).thenReturn(ReplicatorActivityLevel.offline);
        when(() => mockStatus.error).thenReturn(error);

        replicatorStatusNotifier.value = mockStatus;

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
