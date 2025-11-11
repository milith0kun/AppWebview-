# GPS Tracking App

Aplicación móvil multiplataforma (Android/iOS) para rastreo GPS con WebView integrado y notificaciones push mediante Firebase Cloud Messaging.

## 📋 Características Principales

- ✅ **WebView integrado** para cargar plataformas de rastreo GPS
- ✅ **Selector de servidor** persistente con dos opciones predefinidas
- ✅ **Notificaciones Push** mediante Firebase Cloud Messaging (FCM)
- ✅ **Notificaciones en segundo plano** incluso con la app cerrada
- ✅ **Sonidos personalizados** para notificaciones
- ✅ **Compatibilidad**: Android 8+ (API 26) y iOS 13+

## 🚀 Servidores Soportados

1. **GPS Follow Me**: https://rastreo.gpsfollowme.com
2. **GPS Netic**: https://gpsnetic.com/rastreo

## 📦 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   └── server_config.dart    # Modelo de configuración de servidor
├── screens/
│   ├── server_selection_screen.dart  # Pantalla de selección de servidor
│   ├── home_screen.dart              # Pantalla principal con WebView
│   └── settings_screen.dart          # Pantalla de configuración
├── services/
│   ├── storage_service.dart          # Servicio de almacenamiento local
│   ├── firebase_service.dart         # Servicio de Firebase Cloud Messaging
│   └── notification_service.dart     # Servicio de notificaciones locales
└── utils/
    └── constants.dart                # Constantes de la aplicación

android/
├── app/
│   ├── build.gradle.kts             # Configuración de Gradle
│   ├── google-services.json         # Configuración de Firebase (requiere configuración)
│   └── src/main/AndroidManifest.xml # Manifiesto de Android

ios/
└── Runner/
    ├── Info.plist                   # Configuración de iOS
    └── GoogleService-Info.plist     # Configuración de Firebase (requiere configuración)

assets/
└── sounds/                          # Sonidos de notificación personalizados
```

## 🛠️ Configuración Inicial

### Prerequisitos

- Flutter SDK 3.9.2 o superior
- Dart SDK 3.9.2 o superior
- Android Studio / Xcode (según la plataforma)
- Cuenta de Firebase con un proyecto configurado

### 1. Instalación de Dependencias

```bash
flutter pub get
```

### 2. Configuración de Firebase

#### Android

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Agrega una aplicación Android con el package name: `com.gpstracking.app`
4. Descarga el archivo `google-services.json`
5. Reemplaza el archivo en `android/app/google-services.json`

#### iOS

1. En Firebase Console, agrega una aplicación iOS con el bundle ID: `com.gpstracking.app`
2. Descarga el archivo `GoogleService-Info.plist`
3. Reemplaza el archivo en `ios/Runner/GoogleService-Info.plist`
4. Abre el proyecto en Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
5. Arrastra el archivo `GoogleService-Info.plist` al proyecto en Xcode
6. Asegúrate de que el deployment target sea iOS 13.0 o superior

### 3. Compilar la Aplicación

#### Android

**Debug APK:**
```bash
flutter build apk --debug
```

**Release APK:**
```bash
flutter build apk --release
```

**App Bundle (para Google Play Store):**
```bash
flutter build appbundle --release
```

Los archivos generados se encuentran en:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

#### iOS

**Debug:**
```bash
flutter build ios --debug
```

**Release:**
```bash
flutter build ios --release
```

Para distribuir en TestFlight:
1. Abre el proyecto en Xcode: `open ios/Runner.xcworkspace`
2. Configura tu equipo de desarrollo (Signing & Capabilities)
3. Selecciona "Any iOS Device" como destino
4. Product > Archive
5. Sube a App Store Connect

## 🔧 Configuración Avanzada

### Cambiar URLs de Servidores

Para modificar las URLs de los servidores, edita el archivo `lib/utils/constants.dart`:

```dart
class AppConstants {
  // URLs de los servidores
  static const String server1Url = 'https://rastreo.gpsfollowme.com';
  static const String server2Url = 'https://gpsnetic.com/rastreo';

  // Nombres de los servidores
  static const String server1Name = 'GPS Follow Me';
  static const String server2Name = 'GPS Netic';

