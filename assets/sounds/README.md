# Archivos de Sonido para Notificaciones

Esta carpeta contiene los archivos de sonido personalizados para las notificaciones de la aplicación GPS Tracking.

## Archivos Requeridos

Para que las notificaciones personalizadas funcionen correctamente, debes agregar los siguientes archivos de audio:

### Android
- `alert1.mp3` - Sonido de alerta 1
- `alert2.mp3` - Sonido de alerta 2
- `alert3.mp3` - Sonido de alerta 3

### iOS
- `alert1.aiff` o `alert1.caf` - Sonido de alerta 1
- `alert2.aiff` o `alert2.caf` - Sonido de alerta 2
- `alert3.aiff` o `alert3.caf` - Sonido de alerta 3

## Formatos Soportados

- **Android**: MP3, WAV, OGG
- **iOS**: AIFF, CAF, WAV (iOS requiere formatos específicos)

## Especificaciones Técnicas

- **Duración recomendada**: 1-5 segundos
- **Calidad**: 44.1 kHz, 16-bit para mejor compatibilidad
- **Tamaño**: Mantener archivos pequeños (< 500 KB) para mejor rendimiento

## Notas

- El sonido `default` usa el tono de notificación del sistema operativo
- Los archivos deben nombrarse exactamente como se especifica arriba
- Para iOS, convertir archivos MP3 a formato CAF usando: `afconvert -f caff -d LEI16 input.mp3 output.caf`

## Configuración en pubspec.yaml

Los archivos ya están configurados en `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/sounds/
```

## Ejemplo de Conversión para iOS

```bash
# Convertir MP3 a CAF (en macOS)
afconvert -f caff -d LEI16@44100 -c 1 alert1.mp3 alert1.caf
```
