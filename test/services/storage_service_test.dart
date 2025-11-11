import 'package:flutter_test/flutter_test.dart';
import 'package:gps_tracking_app/models/server_config.dart';
import 'package:gps_tracking_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StorageService', () {
    late StorageService storageService;

    setUp(() async {
      // Limpiar SharedPreferences antes de cada test
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.getInstance();
    });

    tearDown(() async {
      // Limpiar después de cada test
      await storageService.clearAll();
    });

    test('debe crear una instancia singleton', () async {
      final instance1 = await StorageService.getInstance();
      final instance2 = await StorageService.getInstance();

      expect(instance1, same(instance2));
    });

    group('Servidor Seleccionado', () {
      test('debe guardar y recuperar servidor seleccionado', () async {
        final server = ServerConfig(
          name: 'Test Server',
          url: 'https://test.com',
        );

        await storageService.saveSelectedServer(server);
        final retrieved = storageService.getSelectedServer();

        expect(retrieved, isNotNull);
        expect(retrieved!.name, equals('Test Server'));
        expect(retrieved.url, equals('https://test.com'));
      });

      test('debe retornar null si no hay servidor guardado', () {
        final retrieved = storageService.getSelectedServer();
        expect(retrieved, isNull);
      });

      test('debe limpiar servidor seleccionado', () async {
        final server = ServerConfig(
          name: 'Test Server',
          url: 'https://test.com',
        );

        await storageService.saveSelectedServer(server);
        expect(storageService.getSelectedServer(), isNotNull);

        await storageService.clearSelectedServer();
        expect(storageService.getSelectedServer(), isNull);
      });

      test('debe sobrescribir servidor existente', () async {
        final server1 = ServerConfig(
          name: 'Server 1',
          url: 'https://server1.com',
        );
        final server2 = ServerConfig(
          name: 'Server 2',
          url: 'https://server2.com',
        );

        await storageService.saveSelectedServer(server1);
        await storageService.saveSelectedServer(server2);

        final retrieved = storageService.getSelectedServer();
        expect(retrieved!.name, equals('Server 2'));
        expect(retrieved.url, equals('https://server2.com'));
      });

      test('debe manejar JSON inválido gracefully', () async {
        // Guardar JSON inválido directamente en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_server', 'invalid json');

        final retrieved = storageService.getSelectedServer();
        expect(retrieved, isNull);
      });
    });

    group('Token FCM', () {
      test('debe guardar y recuperar token FCM', () async {
        const token = 'test_fcm_token_12345';

        await storageService.saveFcmToken(token);
        final retrieved = storageService.getFcmToken();

        expect(retrieved, equals(token));
      });

      test('debe retornar null si no hay token guardado', () {
        final retrieved = storageService.getFcmToken();
        expect(retrieved, isNull);
      });

      test('debe sobrescribir token existente', () async {
        await storageService.saveFcmToken('old_token');
        await storageService.saveFcmToken('new_token');

        final retrieved = storageService.getFcmToken();
        expect(retrieved, equals('new_token'));
      });

      test('debe manejar tokens largos', () async {
        final longToken = 'a' * 500; // Token muy largo

        await storageService.saveFcmToken(longToken);
        final retrieved = storageService.getFcmToken();

        expect(retrieved, equals(longToken));
        expect(retrieved!.length, equals(500));
      });
    });

    group('Sonido de Notificación', () {
      test('debe guardar y recuperar sonido de notificación', () async {
        await storageService.saveNotificationSound('alert1');
        final retrieved = storageService.getNotificationSound();

        expect(retrieved, equals('alert1'));
      });

      test('debe retornar "default" si no hay sonido guardado', () {
        final retrieved = storageService.getNotificationSound();
        expect(retrieved, equals('default'));
      });

      test('debe sobrescribir sonido existente', () async {
        await storageService.saveNotificationSound('alert1');
        await storageService.saveNotificationSound('alert2');

        final retrieved = storageService.getNotificationSound();
        expect(retrieved, equals('alert2'));
      });

      test('debe guardar todos los tipos de sonido disponibles', () async {
        final sounds = ['default', 'alert1', 'alert2', 'alert3'];

        for (final sound in sounds) {
          await storageService.saveNotificationSound(sound);
          final retrieved = storageService.getNotificationSound();
          expect(retrieved, equals(sound));
        }
      });
    });

    group('Primera Vez', () {
      test('debe retornar true si es primera vez (no hay servidor)', () {
        expect(storageService.isFirstTime(), isTrue);
      });

      test('debe retornar false si no es primera vez (hay servidor)', () async {
        final server = ServerConfig(
          name: 'Test',
          url: 'https://test.com',
        );

        await storageService.saveSelectedServer(server);
        expect(storageService.isFirstTime(), isFalse);
      });

      test('debe retornar true después de limpiar servidor', () async {
        final server = ServerConfig(
          name: 'Test',
          url: 'https://test.com',
        );

        await storageService.saveSelectedServer(server);
        expect(storageService.isFirstTime(), isFalse);

        await storageService.clearSelectedServer();
        expect(storageService.isFirstTime(), isTrue);
      });
    });

    group('Limpiar Todo', () {
      test('debe limpiar todos los datos guardados', () async {
        // Guardar datos
        final server = ServerConfig(
          name: 'Test',
          url: 'https://test.com',
        );
        await storageService.saveSelectedServer(server);
        await storageService.saveFcmToken('test_token');
        await storageService.saveNotificationSound('alert1');

        // Verificar que se guardaron
        expect(storageService.getSelectedServer(), isNotNull);
        expect(storageService.getFcmToken(), isNotNull);
        expect(storageService.getNotificationSound(), equals('alert1'));

        // Limpiar todo
        await storageService.clearAll();

        // Verificar que se limpiaron
        expect(storageService.getSelectedServer(), isNull);
        expect(storageService.getFcmToken(), isNull);
        expect(storageService.getNotificationSound(), equals('default'));
        expect(storageService.isFirstTime(), isTrue);
      });
    });

    group('Integración', () {
      test('debe manejar flujo completo de uso', () async {
        // Primera vez
        expect(storageService.isFirstTime(), isTrue);

        // Guardar servidor
        final server = ServerConfig(
          name: 'GPS Follow Me',
          url: 'https://rastreo.gpsfollowme.com',
        );
        await storageService.saveSelectedServer(server);
        expect(storageService.isFirstTime(), isFalse);

        // Guardar token
        await storageService.saveFcmToken('fcm_token_abc123');

        // Guardar sonido
        await storageService.saveNotificationSound('alert2');

        // Verificar todo
        final retrievedServer = storageService.getSelectedServer();
        expect(retrievedServer, equals(server));
        expect(storageService.getFcmToken(), equals('fcm_token_abc123'));
        expect(storageService.getNotificationSound(), equals('alert2'));

        // Cambiar servidor
        final newServer = ServerConfig(
          name: 'GPS Netic',
          url: 'https://gpsnetic.com/rastreo',
        );
        await storageService.saveSelectedServer(newServer);

        final updatedServer = storageService.getSelectedServer();
        expect(updatedServer!.name, equals('GPS Netic'));

        // Limpiar solo servidor
        await storageService.clearSelectedServer();
        expect(storageService.getSelectedServer(), isNull);
        expect(storageService.getFcmToken(), isNotNull); // Token aún existe
        expect(storageService.getNotificationSound(), isNotNull); // Sonido aún existe
      });
    });
  });
}
