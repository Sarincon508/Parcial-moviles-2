class User {
  final int id;
  final String nombre;
  final String email;
  final String rol;
  final String? createdAt;

  User({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      rol: json['rol']?.toString() ?? 'operador',
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'created_at': createdAt,
    };
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final User? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return AuthResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      token: data?['token']?.toString(),
      user: data?['usuario'] != null ? User.fromJson(data!['usuario']) : null,
    );
  }
}
