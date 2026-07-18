import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

final class AppRouter {
  AppRouter()
    : router = GoRouter(
        routes: [
          GoRoute(
            path: AppRoutes.root,
            builder: (_, __) => const Scaffold(body: SizedBox.shrink()),
          ),
        ],
      );

  final GoRouter router;
}
