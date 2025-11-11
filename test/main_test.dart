import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_tracking_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Main App Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('MyApp debe inicializarse correctamente',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // Verificar que la app se inicializa
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('debe usar Material Design 3', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, isTrue);
    });

    testWidgets('debe tener el color primario correcto',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.primaryColor, equals(const Color(0xFF2196F3)));
    });

    testWidgets('debe mostrar SplashScreen inicialmente',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // SplashScreen debe estar presente
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('SplashScreen debe mostrar logo de ubicación',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('SplashScreen debe mostrar el nombre de la app',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      expect(find.text('GPS Tracking'), findsOneWidget);
    });

    testWidgets('SplashScreen debe mostrar indicador de carga',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe navegar a ServerSelectionScreen si es primera vez',
        (WidgetTester tester) async {
      // Asegurar que no hay servidor guardado
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(const MyApp());
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Debe mostrar la pantalla de selección de servidor
      expect(find.text('Selecciona tu servidor'), findsOneWidget);
    });

    testWidgets('app debe renderizar sin errores', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('debe tener título de app correcto',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, equals('GPS Tracking'));
    });

    testWidgets('debe deshabilitar banner de debug',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('SplashScreen debe tener color de fondo azul',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(const Color(0xFF2196F3)));
    });

    testWidgets('logo en SplashScreen debe tener tamaño 120',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      final icon = tester.widget<Icon>(find.byIcon(Icons.location_on));
      expect(icon.size, equals(120));
    });

    testWidgets('logo en SplashScreen debe ser blanco',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      final icon = tester.widget<Icon>(find.byIcon(Icons.location_on));
      expect(icon.color, equals(Colors.white));
    });
  });
}
