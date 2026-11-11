import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SessionInfoScreen extends StatelessWidget {
  const SessionInfoScreen({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text(
          '¿Está seguro de que desea cerrar la sesión actual? Se eliminará el token JWT de flutter_secure_storage y sus datos locales.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Sesión'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de Perfil y Estado
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.account_circle_rounded,
                        size: 64,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.nombre ?? 'Sin Usuario',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'correo@desconocido.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Badge de Estado de Sesión
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: auth.isAuthenticated
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: auth.isAuthenticated
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            auth.isAuthenticated
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            size: 16,
                            color: auth.isAuthenticated
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            auth.isAuthenticated ? 'Sesión Activa 🟢' : 'Sin Sesión 🔴',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: auth.isAuthenticated
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tarjeta de Detalles Técnicos de la Sesión
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.security_rounded, color: Color(0xFF0D9488), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Detalles de Seguridad JWT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Rol del usuario
                    _buildInfoRow(
                      context,
                      label: 'Rol del Usuario:',
                      value: user?.rol.toUpperCase() ?? 'N/A',
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 12),

                    // ID de Usuario en Base de Datos
                    _buildInfoRow(
                      context,
                      label: 'ID de Base de Datos:',
                      value: user != null ? '#${user.id}' : 'N/A',
                      icon: Icons.tag_rounded,
                    ),
                    const SizedBox(height: 12),

                    // Indicador de existencia del token (cumpliendo req 2.5)
                    _buildInfoRow(
                      context,
                      label: 'Estado del Token JWT:',
                      value: auth.isAuthenticated
                          ? 'Token Presente y Válido (Bearer)'
                          : 'No Almacenado',
                      icon: Icons.vpn_key_rounded,
                    ),
                    const SizedBox(height: 12),

                    // Vista previa protegida del token (sin mostrar contenido completo)
                    const Text(
                      'Indicador de Token Almacenado (Enmascarado):',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: SelectableText(
                        auth.tokenPreview ?? 'No hay token almacenado',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Almacenamiento seguro utilizado
                    Row(
                      children: const [
                        Icon(Icons.storage_rounded, size: 16, color: Color(0xFF2563EB)),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Almacenamiento: flutter_secure_storage (Token) + shared_preferences (Perfil)',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botón de Cerrar Sesión
            ElevatedButton.icon(
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                'Cerrar Sesión',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
