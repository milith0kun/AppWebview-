import 'package:flutter_test/flutter_test.dart';
import 'package:gps_tracking_app/models/server_config.dart';

void main() {
  group('ServerConfig', () {
    test('debe crear una instancia con nombre y URL', () {
      const name = 'Test Server';
      const url = 'https://test.example.com';

      final config = ServerConfig(name: name, url: url);

      expect(config.name, equals(name));
      expect(config.url, equals(url));
    });

    test('debe serializar a JSON correctamente', () {
      const name = 'GPS Follow Me';
      const url = 'https://rastreo.gpsfollowme.com';

      final config = ServerConfig(name: name, url: url);
      final json = config.toJson();

      expect(json['name'], equals(name));
      expect(json['url'], equals(url));
      expect(json, isA<Map<String, dynamic>>());
    });

    test('debe deserializar desde JSON correctamente', () {
      final json = {
        'name': 'GPS Netic',
        'url': 'https://gpsnetic.com/rastreo',
      };

      final config = ServerConfig.fromJson(json);

      expect(config.name, equals('GPS Netic'));
      expect(config.url, equals('https://gpsnetic.com/rastreo'));
    });

    test('debe convertir a String correctamente', () {
      final config = ServerConfig(
        name: 'Test Server',
        url: 'https://test.com',
      );

      final stringRepresentation = config.toString();

      expect(stringRepresentation, contains('Test Server'));
      expect(stringRepresentation, contains('https://test.com'));
    });

    test('debe comparar objetos correctamente con ==', () {
      final config1 = ServerConfig(
        name: 'Server A',
        url: 'https://servera.com',
      );

      final config2 = ServerConfig(
        name: 'Server A',
        url: 'https://servera.com',
      );

      final config3 = ServerConfig(
        name: 'Server B',
        url: 'https://serverb.com',
      );

      expect(config1 == config2, isTrue);
      expect(config1 == config3, isFalse);
    });

    test('debe tener hashCode consistente', () {
      final config1 = ServerConfig(
        name: 'Server',
        url: 'https://server.com',
      );

      final config2 = ServerConfig(
        name: 'Server',
        url: 'https://server.com',
      );

      expect(config1.hashCode, equals(config2.hashCode));
    });

    test('debe manejar serialización y deserialización completa', () {
      final original = ServerConfig(
        name: 'Original Server',
        url: 'https://original.com',
      );

      final json = original.toJson();
      final reconstructed = ServerConfig.fromJson(json);

      expect(reconstructed.name, equals(original.name));
      expect(reconstructed.url, equals(original.url));
      expect(reconstructed, equals(original));
    });

    test('debe manejar nombres y URLs con caracteres especiales', () {
      final config = ServerConfig(
        name: 'Servidor de Prueba (ñ)',
        url: 'https://test.com/path?param=value&other=123',
      );

      final json = config.toJson();
      final reconstructed = ServerConfig.fromJson(json);

      expect(reconstructed.name, equals('Servidor de Prueba (ñ)'));
      expect(reconstructed.url, contains('param=value'));
    });

    test('debe manejar URLs vacías', () {
      final config = ServerConfig(
        name: 'Empty URL Server',
        url: '',
      );

      expect(config.url, equals(''));

      final json = config.toJson();
      final reconstructed = ServerConfig.fromJson(json);

      expect(reconstructed.url, equals(''));
    });

    test('debe manejar nombres vacíos', () {
      final config = ServerConfig(
        name: '',
        url: 'https://test.com',
      );

      expect(config.name, equals(''));

      final json = config.toJson();
      final reconstructed = ServerConfig.fromJson(json);

      expect(reconstructed.name, equals(''));
    });
  });
}
