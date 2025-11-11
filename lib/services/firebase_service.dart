import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';
import 'storage_service.dart';

/// Handler para mensajes en segundo plano
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Mensaje recibido en segundo plano: ${message.messageId}');

  // Mostrar notificación
  final notificationService = await NotificationService.getInstance();
  await notificationService.showNotification(
    title: message.notification?.title ?? 'Nueva notificación',
    body: message.notification?.body ?? '',
    payload: message.data.toString(),
  );
}

/// Servicio para gestionar Firebase Cloud Messaging
class FirebaseService {
  static FirebaseService? _instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FirebaseService._();

  static Future<FirebaseService> getInstance() async {
    if (_instance == null) {
      _instance = FirebaseService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    try {
      // Inicializar Firebase
      await Firebase.initializeApp();

      // Configurar handler para mensajes en segundo plano
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Solicitar permisos
      await _requestPermissions();

      // Obtener y guardar token
      await _getAndSaveToken();

      // Configurar listeners
      _setupListeners();

      log('Firebase Service inicializado correctamente');
    } catch (e) {
      log('Error al inicializar Firebase Service: $e');
    }
  }

  /// Solicitar permisos de notificaciones
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    log('Permisos de notificación: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('Usuario concedió permisos de notificación');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('Usuario concedió permisos provisionales');
    } else {
      log('Usuario denegó permisos de notificación');
    }
  }

  /// Obtener y guardar el token FCM
  Future<String?> _getAndSaveToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        log('FCM Token: $token');
        final storageService = await StorageService.getInstance();
        await storageService.saveFcmToken(token);
        return token;
      }
    } catch (e) {
      log('Error al obtener FCM Token: $e');
    }
    return null;
  }

  /// Configurar listeners de mensajes
  void _setupListeners() {
    // Mensaje cuando la app está en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Mensaje recibido en primer plano: ${message.messageId}');

      if (message.notification != null) {
        log('Título: ${message.notification!.title}');
        log('Cuerpo: ${message.notification!.body}');

        // Mostrar notificación local
        final notificationService = await NotificationService.getInstance();
        await notificationService.showNotification(
          title: message.notification!.title ?? 'Nueva notificación',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // Cuando el usuario toca una notificación para abrir la app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notificación tocada: ${message.messageId}');
      // Aquí puedes navegar a una pantalla específica si es necesario
    });

    // Refrescar token cuando cambie
    _messaging.onTokenRefresh.listen((String token) async {
      log('FCM Token actualizado: $token');
      final storageService = await StorageService.getInstance();
      await storageService.saveFcmToken(token);
    });
  }

  /// Obtener el token FCM actual
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        final storageService = await StorageService.getInstance();
        await storageService.saveFcmToken(token);
      }
      return token;
    } catch (e) {
      log('Error al obtener token: $e');
      return null;
    }
  }

  /// Suscribirse a un topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      log('Suscrito al topic: $topic');
    } catch (e) {
      log('Error al suscribirse al topic: $e');
    }
  }

  /// Desuscribirse de un topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      log('Desuscrito del topic: $topic');
    } catch (e) {
      log('Error al desuscribirse del topic: $e');
    }
  }

  /// Eliminar token
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      log('Token FCM eliminado');
    } catch (e) {
      log('Error al eliminar token: $e');
    }
  }
}
