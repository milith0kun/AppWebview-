/// Constantes de la aplicación
class AppConstants {
  // URLs de los servidores
  static const String server1Url = 'https://rastreo.gpsfollowme.com';
  static const String server2Url = 'https://gpsnetic.com/rastreo';

  // Nombres de los servidores
  static const String server1Name = 'GPS Follow Me';
  static const String server2Name = 'GPS Netic';

  // Claves de SharedPreferences
  static const String selectedServerKey = 'selected_server';
  static const String fcmTokenKey = 'fcm_token';
  static const String notificationSoundKey = 'notification_sound';

  // Sonidos de notificación disponibles
  static const List<String> notificationSounds = [
    'default',
    'alert1',
    'alert2',
    'alert3',
  ];

  // Canal de notificaciones
  static const String notificationChannelId = 'gps_tracking_channel';
  static const String notificationChannelName = 'Notificaciones de Rastreo';
  static const String notificationChannelDescription =
      'Notificaciones de alertas GPS';

  // Información de la app
  static const String appName = 'GPS Tracking';
  static const String appVersion = '1.0.0';
}
