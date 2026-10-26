import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/status_views.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleDelete(BuildContext context, Product product) async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      productName: product.nombre,
      productCode: product.codigo,
    );

    if (confirmed == true && context.mounted) {
      final provider = context.read<ProductProvider>();
      try {
        await provider.deleteProduct(product.id!);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Producto "${product.nombre}" eliminado exitosamente.'),
              backgroundColor: const Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar productos',
            onPressed: () => provider.fetchProducts(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/productos/nuevo'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo Producto'),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => provider.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, código...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          provider.setSearchQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Filtro por categorías (chips horizontales)
          Container(
            height: 48,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.categorias.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = provider.categorias[index];
                final isSelected = provider.selectedCategory == cat;

                return FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => provider.setCategory(cat),
                  selectedColor: const Color(0xFF1E3A8A),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                  backgroundColor: const Color(0xFFF1F5F9),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF1E3A8A) : Colors.transparent,
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Contenido principal: Lista, Carga, Error o Vacío
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => provider.fetchProducts(),
              child: provider.isLoading && provider.products.isEmpty
                  ? const LoadingView(message: 'Consultando productos desde la API...')
                  : provider.errorMessage != null && provider.products.isEmpty
                      ? ErrorView(
                          message: provider.errorMessage!,
                          onRetry: () => provider.fetchProducts(),
                        )
                      : provider.products.isEmpty
                          ? EmptyView(
                              title: provider.searchQuery.isNotEmpty || provider.selectedCategory != 'Todas'
                                  ? 'No se encontraron coincidencias'
                                  : 'No hay productos registrados',
                              subtitle: provider.searchQuery.isNotEmpty || provider.selectedCategory != 'Todas'
                                  ? 'Intenta con otro término de búsqueda o categoría.'
                                  : 'Presiona el botón para agregar el primer producto a la base de datos.',
                              actionLabel: provider.searchQuery.isNotEmpty ? 'Limpiar filtros' : 'Registrar Producto',
                              onAction: () {
                                if (provider.searchQuery.isNotEmpty || provider.selectedCategory != 'Todas') {
                                  _searchController.clear();
                                  provider.clearFilters();
                                } else {
                                  context.push('/productos/nuevo');
                                }
                              },
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 8, bottom: 88),
                              itemCount: provider.products.length,
                              itemBuilder: (context, index) {
                                final product = provider.products[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () => context.push('/productos/detalle/${product.id}'),
                                  onEdit: () => context.push('/productos/editar/${product.id}'),
                                  onDelete: () => _handleDelete(context, product),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
