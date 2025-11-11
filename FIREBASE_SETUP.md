# Guía Completa de Configuración de Firebase

Esta guía te ayudará a configurar Firebase Cloud Messaging para tu aplicación de rastreo GPS.

## 📋 Índice

1. [Crear Proyecto en Firebase](#1-crear-proyecto-en-firebase)
2. [Configurar Android](#2-configurar-android)
3. [Configurar iOS](#3-configurar-ios)
4. [Probar Notificaciones](#4-probar-notificaciones)
5. [Integración con tu Servidor](#5-integración-con-tu-servidor)

## 1. Crear Proyecto en Firebase

### Paso 1: Acceder a Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Inicia sesión con tu cuenta de Google
3. Haz clic en "Agregar proyecto" o "Add project"

### Paso 2: Crear el Proyecto

1. Nombre del proyecto: `GPS Tracking App` (o el nombre que prefieras)
2. ID del proyecto: Se generará automáticamente (puedes personalizarlo)
3. Acepta los términos y condiciones
4. (Opcional) Habilita Google Analytics
5. Haz clic en "Crear proyecto"

### Paso 3: Habilitar Cloud Messaging

1. Una vez creado el proyecto, ve a "Project Settings" (⚙️)
2. Selecciona la pestaña "Cloud Messaging"
3. Verifica que Cloud Messaging API esté habilitado
4. Si no lo está, haz clic en "Enable" en Google Cloud Console

## 2. Configurar Android

### Paso 1: Agregar App Android

1. En la página principal del proyecto, haz clic en el ícono de Android
2. Package name: `com.gpstracking.app` (debe coincidir exactamente)
3. (Opcional) Nickname de la app: "GPS Tracking Android"
4. (Opcional) SHA-1 certificate (necesario para algunas funciones avanzadas)
5. Haz clic en "Registrar app"

### Paso 2: Descargar google-services.json

1. Descarga el archivo `google-services.json`
2. Copia el archivo a la ruta: `android/app/google-services.json`
3. **IMPORTANTE**: Reemplaza el archivo placeholder existente

### Paso 3: Verificar Configuración

El archivo `google-services.json` debe contener algo como:

```json
{
  "project_info": {
    "project_number": "123456789012",
    "project_id": "gps-tracking-app-xxxxx",
    "storage_bucket": "gps-tracking-app-xxxxx.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:android:abcdef123456",
        "android_client_info": {
          "package_name": "com.gpstracking.app"
        }
      },
      // ... más configuración
    }
  ]
}
```

### Paso 4: Compilar y Probar

```bash
flutter clean
flutter pub get
flutter run
```

## 3. Configurar iOS

### Paso 1: Agregar App iOS

1. En la página principal del proyecto de Firebase, haz clic en el ícono de iOS
2. Bundle ID: `com.gpstracking.app` (debe coincidir exactamente)
3. (Opcional) Nickname de la app: "GPS Tracking iOS"
4. (Opcional) App Store ID
5. Haz clic en "Registrar app"

### Paso 2: Descargar GoogleService-Info.plist

1. Descarga el archivo `GoogleService-Info.plist`
2. **IMPORTANTE**: Reemplaza el archivo en `ios/Runner/GoogleService-Info.plist`

### Paso 3: Agregar el Archivo a Xcode

1. Abre el proyecto en Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. En el navegador de proyectos, haz clic derecho en "Runner"
3. Selecciona "Add Files to Runner"
4. Navega hasta `ios/Runner/GoogleService-Info.plist`
5. Asegúrate de marcar "Copy items if needed"
6. Haz clic en "Add"

### Paso 4: Habilitar Push Notifications en Xcode

1. En Xcode, selecciona el proyecto "Runner"
2. Ve a "Signing & Capabilities"
3. Haz clic en "+ Capability"
4. Busca y agrega "Push Notifications"
5. Agrega también "Background Modes"
6. Marca las opciones:
   - ✅ Remote notifications
   - ✅ Background fetch

### Paso 5: Configurar APNs (Apple Push Notification service)

1. Ve a [Apple Developer](https://developer.apple.com/)
2. Navega a "Certificates, Identifiers & Profiles"
3. Selecciona "Keys"
4. Crea una nueva Key con capacidad de APNs
5. Descarga el archivo `.p8`
6. En Firebase Console, ve a Project Settings > Cloud Messaging
7. En la sección "Apple app configuration", haz clic en "Upload"
8. Sube el archivo `.p8` y proporciona:
   - Key ID
   - Team ID (puedes encontrarlo en tu cuenta de Apple Developer)

### Paso 6: Compilar y Probar

```bash
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

## 4. Probar Notificaciones

### Método 1: Desde Firebase Console

1. Ve a Firebase Console
2. Navega a "Cloud Messaging" en el menú lateral
3. Haz clic en "Send your first message"
4. Escribe un título y mensaje
5. Haz clic en "Send test message"
6. Pega el token FCM de tu dispositivo (disponible en la app)
7. Haz clic en "Test"

### Método 2: Usando cURL (Linux/Mac)

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_TOKEN_HERE",
    "notification": {
      "title": "Prueba de Notificación",
      "body": "Esta es una notificación de prueba"
    },
    "priority": "high"
  }'
```

### Método 3: Usando Postman

1. Método: POST
2. URL: `https://fcm.googleapis.com/fcm/send`
3. Headers:
   ```
   Authorization: key=YOUR_SERVER_KEY
   Content-Type: application/json
   ```
4. Body (raw JSON):
   ```json
   {
     "to": "DEVICE_TOKEN_HERE",
     "notification": {
       "title": "Prueba de Notificación",
       "body": "Esta es una notificación de prueba"
     },
     "priority": "high"
   }
   ```

## 5. Integración con tu Servidor

### Obtener Server Key

1. Ve a Firebase Console
2. Project Settings > Cloud Messaging
3. Copia el "Server key" (también llamado Legacy server key)
4. **IMPORTANTE**: Guarda esta clave de forma segura

### Ejemplo de Integración - PHP

```php
<?php
function sendPushNotification($deviceToken, $title, $body) {
    $url = 'https://fcm.googleapis.com/fcm/send';
    $serverKey = 'YOUR_SERVER_KEY'; // Tu server key de Firebase

    $notification = array(
        'title' => $title,
        'body' => $body,
        'sound' => 'default'
    );

    $data = array(
        'click_action' => 'FLUTTER_NOTIFICATION_CLICK'
    );

    $fields = array(
        'to' => $deviceToken,
        'notification' => $notification,
        'data' => $data,
        'priority' => 'high'
    );

    $headers = array(
        'Authorization: key=' . $serverKey,
        'Content-Type: application/json'
    );

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

    $result = curl_exec($ch);
    curl_close($ch);

    return $result;
}

// Uso
$token = "TOKEN_DEL_DISPOSITIVO";
$result = sendPushNotification($token, "Alerta GPS", "Su vehículo ha salido de la zona segura");
echo $result;
?>
```

### Ejemplo de Integración - Node.js

```javascript
const admin = require('firebase-admin');

// Inicializar Firebase Admin SDK
const serviceAccount = require('./path/to/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Función para enviar notificación
async function sendPushNotification(deviceToken, title, body) {
  const message = {
    notification: {
      title: title,
      body: body
    },
    data: {
      click_action: 'FLUTTER_NOTIFICATION_CLICK'
    },
    token: deviceToken
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    return response;
  } catch (error) {
    console.log('Error sending message:', error);
    throw error;
  }
}

// Uso
const token = "TOKEN_DEL_DISPOSITIVO";
sendPushNotification(token, "Alerta GPS", "Su vehículo ha salido de la zona segura");
```

### Ejemplo de Integración - Python

```python
import requests
import json

def send_push_notification(device_token, title, body):
    url = 'https://fcm.googleapis.com/fcm/send'
    server_key = 'YOUR_SERVER_KEY'  # Tu server key de Firebase

    headers = {
        'Authorization': f'key={server_key}',
        'Content-Type': 'application/json'
    }

    payload = {
        'to': device_token,
        'notification': {
            'title': title,
            'body': body,
            'sound': 'default'
        },
        'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK'
        },
        'priority': 'high'
    }

    response = requests.post(url, headers=headers, data=json.dumps(payload))
    return response.json()

# Uso
token = "TOKEN_DEL_DISPOSITIVO"
result = send_push_notification(token, "Alerta GPS", "Su vehículo ha salido de la zona segura")
print(result)
```

## 📝 Notas Importantes

### Tokens FCM

- Cada dispositivo tiene un token único
- Los tokens pueden cambiar con el tiempo
- Tu servidor debe actualizar los tokens cuando cambien
- Los tokens se invalidan si:
  - El usuario desinstala la app
  - El usuario borra los datos de la app
  - El usuario reinstala la app

### Límites de FCM

- **Payload máximo**: 4KB
- **TTL (Time To Live)**: Máximo 4 semanas
- **Rate limiting**: Consulta la documentación de Firebase para límites específicos

### Mejores Prácticas

1. **Almacena los tokens de forma segura** en tu base de datos
2. **Maneja tokens inválidos**: Elimina tokens que FCM rechace
3. **Implementa reintentos**: Si una notificación falla, reintenta con backoff exponencial
4. **Usa topics** para enviar notificaciones a grupos de usuarios
5. **Personaliza las notificaciones** según el tipo de alerta

### Solución de Problemas Comunes

#### Android

**Error**: "google-services.json not found"
- **Solución**: Verifica que el archivo esté en `android/app/google-services.json`

**Error**: "Failed to get FCM token"
- **Solución**: Verifica que Google Play Services esté actualizado en el dispositivo

#### iOS

**Error**: "No APNs token"
- **Solución**: Verifica que hayas configurado APNs correctamente en Firebase Console

**Error**: "Missing Push Notification Entitlement"
- **Solución**: Agrega la capability "Push Notifications" en Xcode

## 🔗 Enlaces Útiles

- [Firebase Console](https://console.firebase.google.com/)
- [Documentación de FCM](https://firebase.google.com/docs/cloud-messaging)
- [Apple Developer Portal](https://developer.apple.com/)
- [Google Play Console](https://play.google.com/console)

---

**Última actualización**: Noviembre 2024
