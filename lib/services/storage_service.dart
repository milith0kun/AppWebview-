import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_config.dart';
import '../utils/constants.dart';

/// Servicio para gestionar el almacenamiento local
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Servidor seleccionado
  Future<void> saveSelectedServer(ServerConfig server) async {
    await _prefs?.setString(
      AppConstants.selectedServerKey,
      jsonEncode(server.toJson()),
    );
  }

  ServerConfig? getSelectedServer() {
    final serverJson = _prefs?.getString(AppConstants.selectedServerKey);
    if (serverJson == null) return null;

    try {
      return ServerConfig.fromJson(jsonDecode(serverJson));
    } catch (e) {
      return null;
    }
  }

  Future<void> clearSelectedServer() async {
    await _prefs?.remove(AppConstants.selectedServerKey);
  }

  // Token FCM
  Future<void> saveFcmToken(String token) async {
    await _prefs?.setString(AppConstants.fcmTokenKey, token);
  }

  String? getFcmToken() {
    return _prefs?.getString(AppConstants.fcmTokenKey);
  }

  // Sonido de notificación
  Future<void> saveNotificationSound(String sound) async {
    await _prefs?.setString(AppConstants.notificationSoundKey, sound);
  }

  String getNotificationSound() {
    return _prefs?.getString(AppConstants.notificationSoundKey) ?? 'default';
  }

  // Limpiar todos los datos
  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Verificar si es la primera vez
  bool isFirstTime() {
    return getSelectedServer() == null;
  }
}