  // ... resto del código
}
```

### Agregar Sonidos de Notificación Personalizados

#### Android

1. Coloca archivos de sonido (`.mp3`, `.wav`, `.ogg`) en `android/app/src/main/res/raw/`
2. Los nombres deben coincidir con los definidos en `constants.dart`

#### iOS

1. Coloca archivos de sonido (`.aiff`, `.caf`, `.wav`) en `ios/Runner/`
2. Añádelos al proyecto en Xcode
3. Los nombres deben coincidir con los definidos en `constants.dart`

### Actualizar Lista de Sonidos

Edita `lib/utils/constants.dart`:

```dart
static const List<String> notificationSounds = [
  'default',
  'alert1',
  'alert2',
  'alert3',
  // Agrega más sonidos aquí
];
```

## 📱 Uso de la Aplicación

### Primera Vez

1. Al abrir la app, aparecerá la pantalla de selección de servidor
2. Elige el servidor que deseas utilizar
3. La selección se guardará automáticamente

### Pantalla Principal

- **WebView**: Muestra la plataforma de rastreo GPS seleccionada
- **Botones de navegación**: Atrás, adelante y recargar
- **Menú lateral**: Información del servidor y token FCM
- **Configuración**: Accede desde el ícono de ajustes

### Configuración

- **Sonido de notificación**: Selecciona un sonido personalizado
- **Token FCM**: Visualiza y copia el token para configurar en tu servidor
- **Cambiar servidor**: Regresa a la selección de servidor

## 🔔 Notificaciones Push

### Configuración en tu Servidor

Para enviar notificaciones desde tu plataforma de rastreo GPS:

1. Obtén el token FCM desde la pantalla de configuración de la app
2. Configura tu servidor para enviar notificaciones usando la API de FCM
3. Formato del mensaje:

```json
{
  "to": "TOKEN_FCM_DEL_DISPOSITIVO",
  "notification": {
    "title": "Título de la notificación",
    "body": "Mensaje de la notificación"
  },
  "priority": "high",
  "data": {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "custom_key": "custom_value"
  }
}
```

### Endpoint de Firebase

```
POST https://fcm.googleapis.com/fcm/send
Headers:
  Authorization: key=YOUR_SERVER_KEY
  Content-Type: application/json
```

## 🔐 Permisos Requeridos

### Android

- `INTERNET`: Acceso a internet
- `ACCESS_NETWORK_STATE`: Estado de la red
- `WAKE_LOCK`: Mantener dispositivo despierto
- `VIBRATE`: Vibración para notificaciones
- `POST_NOTIFICATIONS`: Mostrar notificaciones (Android 13+)
- `RECEIVE_BOOT_COMPLETED`: Recibir notificaciones después de reinicio

### iOS

- Notificaciones push
- Acceso a internet
- Background modes (fetch, remote-notification)

## 🐛 Solución de Problemas

### Las notificaciones no llegan

1. Verifica que Firebase esté configurado correctamente
2. Asegúrate de que el token FCM sea correcto
3. Revisa los permisos de notificación en el dispositivo
4. Verifica que tu servidor esté enviando las notificaciones correctamente

### El WebView no carga

1. Verifica tu conexión a internet
2. Asegúrate de que la URL del servidor sea correcta
3. Revisa los permisos de internet en AndroidManifest.xml

### Error al compilar Android

1. Limpia el proyecto:
   ```bash
   flutter clean
   flutter pub get
   ```
2. Verifica que `google-services.json` esté en la ubicación correcta
3. Asegúrate de tener la última versión de Android SDK

### Error al compilar iOS

1. Limpia el proyecto:
   ```bash
   flutter clean
   cd ios
   pod deintegrate
   pod install
   cd ..
   ```
2. Verifica que `GoogleService-Info.plist` esté agregado al proyecto en Xcode
3. Asegúrate de tener Xcode actualizado

## 📄 Licencia

Este proyecto es privado y confidencial.

## 👨‍💻 Soporte

Para cualquier duda o problema, contacta al equipo de desarrollo.

---

**Versión**: 1.0.0
**Última actualización**: Noviembre 2024
