import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/user.dart';

void main() {
  group('Pruebas Unitarias de Autenticación y Modelos JWT', () {
    test('Debe serializar y deserializar modelo User correctamente', () {
      final json = {
        'id': 1,
        'nombre': 'Administrador Sistema',
        'email': 'admin@inventario.com',
        'rol': 'admin',
        'created_at': '2026-11-10T12:00:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.id, equals(1));
      expect(user.nombre, equals('Administrador Sistema'));
      expect(user.email, equals('admin@inventario.com'));
      expect(user.rol, equals('admin'));
      expect(user.createdAt, equals('2026-11-10T12:00:00.000Z'));

      final map = user.toJson();
      expect(map['email'], equals('admin@inventario.com'));
      expect(map['rol'], equals('admin'));
    });

    test('Debe deserializar AuthResponse con token y datos de usuario', () {
      final jsonResponse = {
        'success': true,
        'message': 'Inicio de sesión exitoso',
        'data': {
          'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_token_signature',
          'usuario': {
            'id': 2,
            'nombre': 'Juan Pérez',
            'email': 'usuario@inventario.com',
            'rol': 'operador',
          }
        }
      };

      final authResponse = AuthResponse.fromJson(jsonResponse);

      expect(authResponse.success, isTrue);
      expect(authResponse.message, equals('Inicio de sesión exitoso'));
      expect(authResponse.token, isNotNull);
      expect(authResponse.token, contains('eyJhbGciOiJIUzI1Ni'));
      expect(authResponse.user, isNotNull);
      expect(authResponse.user!.nombre, equals('Juan Pérez'));
      expect(authResponse.user!.rol, equals('operador'));
    });

    test('Debe manejar AuthResponse con credenciales inválidas sin token', () {
      final jsonErrorResponse = {
        'success': false,
        'message': 'Credenciales inválidas. Correo electrónico o contraseña incorrectos.',
      };

      final authResponse = AuthResponse.fromJson(jsonErrorResponse);

      expect(authResponse.success, isFalse);
      expect(authResponse.token, isNull);
      expect(authResponse.user, isNull);
      expect(authResponse.message, contains('Credenciales inválidas'));
    });
  });
}
