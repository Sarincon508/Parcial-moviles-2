import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

enum AuthStatus {
  initial,
  checking,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final StorageService _storageService;
  final ApiService _apiService;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _tokenPreview;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({
    AuthService? authService,
    StorageService? storageService,
    ApiService? apiService,
  })  : _authService = authService ?? AuthService(),
        _storageService = storageService ?? StorageService(),
        _apiService = apiService ?? ApiService() {
    // Suscribirse a errores 401 de Dio para cerrar sesión automáticamente
    _apiService.onUnauthorized = () {
      if (_status == AuthStatus.authenticated) {
        debugPrint('🚪 [AuthProvider] Sesión expirada detectada por Dio. Cerrando sesión local.');
        logout();
      }
    };
  }

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isChecking => _status == AuthStatus.checking || _status == AuthStatus.initial;
  User? get user => _user;
  String? get tokenPreview => _tokenPreview;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Limpia los mensajes de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Verifica la validez de la sesión almacenada en el arranque de la app
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.checking;
    notifyListeners();

    try {
      final hasToken = await _storageService.hasToken();

      if (!hasToken) {
        _user = null;
        _tokenPreview = null;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return;
      }

      // Si existe token, cargar usuario guardado en SharedPreferences
      final localUser = await _storageService.getUser();
      if (localUser != null) {
        _user = localUser;
        _tokenPreview = await _storageService.getTokenPreview();
        _status = AuthStatus.authenticated;
        notifyListeners();

        // Verificar token en segundo plano contra el backend
        try {
          final serverUser = await _authService.getProfile();
          _user = serverUser;
          notifyListeners();
        } catch (e) {
          if (e is ApiException && e.statusCode == 401) {
            // El token en el servidor fue revocado o expiró
            await logout();
            return;
          }
        }
      } else {
        // Si hay token pero no datos de usuario, intentar obtener perfil
        try {
          final serverUser = await _authService.getProfile();
          _user = serverUser;
          _tokenPreview = await _storageService.getTokenPreview();
          _status = AuthStatus.authenticated;
          notifyListeners();
        } catch (_) {
          await logout();
        }
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  /// Inicia sesión con credenciales
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(email: email, password: password);

      if (response.success && response.user != null) {
        _user = response.user;
        _tokenPreview = await _storageService.getTokenPreview();
        _status = AuthStatus.authenticated;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : 'Error de autenticación: No se recibió información del usuario.';
        _status = AuthStatus.unauthenticated;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cierra sesión y limpia los datos de almacenamiento seguro y SharedPreferences
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (_) {}

    _user = null;
    _tokenPreview = null;
    _errorMessage = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Actualiza la vista previa del token (útil para la pantalla de información de sesión)
  Future<void> refreshTokenPreview() async {
    _tokenPreview = await _storageService.getTokenPreview();
    notifyListeners();
  }
}
