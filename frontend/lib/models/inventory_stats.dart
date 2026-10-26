import 'package:intl/intl.dart';

class InventoryStats {
  final int totalProductos;
  final int totalUnidades;
  final double valorTotalInventario;

  InventoryStats({
    required this.totalProductos,
    required this.totalUnidades,
    required this.valorTotalInventario,
  });

  factory InventoryStats.fromJson(Map<String, dynamic> json) {
    return InventoryStats(
      totalProductos: json['totalProductos'] is int
          ? json['totalProductos']
          : int.tryParse(json['totalProductos']?.toString() ?? '0') ?? 0,
      totalUnidades: json['totalUnidades'] is int
          ? json['totalUnidades']
          : int.tryParse(json['totalUnidades']?.toString() ?? '0') ?? 0,
      valorTotalInventario: json['valorTotalInventario'] != null
          ? double.tryParse(json['valorTotalInventario']?.toString() ?? '0') ?? 0.0
          : 0.0,
    );
  }

  /// Calcula las estadísticas directamente a partir de una lista de productos
  factory InventoryStats.fromProductList(List dynamicProducts) {
    int count = dynamicProducts.length;
    int units = 0;
    double totalValue = 0.0;

    for (final p in dynamicProducts) {
      units += (p.cantidad as int);
      totalValue += (p.precio as double) * (p.cantidad as int);
    }

    return InventoryStats(
      totalProductos: count,
      totalUnidades: units,
      valorTotalInventario: totalValue,
    );
  }

  String get valorTotalFormateado {
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 2);
    return currencyFormatter.format(valorTotalInventario);
  }
}
