import 'package:intl/intl.dart';

class Product {
  final int? id;
  final String nombre;
  final String codigo;
  final String? descripcion;
  final double precio;
  final int cantidad;
  final String categoria;
  final String? createdAt;
  final String? updatedAt;

  Product({
    this.id,
    required this.nombre,
    required this.codigo,
    this.descripcion,
    required this.precio,
    required this.cantidad,
    required this.categoria,
    this.createdAt,
    this.updatedAt,
  });

  /// Crear una instancia desde un Map/JSON recibido de la API
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      nombre: json['nombre']?.toString() ?? '',
      codigo: json['codigo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      precio: json['precio'] != null
          ? double.tryParse(json['precio'].toString()) ?? 0.0
          : 0.0,
      cantidad: json['cantidad'] != null
          ? int.tryParse(json['cantidad'].toString()) ?? 0
          : 0,
      categoria: json['categoria']?.toString() ?? 'General',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  /// Serializar a JSON para enviar en peticiones POST o PUT
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'descripcion': descripcion ?? '',
      'precio': precio,
      'cantidad': cantidad,
      'categoria': categoria,
    };
  }

  /// Crea una copia del producto modificando campos específicos
  Product copyWith({
    int? id,
    String? nombre,
    String? codigo,
    String? descripcion,
    double? precio,
    int? cantidad,
    String? categoria,
    String? createdAt,
    String? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
      categoria: categoria ?? this.categoria,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Valor total del inventario de este producto (precio * cantidad)
  double get valorTotal => precio * cantidad;

  /// Indica si el producto está sin existencias
  bool get estaAgotado => cantidad <= 0;

  /// Indica si el producto tiene stock crítico (1 a 5 unidades)
  bool get stockBajo => cantidad > 0 && cantidad <= 5;

  /// Formateo del precio en moneda
  String get precioFormateado {
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 2);
    return currencyFormatter.format(precio);
  }

  /// Formateo del valor total del producto
  String get valorTotalFormateado {
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 2);
    return currencyFormatter.format(valorTotal);
  }
}
