import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/inventory_stats.dart';

void main() {
  group('Pruebas Unitarias del Modelo Product', () {
    test('Debe calcular correctamente el valor total del inventario de un producto', () {
      final product = Product(
        id: 1,
        nombre: 'Laptop Gamer',
        codigo: 'PROD-001',
        precio: 1200.0,
        cantidad: 5,
        categoria: 'Tecnología',
      );

      expect(product.valorTotal, equals(6000.0));
      expect(product.estaAgotado, isFalse);
      expect(product.stockBajo, isTrue); // 5 unidades es stock crítico
    });

    test('Debe detectar correctamente productos agotados', () {
      final product = Product(
        id: 2,
        nombre: 'Teclado Mecánico',
        codigo: 'PROD-002',
        precio: 50.0,
        cantidad: 0,
        categoria: 'Accesorios',
      );

      expect(product.estaAgotado, isTrue);
      expect(product.stockBajo, isFalse);
      expect(product.valorTotal, equals(0.0));
    });

    test('Debe serializar y deserializar JSON correctamente', () {
      final json = {
        'id': 10,
        'nombre': 'Monitor 4K',
        'codigo': 'PROD-010',
        'descripcion': 'Pantalla IPS UHD',
        'precio': 350.50,
        'cantidad': 12,
        'categoria': 'Monitores',
      };

      final product = Product.fromJson(json);

      expect(product.id, equals(10));
      expect(product.nombre, equals('Monitor 4K'));
      expect(product.codigo, equals('PROD-010'));
      expect(product.precio, equals(350.50));
      expect(product.cantidad, equals(12));
      expect(product.categoria, equals('Monitores'));

      final serialized = product.toJson();
      expect(serialized['codigo'], equals('PROD-010'));
      expect(serialized['precio'], equals(350.50));
    });
  });

  group('Pruebas Unitarias de InventoryStats', () {
    test('Debe calcular sumatorias y valor económico de una lista de productos', () {
      final products = [
        Product(nombre: 'Item A', codigo: 'A', precio: 100.0, cantidad: 2, categoria: 'C1'),
        Product(nombre: 'Item B', codigo: 'B', precio: 50.0, cantidad: 4, categoria: 'C2'),
      ];

      final stats = InventoryStats.fromProductList(products);

      expect(stats.totalProductos, equals(2));
      expect(stats.totalUnidades, equals(6));
      expect(stats.valorTotalInventario, equals(400.0)); // (100*2) + (50*4) = 200 + 200 = 400
    });
  });
}
