import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/server_config.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';
import 'settings_screen.dart';
import 'server_selection_screen.dart';

/// Pantalla principal con WebView
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebViewController _webViewController;
  ServerConfig? _currentServer;
  bool _isLoading = true;
  String? _fcmToken;
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Obtener servidor seleccionado
      final storageService = await StorageService.getInstance();
      final server = storageService.getSelectedServer();

      if (server == null) {
        // Si no hay servidor, redirigir a la selección
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ServerSelectionScreen(),
            ),
          );
        }
        return;
      }

      setState(() => _currentServer = server);

      // Inicializar Firebase y obtener token
      final firebaseService = await FirebaseService.getInstance();
      final token = await firebaseService.getToken();
      setState(() => _fcmToken = token);

      // Configurar WebView
      _setupWebView();
    } catch (e) {
      log('Error al inicializar la app: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al inicializar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _setupWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100;
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            log('Página cargando: $url');
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            log('Página cargada: $url');
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            log('Error al cargar página: ${error.description}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al cargar: ${error.description}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Permitir toda la navegación dentro del WebView
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_currentServer!.url));

    setState(() {});
  }

  Future<void> _reloadWebView() async {
    setState(() => _isLoading = true);
    await _webViewController.reload();
  }

  Future<void> _navigateBack() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
    }
  }

  Future<void> _navigateForward() async {
    if (await _webViewController.canGoForward()) {
      await _webViewController.goForward();
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    ).then((_) {
      // Recargar configuración si es necesario
      _initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentServer == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentServer!.name),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Botón de navegación hacia atrás
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _navigateBack,
            tooltip: 'Atrás',
          ),
          // Botón de navegación hacia adelante
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _navigateForward,
            tooltip: 'Adelante',
          ),
          // Botón de recarga
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadWebView,
            tooltip: 'Recargar',
          ),
          // Botón de configuración
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de progreso
          if (_isLoading)
            LinearProgressIndicator(
              value: _loadingProgress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          // WebView
          Expanded(
            child: WebViewWidget(controller: _webViewController),
          ),
        ],
      ),
      // Drawer con información
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'GPS Tracking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _currentServer!.name,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Servidor actual'),
              subtitle: Text(_currentServer!.url),
            ),
            if (_fcmToken != null)
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title: const Text('Token FCM'),
                subtitle: Text(
                  '${_fcmToken!.substring(0, 20)}...',
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () async {
                    // Copiar el token al portapapeles
                    await Clipboard.setData(ClipboardData(text: _fcmToken!));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Token FCM copiado al portapapeles'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: _openSettings,
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Cambiar servidor'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ServerSelectionScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
