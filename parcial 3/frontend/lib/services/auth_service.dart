import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Servicio encargado del consumo de la API de autenticación mediante Dio
class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService({
    ApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? StorageService();

  /// Realiza la autenticación con el backend mediante POST /auth/login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.client.post(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
        options: Options(
          headers: {
            // Evitar enviar cualquier token previo durante el login
            'Authorization': null,
          },
        ),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      if (authResponse.success && authResponse.token != null && authResponse.user != null) {
        // Almacenar el token en secure storage y el usuario en SharedPreferences
        await _storageService.saveAuthData(
          token: authResponse.token!,
          user: authResponse.user!,
        );
      }

      return authResponse;
    } catch (e) {
      throw _apiService.handleDioError(e);
    }
  }

  /// Consulta el perfil del usuario autenticado en GET /auth/perfil
  Future<User> getProfile() async {
    try {
      final response = await _apiService.client.get('/auth/perfil');
      final data = response.data['data'] as Map<String, dynamic>;
      return User.fromJson(data['usuario']);
    } catch (e) {
      throw _apiService.handleDioError(e);
    }
  }

  /// Cierra la sesión eliminando las credenciales de almacenamiento local
  Future<void> logout() async {
    await _storageService.clearAuthData();
  }
}
