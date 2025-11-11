import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';

/// Pantalla de configuración
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedSound = 'default';
  String? _fcmToken;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final storageService = await StorageService.getInstance();
      final firebaseService = await FirebaseService.getInstance();

      final sound = storageService.getNotificationSound();
      final token = await firebaseService.getToken();

      setState(() {
        _selectedSound = sound;
        _fcmToken = token;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar configuración: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveSound(String sound) async {
    try {
      final storageService = await StorageService.getInstance();
      await storageService.saveNotificationSound(sound);

      setState(() => _selectedSound = sound);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sonido guardado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar sonido: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testNotification() async {
    try {
      final notificationService = await NotificationService.getInstance();
      await notificationService.showNotification(
        title: 'Notificación de prueba',
        body: 'Esta es una notificación de prueba con el sonido seleccionado',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificación de prueba enviada'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar notificación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _copyToken() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token copiado al portapapeles'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showTokenDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Token FCM'),
        content: SelectableText(
          _fcmToken ?? 'No disponible',
          style: const TextStyle(fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _copyToken();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copiar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Sección de notificaciones
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Notificaciones',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Selector de sonido
                        Text(
                          'Sonido de notificación',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),

                        ...AppConstants.notificationSounds.map((sound) {
                          final isSelected = _selectedSound == sound;
                          return RadioListTile<String>(
                            title: Text(_getSoundName(sound)),
                            value: sound,
                            groupValue: _selectedSound,
                            onChanged: (value) {
                              if (value != null) {
                                _saveSound(value);
                              }
                            },
                            activeColor: Theme.of(context).primaryColor,
                            selected: isSelected,
                          );
                        }).toList(),

                        const SizedBox(height: 16),

                        // Botón de prueba
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _testNotification,
                            icon: const Icon(Icons.notifications),
                            label: const Text('Probar notificación'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Sección de Firebase
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.cloud,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Firebase Cloud Messaging',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Token del dispositivo',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _fcmToken != null
                                      ? '${_fcmToken!.substring(0, 30)}...'
                                      : 'No disponible',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: _showTokenDialog,
                                tooltip: 'Ver token completo',
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: _copyToken,
                                tooltip: 'Copiar token',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Este token es necesario para enviar notificaciones push a este dispositivo desde la plataforma de rastreo GPS.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Información de la app
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información de la aplicación',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Versión'),
                          trailing: Text(AppConstants.appVersion),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Nombre'),
                          trailing: Text(AppConstants.appName),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _getSoundName(String sound) {
    switch (sound) {
      case 'default':
        return 'Sonido por defecto';
      case 'alert1':
        return 'Alerta 1';
      case 'alert2':
        return 'Alerta 2';
      case 'alert3':
        return 'Alerta 3';
      default:
        return sound;
    }
  }
}
