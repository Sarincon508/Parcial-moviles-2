import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/inventory_stats.dart';
import '../services/product_service.dart';
import '../services/api_service.dart';
import '../config/env.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  InventoryStats? _stats;
  List<String> _categorias = ['Todas'];
  String _selectedCategory = 'Todas';
  String _searchQuery = '';

  bool _isLoading = false;
  bool _isStatsLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get products => _products;
  InventoryStats? get stats => _stats;
  List<String> get categorias => _categorias;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  bool get isLoading => _isLoading;
  bool get isStatsLoading => _isStatsLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;

  /// Carga inicial combinada (Dashboard y Lista)
  Future<void> loadInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([
        fetchStats(silent: true),
        fetchProducts(silent: true),
        fetchCategorias(),
      ]);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Consulta y actualiza los indicadores del Dashboard
  Future<void> fetchStats({bool silent = false}) async {
    if (!silent) {
      _isStatsLoading = true;
      notifyListeners();
    }

    try {
      final fetchedStats = await _productService.getStats();
      _stats = fetchedStats;
      _errorMessage = null;
    } catch (e) {
      // Si la API de stats falla, calculamos localmente si tenemos productos
      if (_products.isNotEmpty) {
        _stats = InventoryStats.fromProductList(_products);
      } else {
        _errorMessage = e.toString();
      }
    } finally {
      if (!silent) {
        _isStatsLoading = false;
        notifyListeners();
      }
    }
  }

  /// Consulta la lista de productos aplicando los filtros activos
  Future<void> fetchProducts({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final fetchedProducts = await _productService.getProducts(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        categoria: _selectedCategory != 'Todas' ? _selectedCategory : null,
      );
      _products = fetchedProducts;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _products = [];
    } finally {
      if (!silent) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Consulta las categorías existentes
  Future<void> fetchCategorias() async {
    try {
      final list = await _productService.getCategorias();
      final set = <String>{'Todas', ...list};
      // Aseguramos categorías comunes por defecto si la base está nueva
      set.addAll(['Tecnología', 'Accesorios', 'Telefonía', 'Audio', 'Oficina']);
      _categorias = set.toList();
    } catch (_) {}
  }

  /// Filtrar por categoría
  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    fetchProducts();
  }

  /// Buscar por texto
  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchProducts();
  }

  /// Limpiar filtros de búsqueda
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'Todas';
    fetchProducts();
  }

  /// Obtener detalle de un producto por ID
  Future<Product?> getProductById(int id) async {
    try {
      return await _productService.getProductById(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Crear un nuevo producto (POST)
  Future<Product> createProduct(Product product) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      final nuevo = await _productService.createProduct(product);
      // Recargar datos y estadísticas automáticamente
      await fetchProducts(silent: true);
      await fetchStats(silent: true);
      await fetchCategorias();
      return nuevo;
    } catch (e) {
      rethrow;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// Actualizar un producto existente (PUT)
  Future<Product> updateProduct(int id, Product product) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      final actualizado = await _productService.updateProduct(id, product);
      // Recargar datos y estadísticas automáticamente
      await fetchProducts(silent: true);
      await fetchStats(silent: true);
      await fetchCategorias();
      return actualizado;
    } catch (e) {
      rethrow;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// Eliminar un producto (DELETE)
  Future<bool> deleteProduct(int id) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      final ok = await _productService.deleteProduct(id);
      if (ok) {
        // Remover de la lista local inmediatamente y refrescar stats
        _products.removeWhere((p) => p.id == id);
        await fetchStats(silent: true);
      }
      return ok;
    } catch (e) {
      rethrow;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// Cambiar URL base de la API en caliente
  void changeApiUrl(String newUrl) {
    Env.setCustomBaseUrl(newUrl);
    ApiService().resetClient();
    loadInitialData();
  }
}
