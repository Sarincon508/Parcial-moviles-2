import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/main_layout_screen.dart';
import '../presentation/screens/dashboard_screen.dart';
import '../presentation/screens/product_list_screen.dart';
import '../presentation/screens/product_detail_screen.dart';
import '../presentation/screens/product_form_screen.dart';
import '../presentation/screens/session_info_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Crea la instancia de GoRouter vinculada al AuthProvider
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggingIn = state.matchedLocation == '/login';
        final isChecking = authProvider.isChecking;

        // Si la aplicación aún está validando el almacenamiento seguro, esperar
        if (isChecking) {
          return null;
        }

        final isAuthenticated = authProvider.isAuthenticated;

        // Si el usuario NO está autenticado y trata de ingresar a cualquier ruta protegida
        if (!isAuthenticated && !isLoggingIn) {
          return '/login';
        }

        // Si el usuario YA está autenticado y se encuentra en la pantalla de login
        if (isAuthenticated && isLoggingIn) {
          return '/';
        }

        return null;
      },
      routes: [
        // Pantalla de Login fuera del Shell
        GoRoute(
          path: '/login',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const LoginScreen(),
        ),

        // Contenedor principal con BottomNavigationBar y Drawer
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            int index = 0;
            if (state.matchedLocation.startsWith('/productos')) {
              index = 1;
            } else if (state.matchedLocation.startsWith('/sesion')) {
              index = 2;
            }
            return MainLayoutScreen(
              currentIndex: index,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: DashboardScreen(),
              ),
            ),
            GoRoute(
              path: '/productos',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProductListScreen(),
              ),
            ),
            GoRoute(
              path: '/sesion',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SessionInfoScreen(),
              ),
            ),
          ],
        ),

        // Rutas fuera del Shell (pantallas completas modales)
        GoRoute(
          path: '/productos/nuevo',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const ProductFormScreen(
            isEditing: false,
          ),
        ),
        GoRoute(
          path: '/productos/detalle/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final idStr = state.pathParameters['id'] ?? '0';
            final id = int.tryParse(idStr) ?? 0;
            return ProductDetailScreen(productId: id);
          },
        ),
        GoRoute(
          path: '/productos/editar/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final idStr = state.pathParameters['id'] ?? '0';
            final id = int.tryParse(idStr) ?? 0;
            return ProductFormScreen(
              isEditing: true,
              productId: id,
            );
          },
        ),
      ],
    );
  }
}
