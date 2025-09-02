import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:buecherteam_2023_desktop/Models/settings/sync_state.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SyncState', () {
    late SyncState syncState;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      syncState = SyncState(storage: mockStorage);
    });

    test('saveCredentials writes username and password to secure storage', () async {
      when(() => mockStorage.write(key: 'sync_username', value: 'user')).thenAnswer((_) async => {});
      when(() => mockStorage.write(key: 'sync_password', value: 'pass')).thenAnswer((_) async => {});

      await syncState.saveCredentials('user', 'pass');

      verify(() => mockStorage.write(key: 'sync_username', value: 'user')).called(1);
      verify(() => mockStorage.write(key: 'sync_password', value: 'pass')).called(1);
    });

    test('getCredentials reads username and password from secure storage', () async {
      when(() => mockStorage.read(key: 'sync_username')).thenAnswer((_) async => 'user');
      when(() => mockStorage.read(key: 'sync_password')).thenAnswer((_) async => 'pass');

      final credentials = await syncState.getCredentials();

      expect(credentials['username'], 'user');
      expect(credentials['password'], 'pass');
    });
  });
}
