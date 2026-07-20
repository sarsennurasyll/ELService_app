import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/customer/presentation/pages/chat_page.dart';
import '../../features/customer/presentation/pages/create_order_page.dart';
import '../../features/customer/presentation/pages/home_page.dart';
import '../../features/customer/presentation/pages/order_details_page.dart';
import '../../features/customer/presentation/pages/orders_page.dart';
import '../../features/customer/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../shared/widgets/layout/screen.dart';
import '../../shared/widgets/navigation/admin_bottom_navigation.dart';
import '../../shared/widgets/navigation/customer_bottom_navigation.dart';
import '../../shared/widgets/navigation/technician_bottom_navigation.dart';
import 'app_routes.dart';

final class AppRouter {
  AppRouter()
    : router = GoRouter(
        routes: [
          GoRoute(
            path: AppRoutes.root,
            builder: (context, state) => const SplashPage(),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: AppRoutes.register,
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: AppRoutes.customerCreateOrder,
            builder: (context, state) => const CreateOrderPage(),
          ),
          GoRoute(
            path: AppRoutes.customerOrderDetails,
            builder: (context, state) {
              final orderId = state.pathParameters['id'] ?? '1';
              return OrderDetailsPage(orderId: orderId);
            },
          ),
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) => Screen(
              bottomNavigationBar: CustomerBottomNavigation(
                currentIndex: navigationShell.currentIndex,
                onDestinationSelected: navigationShell.goBranch,
              ),
              padding: EdgeInsets.zero,
              child: navigationShell,
            ),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.customerHome,
                    builder: (context, state) => const HomePage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.customerOrders,
                    builder: (context, state) => const OrdersPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.customerMessages,
                    builder: (context, state) => const ChatPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.customerProfile,
                    builder: (context, state) => const ProfilePage(),
                  ),
                ],
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) => Screen(
              bottomNavigationBar: const TechnicianBottomNavigation(),
              child: child,
            ),
            routes: [
              GoRoute(
                path: AppRoutes.technicianDashboard,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.technicianOrders,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.technicianWallet,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.technicianCalendar,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.technicianProfile,
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) => Screen(
              bottomNavigationBar: const AdminBottomNavigation(),
              child: child,
            ),
            routes: [
              GoRoute(
                path: AppRoutes.adminDashboard,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.adminOrders,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.adminUsers,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.adminAnalytics,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.adminSettings,
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),
        ],
      );

  final GoRouter router;
}
