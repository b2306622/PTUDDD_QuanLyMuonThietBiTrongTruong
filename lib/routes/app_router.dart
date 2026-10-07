import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/login_page.dart';
import '../views/home_page.dart';
import '../views/cart_page.dart';
import '../views/history_page.dart';
import '../views/profile_page.dart';
import '../views/main_layout.dart';
import '../views/device_detail_page.dart';
import '../views/admin_device_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const HomePage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/cart',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const CartPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const HistoryPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ProfilePage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/device/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DeviceDetailPage(deviceId: id);
        },
      ),
      GoRoute(
        path: '/admin/devices',
        builder: (context, state) => const AdminDevicePage(),
      ),
    ],
  );
}
