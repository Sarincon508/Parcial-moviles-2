import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../widgets/status_views.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final provider = context.read<ProductProvider>();
      final prod = await provider.getProductById(widget.productId);
      if (mounted) {
        setState(() {
          _product = prod;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _confirmDelete() async {
    if (_product == null) return;

    final confirmed = await ConfirmDeleteDialog.show(
      context,
      productName: _product!.nombre,
      productCode: _product!.codigo,
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<ProductProvider>().deleteProduct(_product!.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Producto "${_product!.nombre}" eliminado correctamente.'),
              backgroundColor: const Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop(); // Regresar a la lista
        }
      } catch (e) {
        if (mounted) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
        actions: [
          if (_product != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Editar producto',
              onPressed: () async {
                await context.push('/productos/editar/${_product!.id}');
                _fetchDetail(); // Recargar detalle al regresar
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Eliminar producto',
              onPressed: _confirmDelete,
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const LoadingView(message: 'Cargando información del producto...')
          : _errorMessage != null
              ? ErrorView(
                  message: _errorMessage!,
                  onRetry: _fetchDetail,
                )
              : _product == null
                  ? const EmptyView(
                      title: 'Producto no encontrado',
                      subtitle: 'El producto solicitado no existe o fue eliminado.',
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tarjeta de Identificación
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'ID: #${_product!.id}',
                                          style: const TextStyle(
                                            color: Color(0xFF1E40AF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _product!.categoria,
                                          style: const TextStyle(
                                            color: Color(0xFF475569),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _product!.nombre,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.qr_code_2_rounded, size: 20, color: Color(0xFF64748B)),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Código único: ${_product!.codigo}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Tarjeta de Valores Financieros y Stock
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Información de Inventario',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _detailRow(
                                    icon: Icons.attach_money_rounded,
                                    label: 'Precio unitario',
                                    value: _product!.precioFormateado,
                                    valueColor: const Color(0xFF1E3A8A),
                                  ),
                                  const Divider(height: 24),
                                  _detailRow(
                                    icon: Icons.inventory_2_rounded,
                                    label: 'Unidades en stock',
                                    value: '${_product!.cantidad} unidades',
                                    valueColor: _product!.estaAgotado
                                        ? const Color(0xFFDC2626)
                                        : _product!.stockBajo
                                            ? const Color(0xFFD97706)
                                            : const Color(0xFF16A34A),
                                  ),
                                  const Divider(height: 24),
                                  _detailRow(
                                    icon: Icons.calculate_rounded,
                                    label: 'Valor total del stock',
                                    value: _product!.valorTotalFormateado,
                                    valueColor: const Color(0xFF0D9488),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Tarjeta de Descripción
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Descripción del Producto',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _product!.descripcion != null && _product!.descripcion!.isNotEmpty
                                        ? _product!.descripcion!
                                        : 'Sin descripción adicional registrada.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: _product!.descripcion != null && _product!.descripcion!.isNotEmpty
                                          ? const Color(0xFF334155)
                                          : const Color(0xFF94A3B8),
                                      fontStyle: _product!.descripcion != null && _product!.descripcion!.isNotEmpty
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Botones de acción inferiores
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: () async {
                                    await context.push('/productos/editar/${_product!.id}');
                                    _fetchDetail();
                                  },
                                  icon: const Icon(Icons.edit_outlined),
                                  label: const Text('Editar Producto'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDC2626),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: _confirmDelete,
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  label: const Text('Eliminar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
