import '../models/product.dart';
import '../models/inventory_stats.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  /// GET /api/productos
  /// Obtiene la lista completa de productos desde la base de datos
  Future<List<Product>> getProducts({String? search, String? categoria}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (categoria != null && categoria.trim().isNotEmpty && categoria != 'Todas') {
        queryParams['categoria'] = categoria.trim();
      }

      final response = await _apiService.client.get(
        '/productos',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data['data'] ?? [];
        return list.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
      }

      return [];
    } catch (e) {
      throw _apiService.handleDioError(e);
    }
  }

  /// GET /api/productos/:id
  /// Obtiene el detalle completo de un producto por su identificador
  Future<Product> getProductById(int id) async {
    try {
      final response = await _apiService.client.get('/productos/$id');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        return Product.fromJson(data);
      }

      throw ApiException(message: 'No se encontraron datos para el producto #$id');
    } catch (e) {
      throw _apiService.handleDioError(e);
    }
  }

  /// POST /api/productos
  /// Registra un nuevo producto en la base de datos
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _apiService.client.post(
        '/productos',
        data: product.toJson(),
      );

      if (response.statusCode == 201 && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        return Product.fromJson(data);
      }

      throw ApiException(message: 'Respuesta inesperada al crear el producto.');
    } catch (e) {
      throw _apiService.handleDioError(e);
    }
  }

  /// PUT /api/productos/:id
  /// Actualiza un producto existente en la base de datos
  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await _apiService.client.put(
        '/productos/$id',
        data: product.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        return Product.fromJson(data);
      }

      throw ApiException(message: 'Respuesta inesperada al actualizar el producto.');
    } catch (e) {
      throw _apiService.handleDioError(e);
    }
  }

  /// DELETE /api/productos/:id
  /// Elimina un producto de la base de datos
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _apiService.client.delete('/productos/$id');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      throw _apiService.handleDioError(e);
    }
  }

  /// GET /api/productos/stats
  /// Consulta los indicadores calculados del inventario
  Future<InventoryStats> getStats() async {
    try {
      final response = await _apiService.client.get('/productos/stats');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        return InventoryStats.fromJson(data);
      }

      return InventoryStats(totalProductos: 0, totalUnidades: 0, valorTotalInventario: 0.0);
    } catch (e) {
      throw _apiService.handleDioError(e);
    }
  }

  /// GET /api/productos/categorias
  /// Obtiene las categorías únicas disponibles en el sistema
  Future<List<String>> getCategorias() async {
    try {
      final response = await _apiService.client.get('/productos/categorias');

      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data['data'] ?? [];
        return list.map((c) => c.toString()).toList();
      }

      return [];
    } catch (e) {
      // Si falla la consulta de categorías, devolvemos lista vacía
      return [];
    }
  }
}
