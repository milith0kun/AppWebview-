import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

/// Servicio para gestionar notificaciones locales
class NotificationService {
  static NotificationService? _instance;
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationService._();

  static Future<NotificationService> getInstance() async {
    if (_instance == null) {
      _instance = NotificationService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    try {
      // Configuración de Android
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración de iOS
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      );

      // Configuración general
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Inicializar
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Crear canal de notificaciones para Android
      await _createNotificationChannel();

      log('Notification Service inicializado correctamente');
    } catch (e) {
      log('Error al inicializar Notification Service: $e');
    }
  }

  /// Crear canal de notificaciones para Android
  Future<void> _createNotificationChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        AppConstants.notificationChannelId,
        AppConstants.notificationChannelName,
        description: AppConstants.notificationChannelDescription,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Callback cuando se toca una notificación
  void _onNotificationTapped(NotificationResponse response) {
    log('Notificación tocada: ${response.payload}');
    // Aquí puedes manejar la navegación cuando se toca la notificación
  }

  /// Mostrar una notificación
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final storageService = await StorageService.getInstance();
      final sound = storageService.getNotificationSound();

      // Configuración de Android
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        AppConstants.notificationChannelId,
        AppConstants.notificationChannelName,
        channelDescription: AppConstants.notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: sound == 'default'
            ? null
            : RawResourceAndroidNotificationSound(sound),
        enableVibration: true,
        enableLights: true,
        showWhen: true,
        when: DateTime.now().millisecondsSinceEpoch,
        usesChronometer: false,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      );

      // Configuración de iOS
      DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: sound == 'default' ? null : '$sound.aiff',
        badgeNumber: 1,
        threadIdentifier: AppConstants.notificationChannelId,
      );

      NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
        payload: payload,
      );

      log('Notificación mostrada: $title');
    } catch (e) {
      log('Error al mostrar notificación: $e');
    }
  }

  /// Cancelar todas las notificaciones
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    log('Todas las notificaciones canceladas');
  }

  /// Cancelar una notificación específica
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
    log('Notificación $id cancelada');
  }

  /// Obtener notificaciones pendientes
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Obtener notificaciones activas
  Future<List<ActiveNotification>> getActiveNotifications() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final plugin = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await plugin?.getActiveNotifications() ?? [];
    }
    return [];
  }
}
