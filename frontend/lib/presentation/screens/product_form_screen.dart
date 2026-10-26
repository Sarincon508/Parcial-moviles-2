import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../services/api_service.dart';
import '../widgets/status_views.dart';

class ProductFormScreen extends StatefulWidget {
  final bool isEditing;
  final int? productId;

  const ProductFormScreen({
    super.key,
    required this.isEditing,
    this.productId,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _codigoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _cantidadController = TextEditingController();
  String _selectedCategory = 'Tecnología';

  bool _isFetchingInitial = false;
  bool _isSubmitting = false;

  final List<String> _categoriasDisponibles = [
    'Tecnología',
    'Accesorios',
    'Telefonía',
    'Audio',
    'Oficina',
    'Almacenamiento',
    'Componentes',
    'Mobiliario',
    'Video',
    'Diseño',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.productId != null) {
      _loadProductData();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _loadProductData() async {
    setState(() => _isFetchingInitial = true);

    try {
      final provider = context.read<ProductProvider>();
      final prod = await provider.getProductById(widget.productId!);

      if (prod != null && mounted) {
        _nombreController.text = prod.nombre;
        _codigoController.text = prod.codigo;
        _descripcionController.text = prod.descripcion ?? '';
        _precioController.text = prod.precio.toString();
        _cantidadController.text = prod.cantidad.toString();

        if (!_categoriasDisponibles.contains(prod.categoria)) {
          _categoriasDisponibles.add(prod.categoria);
        }
        _selectedCategory = prod.categoria;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos del producto: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingInitial = false);
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final provider = context.read<ProductProvider>();
    final productData = Product(
      id: widget.productId,
      nombre: _nombreController.text.trim(),
      codigo: _codigoController.text.trim().toUpperCase(),
      descripcion: _descripcionController.text.trim().isEmpty ? null : _descripcionController.text.trim(),
      precio: double.parse(_precioController.text.trim()),
      cantidad: int.parse(_cantidadController.text.trim()),
      categoria: _selectedCategory,
    );

    try {
      if (widget.isEditing) {
        await provider.updateProduct(widget.productId!, productData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Producto actualizado correctamente.'),
              backgroundColor: Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop(true);
        }
      } else {
        await provider.createProduct(productData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Producto registrado exitosamente en la base de datos.'),
              backgroundColor: Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop(true);
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditing ? 'Editar Producto' : 'Nuevo Producto';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _isFetchingInitial
          ? const LoadingView(message: 'Cargando datos del producto a editar...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tarjeta de información básica
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información Principal',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 16),

                            // Campo Nombre
                            TextFormField(
                              controller: _nombreController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                labelText: 'Nombre del Producto *',
                                hintText: 'Ej. Teclado Inalámbrico',
                                prefixIcon: Icon(Icons.shopping_bag_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingrese el nombre del producto.';
                                }
                                if (value.trim().length < 2) {
                                  return 'El nombre debe tener al menos 2 caracteres.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // Campo Código
                            TextFormField(
                              controller: _codigoController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: const InputDecoration(
                                labelText: 'Código Único *',
                                hintText: 'Ej. PROD-099',
                                prefixIcon: Icon(Icons.qr_code_rounded),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingrese el código único del producto.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // Selector de Categoría
                            DropdownButtonFormField<String>(
                              initialValue: _selectedCategory,
                              decoration: const InputDecoration(
                                labelText: 'Categoría *',
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              items: _categoriasDisponibles.map((cat) {
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedCategory = value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tarjeta de Precio e Inventario
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Precio y Existencias',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 16),

                            // Campo Precio
                            TextFormField(
                              controller: _precioController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Precio Unitario (\$) *',
                                hintText: 'Ej. 49.99',
                                prefixIcon: Icon(Icons.attach_money_rounded),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingrese el precio unitario.';
                                }
                                final p = double.tryParse(value.trim());
                                if (p == null || p <= 0) {
                                  return 'El precio debe ser un número mayor a 0.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // Campo Cantidad
                            TextFormField(
                              controller: _cantidadController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Cantidad Disponible en Stock *',
                                hintText: 'Ej. 25',
                                prefixIcon: Icon(Icons.inventory_2_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingrese la cantidad disponible.';
                                }
                                final c = int.tryParse(value.trim());
                                if (c == null || c < 0) {
                                  return 'La cantidad debe ser un entero mayor o igual a 0.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tarjeta de Descripción (Opcional)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Descripción Adicional (Opcional)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _descripcionController,
                              maxLines: 3,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                labelText: 'Detalles o especificaciones',
                                hintText: 'Ej. Especificaciones técnicas, garantía, dimensiones...',
                                alignLabelWithHint: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón Guardar
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: widget.isEditing ? const Color(0xFF2563EB) : const Color(0xFF0D9488),
                      ),
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      child: _isSubmitting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                ),
                                SizedBox(width: 12),
                                Text('Guardando cambios...'),
                              ],
                            )
                          : Text(
                              widget.isEditing ? 'Guardar Cambios (PUT)' : 'Registrar Producto (POST)',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),

                    const SizedBox(height: 12),

                    // Botón Cancelar
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isSubmitting ? null : () => context.pop(),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
