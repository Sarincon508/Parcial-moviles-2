import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String? _customBaseUrl;

  /// Inicializa la carga del archivo .env
  static Future<void> init() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
    } catch (e) {
      debugPrint('⚠️ No se pudo cargar assets/.env, usando valores por defecto: $e');
    }
  }

  /// Retorna la URL base de la API REST.
  /// Si se ejecuta en emulador de Android y la URL contiene 'localhost',
  /// la adapta automáticamente a '10.0.2.2'.
  static String get apiBaseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }

    String url = dotenv.get('API_BASE_URL', fallback: 'http://localhost:3000/api');

    // Adaptación automática para emulador Android
    if (!kIsWeb) {
      try {
        if (Platform.isAndroid && url.contains('localhost')) {
          url = url.replaceAll('localhost', '10.0.2.2');
        }
      } catch (_) {}
    }

    return url;
  }

  /// Permite cambiar la URL base en tiempo de ejecución (útil para alternar
  /// entre servidor local, IP local de celular o despliegue en la nube).
  static void setCustomBaseUrl(String? newUrl) {
    _customBaseUrl = newUrl?.trim();
  }

  /// Tiempo de espera para las peticiones HTTP (segundos)
  static int get timeoutSeconds {
    final str = dotenv.get('API_TIMEOUT_SECONDS', fallback: '10');
    return int.tryParse(str) ?? 10;
  }
}
