import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/env.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno (.env)
  await Env.init();

  // Inicializar proveedor de autenticación y verificar persistencia del token
  final authProvider = AuthProvider();
  await authProvider.checkAuthStatus();

  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatefulWidget {
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authProvider});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(widget.authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: widget.authProvider,
        ),
        ChangeNotifierProvider(
          create: (_) {
            final productProvider = ProductProvider();
            // Solo cargar los productos si el usuario ya cuenta con sesión activa
            if (widget.authProvider.isAuthenticated) {
              productProvider.loadInitialData();
            }
            return productProvider;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Gestión de Inventario (JWT)',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
