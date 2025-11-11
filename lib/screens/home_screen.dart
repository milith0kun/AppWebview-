import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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
  WebViewController? _webViewController;
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

      // Si estamos en web, no inicializar WebView ni Firebase
      if (kIsWeb) {
        setState(() => _isLoading = false);
        return;
      }

      // Inicializar Firebase y obtener token (solo móviles)
      try {
        final firebaseService = await FirebaseService.getInstance();
        final token = await firebaseService.getToken();
        setState(() => _fcmToken = token);
      } catch (e) {
        log('Error al obtener token Firebase: $e');
      }

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
    if (_webViewController != null) {
      setState(() => _isLoading = true);
      await _webViewController!.reload();
    }
  }

  Future<void> _navigateBack() async {
    if (_webViewController != null && await _webViewController!.canGoBack()) {
      await _webViewController!.goBack();
    }
  }

  Future<void> _navigateForward() async {
    if (_webViewController != null && await _webViewController!.canGoForward()) {
      await _webViewController!.goForward();
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

  Future<void> _openInBrowser() async {
    if (_currentServer != null) {
      final uri = Uri.parse(_currentServer!.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
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

    // Vista especial para plataforma web
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_currentServer!.name),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _openSettings,
              tooltip: 'Configuración',
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  size: 120,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 32),
                const Text(
                  'App de Rastreo GPS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                  const Text(
                    'Esta aplicación está optimizada para dispositivos móviles (Android/iOS).',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                const SizedBox(height: 8),
                Text(
                  'Servidor configurado: ${_currentServer!.name}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _openInBrowser,
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Abrir en navegador'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ServerSelectionScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Cambiar servidor'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Vista normal con WebView para móviles
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
      body: Stack(
        children: [
          if (_webViewController != null)
            WebViewWidget(controller: _webViewController!),
          if (_isLoading)
            LinearProgressIndicator(value: _loadingProgress),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
