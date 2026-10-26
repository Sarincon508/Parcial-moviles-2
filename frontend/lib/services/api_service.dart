import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/env.dart';

/// Excepción personalizada para errores de la API REST
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final List<dynamic>? errors;

  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() => message;
}

/// Cliente HTTP centralizado basado en Dio
class ApiService {
  static ApiService? _instance;
  late Dio _dio;

  ApiService._internal() {
    _initDio();
  }

  factory ApiService() {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  void _initDio() {
    final baseUrl = Env.apiBaseUrl;
    final timeout = Duration(seconds: Env.timeoutSeconds);

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor para depuración y logs de peticiones
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('🌐 [DIO REQ] ${options.method} -> ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ [DIO RES ${response.statusCode}] <- ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          debugPrint('❌ [DIO ERR ${error.response?.statusCode}] <- ${error.requestOptions.uri}');
          debugPrint('   Mensaje: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Reinicializa Dio si cambia la URL base en tiempo de ejecución
  void resetClient() {
    _initDio();
  }

  Dio get client => _dio;

  /// Método genérico para procesar errores de Dio y convertirlos a ApiException
  ApiException handleDioError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;

      // Si el backend devolvió un mensaje JSON estructurado
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message']?.toString() ?? 'Error en la petición al servidor.';
        final errors = responseData['errors'] is List ? responseData['errors'] as List : null;
        return ApiException(
          message: message,
          statusCode: statusCode,
          errors: errors,
        );
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException(
            message: 'Tiempo de espera agotado al conectar con el servidor (${Env.apiBaseUrl}). Verifique que el backend esté en ejecución.',
            statusCode: statusCode,
          );
        case DioExceptionType.connectionError:
          return ApiException(
            message: 'No se pudo establecer conexión con el backend en "${Env.apiBaseUrl}". Asegúrese de que el servidor esté activo y accesible desde este dispositivo.',
            statusCode: statusCode,
          );
        case DioExceptionType.badResponse:
          if (statusCode == 404) {
            return ApiException(message: 'El recurso solicitado no fue encontrado (404).', statusCode: 404);
          } else if (statusCode == 422) {
            return ApiException(message: 'Error de validación en los datos enviados (422).', statusCode: 422);
          } else if (statusCode == 500) {
            return ApiException(message: 'Error interno en el servidor del backend (500).', statusCode: 500);
          }
          return ApiException(message: 'Error HTTP $statusCode devuelto por el servidor.', statusCode: statusCode);
        case DioExceptionType.cancel:
          return ApiException(message: 'La petición fue cancelada.');
        default:
          return ApiException(message: 'Error de red o comunicación: ${error.message}');
      }
    }

    if (error is ApiException) {
      return error;
    }

    return ApiException(message: 'Error inesperado: $error');
  }
}
