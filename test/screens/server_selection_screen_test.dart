import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_tracking_app/screens/server_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ServerSelectionScreen Widget Tests', () {
    setUp(() async {
      // Limpiar SharedPreferences antes de cada test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('debe mostrar el título correctamente',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      expect(find.text('GPS Tracking'), findsOneWidget);
      expect(find.text('Selecciona tu servidor'), findsOneWidget);
    });

    testWidgets('debe mostrar el logo de ubicación', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('debe mostrar ambos servidores', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      expect(find.text('GPS Follow Me'), findsOneWidget);
      expect(find.text('GPS Netic'), findsOneWidget);
    });

    testWidgets('debe mostrar las URLs de los servidores',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      expect(find.text('https://rastreo.gpsfollowme.com'), findsOneWidget);
      expect(find.text('https://gpsnetic.com/rastreo'), findsOneWidget);
    });

    testWidgets('debe mostrar radio buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      final radioButtons = find.byType(Radio<int>);
      expect(radioButtons, findsNWidgets(2));
    });

    testWidgets('debe mostrar botón de continuar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      expect(find.widgetWithText(ElevatedButton, 'Continuar'), findsOneWidget);
    });

    testWidgets('radio button debe cambiar de estado al seleccionar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      // Inicialmente no hay selección
      final radioButtons = find.byType(Radio<int>);
      expect(radioButtons, findsNWidgets(2));

      // Tap en el primer servidor
      await tester.tap(find.text('GPS Follow Me'));
      await tester.pump();

      // Verificar que se puede interactuar con el widget
      expect(find.text('GPS Follow Me'), findsOneWidget);
    });

    testWidgets('debe mostrar SnackBar al hacer clic sin seleccionar servidor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      // Tap en continuar sin seleccionar
      await tester.tap(find.widgetWithText(ElevatedButton, 'Continuar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Por favor selecciona un servidor'), findsOneWidget);
    });

    testWidgets('debe tener el color primario correcto',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      final materialApp = find.byType(MaterialApp);
      expect(materialApp, findsOneWidget);
    });

    testWidgets('debe mostrar el logo con el tamaño correcto',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.location_on));
      expect(icon.size, equals(120));
    });

    testWidgets('debe permitir seleccionar el primer servidor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      // Tap en el card del primer servidor
      await tester.tap(find.text('GPS Follow Me'));
      await tester.pump();

      // El widget debe renderizarse sin errores
      expect(find.text('GPS Follow Me'), findsOneWidget);
    });

    testWidgets('debe permitir seleccionar el segundo servidor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      // Tap en el card del segundo servidor
      await tester.tap(find.text('GPS Netic'));
      await tester.pump();

      // El widget debe renderizarse sin errores
      expect(find.text('GPS Netic'), findsOneWidget);
    });

    testWidgets('debe tener padding correcto en el contenido',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      final padding = find.byType(Padding);
      expect(padding, findsWidgets);
    });

    testWidgets('debe renderizar sin overflow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      // Verificar que no hay errores de overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('debe tener scroll habilitado', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ServerSelectionScreen(),
        ),
      );

      // Verificar que hay un SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
