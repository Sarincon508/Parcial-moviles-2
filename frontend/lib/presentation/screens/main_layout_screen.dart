import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0D9488)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.inventory_2_rounded, color: Color(0xFF1E3A8A), size: 32),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Gestión de Inventario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Solución API REST + Flutter Dio',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
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
        ],
      ),
    );
  }
}
