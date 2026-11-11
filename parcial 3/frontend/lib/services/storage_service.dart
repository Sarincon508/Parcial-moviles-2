import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Servicio de almacenamiento local híbrido:
/// - flutter_secure_storage: Almacenamiento cifrado y seguro para el Access Token JWT.
/// - shared_preferences: Almacenamiento local para datos no sensibles del perfil de usuario y preferencias.
class StorageService {
  static const String _keyToken = 'jwt_access_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_nombre';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRol = 'user_rol';

  final FlutterSecureStorage _secureStorage;

  StorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  /// Guarda el token en secure storage y la información no sensible en SharedPreferences
  Future<void> saveAuthData({
    required String token,
    required User user,
  }) async {
    // 1. Guardar token de forma segura
    await _secureStorage.write(key: _keyToken, value: token);

    // 2. Guardar datos no sensibles en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, user.id);
    await prefs.setString(_keyUserName, user.nombre);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserRol, user.rol);
  }

  /// Recupera el token JWT desde secure storage
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _keyToken);
    } catch (_) {
      return null;
    }
  }

  /// Verifica si existe un token almacenado
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Recupera la información del usuario desde SharedPreferences
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_keyUserId);
    final nombre = prefs.getString(_keyUserName);
    final email = prefs.getString(_keyUserEmail);
    final rol = prefs.getString(_keyUserRol);

    if (id != null && nombre != null && email != null) {
      return User(
        id: id,
        nombre: nombre,
        email: email,
        rol: rol ?? 'operador',
      );
    }
    return null;
  }

  /// Genera una vista previa enmascarada del token para la pantalla de información de sesión
  /// Cumple con: "Indicador de existencia del token almacenado, sin mostrar su contenido completo"
  Future<String> getTokenPreview() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return 'No hay token almacenado';
    }
    if (token.length <= 16) {
      return 'eyJ*** (Token activo)';
    }
    final prefix = token.substring(0, 10);
    final suffix = token.substring(token.length - 6);
    return '$prefix...[TOKEN_PROTEGIDO_JWT]...$suffix (${token.length} chars)';
  }

  /// Elimina tanto el token seguro como la información de usuario local
  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: _keyToken);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserRol);
  }
}
