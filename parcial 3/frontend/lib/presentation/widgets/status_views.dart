import 'package:flutter/material.dart';
import '../../config/env.dart';

/// Vista de carga con mensaje
class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = 'Cargando información del inventario...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista de error con botón de reintentar
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: Color(0xFFDC2626),
                size: 48,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Error de comunicación con la API',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar conexión'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista cuando no hay registros en la lista
class EmptyView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyView({
    super.key,
    this.title = 'No hay productos registrados',
    this.subtitle = 'Comienza agregando el primer producto a tu inventario.',
    this.onAction,
    this.actionLabel = 'Registrar Producto',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF94A3B8),
                size: 54,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Diálogo de confirmación para eliminar
class ConfirmDeleteDialog extends StatelessWidget {
  final String productName;
  final String productCode;

  const ConfirmDeleteDialog({
    super.key,
    required this.productName,
    required this.productCode,
  });

  static Future<bool?> show(BuildContext context, {required String productName, required String productCode}) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        productName: productName,
        productCode: productCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 28),
          SizedBox(width: 10),
          Text('¿Eliminar producto?', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF334155), fontSize: 15, height: 1.4),
          children: [
            const TextSpan(text: '¿Está seguro de que desea eliminar el producto '),
            TextSpan(
              text: '"$productName" ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            TextSpan(text: 'con código '),
            TextSpan(
              text: '[$productCode]',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
            ),
            const TextSpan(text: '?\n\nEsta acción borrará el registro de la base de datos de forma permanente.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar', style: TextStyle(color: Color(0xFF64748B))),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Sí, Eliminar'),
        ),
      ],
    );
  }
}

/// Diálogo interactivo para cambiar la URL del servidor API
class ServerConfigDialog extends StatefulWidget {
  final Function(String newUrl) onSave;

  const ServerConfigDialog({super.key, required this.onSave});

  static void show(BuildContext context, Function(String newUrl) onSave) {
    showDialog(
      context: context,
      builder: (ctx) => ServerConfigDialog(onSave: onSave),
    );
  }

  @override
  State<ServerConfigDialog> createState() => _ServerConfigDialogState();
}

class _ServerConfigDialogState extends State<ServerConfigDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: Env.apiBaseUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: const [
          Icon(Icons.dns_rounded, color: Color(0xFF1E3A8A)),
          SizedBox(width: 8),
          Text('Configurar Servidor API', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajuste la URL base según su entorno de pruebas:',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'URL Base de la API',
                hintText: 'http://localhost:3000/api',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Accesos rápidos sugeridos:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _quickChip('Localhost PC', 'http://localhost:3000/api'),
                _quickChip('Emulador Android', 'http://10.0.2.2:3000/api'),
                _quickChip('Render/Cloud', 'https://tu-api.onrender.com/api'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSave(_controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Guardar y Reconectar'),
        ),
      ],
    );
  }

  Widget _quickChip(String label, String url) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      onPressed: () {
        setState(() {
          _controller.text = url;
        });
      },
    );
  }
}
