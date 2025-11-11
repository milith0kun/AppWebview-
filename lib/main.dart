import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/storage_service.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'screens/server_selection_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación preferida
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Inicializar servicios
  await _initializeServices();

  runApp(const MyApp());
}

/// Inicializar todos los servicios necesarios
Future<void> _initializeServices() async {
  try {
    // Inicializar Storage Service
    await StorageService.getInstance();

    // Inicializar Firebase Service
    await FirebaseService.getInstance();

    // Inicializar Notification Service
    await NotificationService.getInstance();
  } catch (e) {
    debugPrint('Error al inicializar servicios: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Tracking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3), // Azul
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

/// Pantalla de splash que determina la pantalla inicial
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialScreen();
  }

  Future<void> _checkInitialScreen() async {
    // Esperar un poco para mostrar el splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      final storageService = await StorageService.getInstance();
      final isFirstTime = storageService.isFirstTime();

      Widget nextScreen;
      if (isFirstTime) {
        // Primera vez - mostrar selección de servidor
        nextScreen = const ServerSelectionScreen();
      } else {
        // Ya hay servidor seleccionado - ir a home
        nextScreen = const HomeScreen();
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      }
    } catch (e) {
      debugPrint('Error al verificar pantalla inicial: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ServerSelectionScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'GPS Tracking',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rastreo GPS en tiempo real',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
