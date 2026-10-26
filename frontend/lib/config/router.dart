import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/main_layout_screen.dart';
import '../presentation/screens/dashboard_screen.dart';
import '../presentation/screens/product_list_screen.dart';
import '../presentation/screens/product_detail_screen.dart';
import '../presentation/screens/product_form_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Contenedor principal con BottomNavigationBar y Drawer
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          int index = 0;
          if (state.matchedLocation.startsWith('/productos')) {
            index = 1;
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
        ],
      ),

      // Rutas fuera del Shell (pantallas completas)
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
