# Guía de Testing - GPS Tracking App

## 📋 Resumen

Esta guía describe cómo ejecutar y verificar todos los tests de la aplicación GPS Tracking App, un MVP funcional listo para demostración al cliente.

## 🎯 Cobertura de Tests

### Tests Implementados

| Categoría | Archivo | Tests | Descripción |
|-----------|---------|-------|-------------|
| **Modelos** | `test/models/server_config_test.dart` | 10 | Pruebas del modelo ServerConfig |
| **Servicios** | `test/services/storage_service_test.dart` | 20+ | Pruebas de almacenamiento local |
| **Servicios** | `test/services/notification_service_test.dart` | 15+ | Pruebas de notificaciones |
| **Widgets** | `test/screens/server_selection_screen_test.dart` | 15+ | Pruebas de selección de servidor |
| **Widgets** | `test/screens/settings_screen_test.dart` | 17+ | Pruebas de configuración |
| **App** | `test/main_test.dart` | 15+ | Pruebas de inicialización |
| **Total** | - | **90+** | Tests comprehensivos |

## 🚀 Ejecutar Tests

### Todos los Tests

```bash
flutter test
```

### Tests Específicos

```bash
# Tests de modelos
flutter test test/models/

# Tests de servicios
flutter test test/services/

# Tests de pantallas
flutter test test/screens/

# Test específico
flutter test test/models/server_config_test.dart
```

### Con Cobertura

```bash
# Generar reporte de cobertura
flutter test --coverage

# Ver cobertura en HTML (requiere lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Modo Verbose

```bash
flutter test --verbose
```

## 📊 Tests Detallados

### 1. ServerConfig Model Tests

**Archivo:** `test/models/server_config_test.dart`

Tests implementados:
- ✅ Creación de instancia
- ✅ Serialización a JSON
- ✅ Deserialización desde JSON
- ✅ Conversión a String
- ✅ Comparación con operador ==
- ✅ HashCode consistente
- ✅ Serialización/deserialización completa
- ✅ Caracteres especiales
- ✅ URLs vacías
- ✅ Nombres vacíos

### 2. StorageService Tests

**Archivo:** `test/services/storage_service_test.dart`

Tests implementados:
- ✅ Patrón Singleton
- ✅ Guardar y recuperar servidor
- ✅ Servidor null por defecto
- ✅ Limpiar servidor
- ✅ Sobrescribir servidor
- ✅ Manejo de JSON inválido
- ✅ Guardar y recuperar token FCM
- ✅ Token null por defecto
- ✅ Tokens largos
- ✅ Sonido de notificación
- ✅ Sonido default por defecto
- ✅ Verificación de primera vez
- ✅ Limpiar todos los datos
- ✅ Flujo de integración completo

### 3. NotificationService Tests

**Archivo:** `test/services/notification_service_test.dart`

Tests implementados:
- ✅ Patrón Singleton
- ✅ Inicialización correcta
- ✅ Mostrar notificación básica
- ✅ Notificación con sonido personalizado
- ✅ Notificación con payload
- ✅ Cancelar todas las notificaciones
- ✅ Cancelar notificación específica
- ✅ Obtener notificaciones pendientes
- ✅ Múltiples notificaciones
- ✅ Todos los sonidos disponibles
- ✅ Payload JSON complejo
- ✅ Títulos y cuerpos largos
- ✅ Caracteres especiales
- ✅ Emojis

### 4. ServerSelectionScreen Tests

**Archivo:** `test/screens/server_selection_screen_test.dart`

Tests implementados:
- ✅ Mostrar título
- ✅ Mostrar logo de ubicación
- ✅ Mostrar ambos servidores
- ✅ Mostrar URLs
- ✅ Radio buttons presentes
- ✅ Botón continuar
- ✅ Cambio de estado al seleccionar
- ✅ SnackBar sin selección
- ✅ Color primario
- ✅ Tamaño del logo
- ✅ Selección de servidores
- ✅ Padding correcto
- ✅ Sin overflow
- ✅ Scroll habilitado

### 5. SettingsScreen Tests

**Archivo:** `test/screens/settings_screen_test.dart`

Tests implementados:
- ✅ AppBar con título
- ✅ Todas las secciones
- ✅ Opciones de sonido
- ✅ Radio buttons de sonido
- ✅ Botón probar notificación
- ✅ Información de app
- ✅ Selección de sonidos
- ✅ Dividers entre secciones
- ✅ Botón de retroceso
- ✅ Sin overflow
- ✅ Scroll habilitado
- ✅ Iconos apropiados
- ✅ Cambio de selección
- ✅ Clickeable
- ✅ Cards para secciones
- ✅ Padding apropiado

### 6. Main App Tests

**Archivo:** `test/main_test.dart`

Tests implementados:
- ✅ Inicialización de MyApp
- ✅ Material Design 3
- ✅ Color primario correcto
- ✅ SplashScreen inicial
- ✅ Logo de ubicación
- ✅ Nombre de la app
- ✅ Indicador de carga
- ✅ Navegación a ServerSelectionScreen
- ✅ Renderizado sin errores
- ✅ Título de app
- ✅ Banner de debug deshabilitado
- ✅ Color de fondo SplashScreen
- ✅ Tamaño del logo
- ✅ Color del logo

## ✅ Checklist de Verificación

### Pre-Testing

- [ ] Dependencias instaladas: `flutter pub get`
- [ ] Código sin errores de compilación
- [ ] Imports correctos en todos los archivos

### Durante Testing

- [ ] Todos los tests pasan exitosamente
- [ ] No hay tests skipped
- [ ] Cobertura de código > 70%
- [ ] Sin warnings en la consola

### Post-Testing

- [ ] Revisar reporte de cobertura
- [ ] Documentar tests que fallen
- [ ] Actualizar tests si hay cambios en código

## 🔧 Comandos Útiles

### Análisis de Código

```bash
# Analizar código (linting)
flutter analyze

