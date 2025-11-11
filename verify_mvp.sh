#!/bin/bash

# Script de Verificación del MVP - GPS Tracking App
# Este script verifica que todos los componentes del MVP estén en su lugar

echo "🚀 Verificando GPS Tracking App MVP..."
echo "========================================"
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contador de verificaciones
PASSED=0
FAILED=0

# Función para verificar archivo
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $2 - FALTA: $1"
        ((FAILED++))
    fi
}

# Función para verificar directorio
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $2 - FALTA: $1"
        ((FAILED++))
    fi
}

echo "📁 Verificando Estructura de Archivos..."
echo "----------------------------------------"

# Archivos principales
check_file "lib/main.dart" "Main application file"
check_file "pubspec.yaml" "Package configuration"
check_file "README.md" "README documentation"

echo ""
echo "📊 Verificando Modelos..."
echo "----------------------------------------"
check_file "lib/models/server_config.dart" "ServerConfig model"

echo ""
echo "🎨 Verificando Pantallas..."
echo "----------------------------------------"
check_file "lib/screens/server_selection_screen.dart" "Server Selection Screen"
check_file "lib/screens/home_screen.dart" "Home Screen"
check_file "lib/screens/settings_screen.dart" "Settings Screen"

echo ""
echo "⚙️  Verificando Servicios..."
echo "----------------------------------------"
check_file "lib/services/storage_service.dart" "Storage Service"
check_file "lib/services/firebase_service.dart" "Firebase Service"
check_file "lib/services/notification_service.dart" "Notification Service"

echo ""
echo "🔧 Verificando Utilidades..."
echo "----------------------------------------"
check_file "lib/utils/constants.dart" "Constants"

echo ""
echo "🧪 Verificando Tests..."
echo "----------------------------------------"
check_file "test/models/server_config_test.dart" "ServerConfig tests"
check_file "test/services/storage_service_test.dart" "StorageService tests"
check_file "test/services/notification_service_test.dart" "NotificationService tests"
check_file "test/screens/server_selection_screen_test.dart" "ServerSelectionScreen tests"
check_file "test/screens/settings_screen_test.dart" "SettingsScreen tests"
check_file "test/main_test.dart" "Main app tests"

echo ""
echo "📱 Verificando Configuración Android..."
echo "----------------------------------------"
check_file "android/app/build.gradle.kts" "Android build config"
check_file "android/app/src/main/AndroidManifest.xml" "Android manifest"
check_file "android/app/google-services.json" "Google Services (Firebase)"

echo ""
echo "🍎 Verificando Configuración iOS..."
echo "----------------------------------------"
check_file "ios/Runner/Info.plist" "iOS Info.plist"
check_file "ios/Runner/GoogleService-Info.plist" "iOS Google Services"

echo ""
echo "📚 Verificando Documentación..."
echo "----------------------------------------"
check_file "README.md" "README principal"
check_file "FIREBASE_SETUP.md" "Guía de Firebase"
check_file "TESTING.md" "Guía de testing"
check_file "MVP.md" "Documentación MVP"
check_file "NEXT_STEPS.md" "Próximos pasos"

echo ""
echo "📦 Verificando Assets..."
echo "----------------------------------------"
check_dir "assets/sounds" "Directorio de sonidos"
check_file "assets/sounds/README.md" "README de sonidos"

echo ""
echo "========================================"
echo "📊 RESUMEN DE VERIFICACIÓN"
echo "========================================"
echo -e "${GREEN}Verificaciones exitosas: $PASSED${NC}"
echo -e "${RED}Verificaciones fallidas: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ ¡MVP COMPLETAMENTE VERIFICADO!${NC}"
    echo ""
    echo "El proyecto está listo para:"
    echo "  • Demostración al cliente"
    echo "  • Compilación de producción"
    echo "  • Deployment"
    echo ""
    echo "Próximos pasos sugeridos:"
    echo "  1. flutter pub get"
    echo "  2. flutter test"
    echo "  3. flutter run"
    echo ""
    exit 0
else
    echo -e "${YELLOW}⚠️  ADVERTENCIA: Algunas verificaciones fallaron${NC}"
    echo ""
    echo "Por favor, revisa los archivos faltantes arriba."
    echo ""
    exit 1
fi
