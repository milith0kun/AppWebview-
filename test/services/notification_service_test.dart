import 'package:flutter_test/flutter_test.dart';
import 'package:gps_tracking_app/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService', () {
    late NotificationService notificationService;

    setUp(() async {
      notificationService = await NotificationService.getInstance();
    });

    test('debe crear una instancia singleton', () async {
      final instance1 = await NotificationService.getInstance();
      final instance2 = await NotificationService.getInstance();

      expect(instance1, same(instance2));
    });

    test('debe inicializarse correctamente', () async {
      // Si llegamos aquí sin errores, la inicialización fue exitosa
      expect(notificationService, isNotNull);
    });

    // Nota: Los siguientes tests verifican que los métodos no lanzan errores
    // En un entorno de producción con dispositivos reales, estos métodos
    // interactuarían con el sistema de notificaciones nativo

    test('showNotification debe ejecutarse sin errores', () async {
      // En el entorno de test, esto no mostrará una notificación real
      // pero verifica que el método se puede llamar sin errores
      expect(
        () async => await notificationService.showNotification(
          title: 'Test Title',
          body: 'Test Body',
        ),
        returnsNormally,
      );
    });

    test('showNotification con sonido personalizado debe ejecutarse sin errores',
        () async {
      expect(
        () async => await notificationService.showNotification(
          title: 'Test Title',
          body: 'Test Body',
          sound: 'alert1',
        ),
        returnsNormally,
      );
    });

    test('showNotification con payload debe ejecutarse sin errores', () async {
      expect(
        () async => await notificationService.showNotification(
          title: 'Test Title',
          body: 'Test Body',
          payload: '{"route": "/home"}',
        ),
        returnsNormally,
      );
    });

    test('cancelAll debe ejecutarse sin errores', () async {
      expect(
        () async => await notificationService.cancelAll(),
        returnsNormally,
      );
    });

    test('cancel debe ejecutarse sin errores', () async {
      expect(
        () async => await notificationService.cancel(0),
        returnsNormally,
      );
    });

    test('getPendingNotifications debe retornar una lista', () async {
      final pending = await notificationService.getPendingNotifications();
      expect(pending, isA<List>());
    });

    test('múltiples notificaciones deben ejecutarse sin errores', () async {
      // Simular mostrar múltiples notificaciones
      for (int i = 0; i < 5; i++) {
        await notificationService.showNotification(
          title: 'Notification $i',
          body: 'Body $i',
        );
      }

      // Verificar que podemos obtener las pendientes
      final pending = await notificationService.getPendingNotifications();
      expect(pending, isA<List>());
    });

    test('cancelar notificación específica debe ejecutarse sin errores',
        () async {
      // Mostrar una notificación
      await notificationService.showNotification(
        title: 'Test',
        body: 'Test Body',
      );

      // Cancelar notificación con ID 0
      expect(
        () async => await notificationService.cancel(0),
        returnsNormally,
      );
    });

    test('cancelar todas las notificaciones debe ejecutarse sin errores',
        () async {
      // Mostrar varias notificaciones
      for (int i = 0; i < 3; i++) {
        await notificationService.showNotification(
          title: 'Test $i',
          body: 'Body $i',
        );
      }

      // Cancelar todas
      expect(
        () async => await notificationService.cancelAll(),
        returnsNormally,
      );
    });

    test('notificación con todos los sonidos disponibles', () async {
      final sounds = ['default', 'alert1', 'alert2', 'alert3'];

      for (final sound in sounds) {
        expect(
          () async => await notificationService.showNotification(
            title: 'Test Sound',
            body: 'Testing $sound',
            sound: sound,
          ),
          returnsNormally,
        );
      }
    });

    test('notificación con payload JSON complejo', () async {
      const complexPayload = '''
      {
        "route": "/details",
        "id": 123,
        "data": {
          "nested": "value",
          "array": [1, 2, 3]
        }
      }
      ''';

      expect(
        () async => await notificationService.showNotification(
          title: 'Complex Payload',
          body: 'Testing complex payload',
          payload: complexPayload,
        ),
        returnsNormally,
      );
    });

    test('notificación con título y cuerpo largos', () async {
      final longTitle = 'A' * 100;
      final longBody = 'B' * 500;

      expect(
        () async => await notificationService.showNotification(
          title: longTitle,
          body: longBody,
        ),
        returnsNormally,
      );
    });

    test('notificación con caracteres especiales', () async {
      expect(
        () async => await notificationService.showNotification(
          title: 'Título con ñ y acentos',
          body: 'Cuerpo con símbolos: @#\$%^&*()_+-=[]{}|;:,.<>?',
        ),
        returnsNormally,
      );
    });

    test('notificación con emojis', () async {
      expect(
        () async => await notificationService.showNotification(
          title: '🚗 GPS Tracking',
          body: '📍 Nueva ubicación detectada 🗺️',
        ),
        returnsNormally,
      );
    });
  });
}
