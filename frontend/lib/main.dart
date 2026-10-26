import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/env.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno (.env)
  await Env.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider()..loadInitialData(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Gestión de Inventario',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
