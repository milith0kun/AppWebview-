import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_tracking_app/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsScreen Widget Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('debe mostrar el AppBar con título correcto',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Configuración'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('debe mostrar todas las secciones principales',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Notificaciones'), findsOneWidget);
      expect(find.text('Firebase Cloud Messaging'), findsOneWidget);
      expect(find.text('Información de la App'), findsOneWidget);
    });

    testWidgets('debe mostrar opciones de sonido de notificación',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sonido de Notificación'), findsOneWidget);
      expect(find.text('Predeterminado'), findsOneWidget);
      expect(find.text('Alerta 1'), findsOneWidget);
      expect(find.text('Alerta 2'), findsOneWidget);
      expect(find.text('Alerta 3'), findsOneWidget);
    });

    testWidgets('debe mostrar radio buttons para sonidos',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Debe haber 4 opciones de sonido
      final radioTiles = find.byType(RadioListTile<String>);
      expect(radioTiles, findsNWidgets(4));
    });

    testWidgets('debe mostrar botón de probar notificación',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(ElevatedButton, 'Probar Notificación'),
          findsOneWidget);
    });

    testWidgets('debe mostrar información de la aplicación',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nombre'), findsOneWidget);
      expect(find.text('GPS Tracking'), findsOneWidget);
      expect(find.text('Versión'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
    });

    testWidgets('debe permitir seleccionar diferentes sonidos',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Seleccionar Alerta 1
      await tester.tap(find.text('Alerta 1'));
      await tester.pumpAndSettle();

      // No debe haber errores
      expect(tester.takeException(), isNull);
    });

    testWidgets('debe mostrar dividers entre secciones',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final dividers = find.byType(Divider);
      expect(dividers, findsWidgets);
    });

    testWidgets('debe tener botón de retroceso en AppBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                child: const Text('Go to Settings'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Settings'));
      await tester.pumpAndSettle();

      // Debe haber un botón de retroceso
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('debe renderizar sin overflow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('debe tener scroll habilitado', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('debe mostrar iconos apropiados', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.byIcon(Icons.cloud), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('debe cambiar selección de sonido al hacer tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap en Alerta 2
      await tester.tap(find.text('Alerta 2'));
      await tester.pumpAndSettle();

      // Verificar que no hay errores
      expect(tester.takeException(), isNull);

      // Tap en Alerta 3
      await tester.tap(find.text('Alerta 3'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('botón de probar notificación debe ser clickeable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Probar Notificación');
      expect(button, findsOneWidget);

      // Hacer tap en el botón
      await tester.tap(button);
      await tester.pumpAndSettle();

      // No debe haber errores
      expect(tester.takeException(), isNull);
    });

    testWidgets('debe mostrar cards para cada sección',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final cards = find.byType(Card);
      expect(cards, findsWidgets);
    });

    testWidgets('debe tener padding apropiado', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final padding = find.byType(Padding);
      expect(padding, findsWidgets);
    });
  });
}
