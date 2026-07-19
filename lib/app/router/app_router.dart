import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            redirect: (context, state) => AppRoutes.customerHome,
          ),
          ShellRoute(
            builder: (context, state, child) => Screen(
              bottomNavigationBar: const CustomerBottomNavigation(),
              child: child,
            ),
            routes: [
              GoRoute(
                path: AppRoutes.customerHome,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.customerOrders,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.customerMessages,
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: AppRoutes.customerProfile,
                builder: (context, state) => const Placeholder(),
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
