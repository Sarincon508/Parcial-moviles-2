import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../widgets/status_views.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainLayoutScreen({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text(
          '¿Desea cerrar su sesión actual? Se eliminará el token de autenticación del dispositivo.',
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
    final user = auth.user;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0D9488)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  (user?.nombre.isNotEmpty == true ? user!.nombre[0] : 'U').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
              accountName: Text(
                user?.nombre ?? 'Usuario Autenticado',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Row(
                children: [
                  Expanded(
                    child: Text(
                      user?.email ?? 'correo@inventario.com',
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      (user?.rol ?? 'operador').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded, color: Color(0xFF1E3A8A)),
              title: const Text('Dashboard Principal'),
              selected: currentIndex == 0,
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_rounded, color: Color(0xFF0D9488)),
              title: const Text('Gestión de Productos'),
              selected: currentIndex == 1,
              onTap: () {
                Navigator.pop(context);
                context.go('/productos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined, color: Color(0xFF6366F1)),
              title: const Text('Información de Sesión'),
              selected: currentIndex == 2,
              onTap: () {
                Navigator.pop(context);
                context.go('/sesion');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_rounded, color: Color(0xFF2563EB)),
              title: const Text('Registrar Nuevo Producto'),
              onTap: () {
                Navigator.pop(context);
                context.push('/productos/nuevo');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.dns_rounded, color: Color(0xFFD97706)),
              title: const Text('Configuración Servidor API'),
              subtitle: const Text('Cambiar URL local o remota'),
              onTap: () {
                Navigator.pop(context);
                final provider = context.read<ProductProvider>();
                ServerConfigDialog.show(
                  context,
                  (newUrl) => provider.changeApiUrl(newUrl),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync_rounded, color: Color(0xFF64748B)),
              title: const Text('Sincronizar Datos'),
              onTap: () {
                Navigator.pop(context);
                context.read<ProductProvider>().loadInitialData();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.go('/productos');
          } else if (index == 2) {
            context.go('/sesion');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Productos',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle_rounded),
            label: 'Sesión',
          ),
        ],
      ),
    );
  }
}