# Formatear código
flutter format lib test

# Verificar formato
flutter format --set-exit-if-changed lib test
```

### Debugging de Tests

```bash
# Test específico con prints
flutter test test/models/server_config_test.dart --verbose

# Test con descripción
flutter test --name "debe crear una instancia"

# Test con timeout personalizado
flutter test --timeout=60s
```

### Limpieza

```bash
# Limpiar build
flutter clean

# Reinstalar dependencias
flutter pub get

# Actualizar dependencias
flutter pub upgrade
```

## 📝 Notas Importantes

### Limitaciones del Entorno de Test

1. **Firebase**: Los tests no pueden inicializar Firebase real, se mockean las funcionalidades
2. **Notificaciones Nativas**: En tests, las notificaciones no se muestran realmente
3. **WebView**: No se prueba navegación real en WebView durante tests unitarios
4. **SharedPreferences**: Se usa la versión mockeada para tests

### Mejores Prácticas

1. **Aislamiento**: Cada test debe ser independiente
2. **Setup/Teardown**: Usar `setUp()` y `tearDown()` para limpiar estado
3. **Nombres Descriptivos**: Tests con nombres claros y descriptivos
4. **Arrange-Act-Assert**: Seguir patrón AAA en todos los tests

### Estructura de Tests

```dart
group('Descripción del grupo', () {
  setUp(() async {
    // Preparación antes de cada test
  });

  tearDown(() async {
    // Limpieza después de cada test
  });

  test('debe hacer algo específico', () async {
    // Arrange (Preparar)
    final input = 'test';

    // Act (Actuar)
    final result = functionToTest(input);

    // Assert (Verificar)
    expect(result, equals('expected'));
  });
});
```

## 🐛 Troubleshooting

### Tests Fallan

1. **Error de dependencias**:
   ```bash
   flutter pub get
   flutter clean
   flutter pub get
   ```

2. **Error de imports**:
   - Verificar que el nombre del paquete sea correcto en pubspec.yaml
   - Verificar rutas de imports en archivos de test

3. **Timeout**:
   ```bash
   flutter test --timeout=2m
   ```

### Cobertura No Se Genera

```bash
# Asegurar que lcov esté instalado
# macOS:
brew install lcov

# Ubuntu:
sudo apt-get install lcov

# Generar cobertura
flutter test --coverage
```

## 📈 Métricas de Calidad

### Objetivos de Cobertura

- **Modelos**: 100% de cobertura
- **Servicios**: 80%+ de cobertura
- **Screens**: 70%+ de cobertura
- **Global**: 75%+ de cobertura

### Indicadores de Calidad

- ✅ Todos los tests pasan
- ✅ Sin warnings de análisis estático
- ✅ Código formateado correctamente
- ✅ Documentación actualizada
- ✅ Sin dependencias obsoletas

## 🎯 Próximos Pasos

1. **Tests de Integración**: Agregar tests end-to-end
2. **Tests de UI**: Screenshots y golden tests
3. **Performance Tests**: Medir tiempo de carga
4. **Security Tests**: Validar seguridad

## 📞 Soporte

Para problemas con tests:
1. Revisar logs con `--verbose`
2. Verificar versión de Flutter: `flutter --version`
3. Limpiar y reconstruir: `flutter clean && flutter pub get`

## 📚 Referencias

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Test Coverage](https://docs.flutter.dev/testing/code-coverage)
