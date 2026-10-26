import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../widgets/metric_card.dart';
import '../widgets/status_views.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final stats = provider.stats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualizar métricas',
            onPressed: () => provider.loadInitialData(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configurar servidor',
            onPressed: () => ServerConfigDialog.show(
              context,
              (newUrl) => provider.changeApiUrl(newUrl),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.loadInitialData(),
        child: provider.isLoading && stats == null
            ? const LoadingView(message: 'Cargando indicadores de inventario...')
            : provider.errorMessage != null && stats == null
                ? ErrorView(
                    message: provider.errorMessage!,
                    onRetry: () => provider.loadInitialData(),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado de bienvenida
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.store_rounded,
                                  color: Color(0xFF1E3A8A),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Sistema de Control de Stock',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Métricas en tiempo real desde la API REST',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Métricas Clave del Inventario',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // TARJETA 1: Total productos registrados
                        MetricCard(
                          title: 'Total de Productos',
                          value: '${stats?.totalProductos ?? 0}',
                          subtitle: 'Referencias activas registradas',
                          icon: Icons.category_rounded,
                          startColor: const Color(0xFF2563EB),
                          endColor: const Color(0xFF1D4ED8),
                          onTap: () => context.go('/productos'),
                        ),

                        const SizedBox(height: 12),

                        // TARJETA 2: Total unidades disponibles
                        MetricCard(
                          title: 'Unidades en Stock',
                          value: '${stats?.totalUnidades ?? 0}',
                          subtitle: 'Existencias físicas disponibles',
                          icon: Icons.inventory_2_rounded,
                          startColor: const Color(0xFF0D9488),
                          endColor: const Color(0xFF0F766E),
                          onTap: () => context.go('/productos'),
                        ),

                        const SizedBox(height: 12),

                        // TARJETA 3: Valor económico total (precio x cantidad)
                        MetricCard(
                          title: 'Valor Total del Inventario',
                          value: stats?.valorTotalFormateado ?? '\$0.00',
                          subtitle: 'Suma de (Precio × Cantidad) de cada producto',
                          icon: Icons.monetization_on_rounded,
                          startColor: const Color(0xFFD97706),
                          endColor: const Color(0xFFB45309),
                          onTap: () => context.go('/productos'),
                        ),

                        const SizedBox(height: 24),

                        // Accesos directos y Gestión
                        const Text(
                          'Acciones Rápidas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A8A),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () => context.go('/productos'),
                                icon: const Icon(Icons.list_alt_rounded),
                                label: const Text('Ver Productos'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D9488),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () => context.push('/productos/nuevo'),
                                icon: const Icon(Icons.add_circle_outline_rounded),
                                label: const Text('Nuevo Producto'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Resumen de estado rápido
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Estado de la Conexión',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Conectado a la API REST persistente mediante Dio con base de datos SQLite.',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Cualquier cambio registrado, editado o eliminado actualiza automáticamente los indicadores calculados de este dashboard.',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
