// Routes
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semperMade/components/menu_scaffold.dart';
import 'package:semperMade/screens/home/home_screen.dart';
import 'package:semperMade/screens/record/record_screen.dart';
import 'package:semperMade/screens/upload/upload_screen.dart';

class AppRoutes {
  static const home = 'home';
  static const record = 'record';
  static const upload = 'upload';

  static const List<String> routes = [home, record, upload];
}

final router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MenuScaffold(
          routeNames: AppRoutes.routes,
          child: HomeScreen(),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.record,
          builder: (BuildContext context, GoRouterState state) {
            return const MenuScaffold(
              routeNames: AppRoutes.routes,
              child: RecordScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.upload,
          builder: (BuildContext context, GoRouterState state) {
            return const MenuScaffold(
              routeNames: AppRoutes.routes,
              child: UploadScreen(),
            );
          },
        ),
      ],
    ),
    // GoRoute(
    //   path: '/${AppRoutes.home}',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const MenuScaffold(
    //       routeNames: AppRoutes.routes,
    //       child: HomeScreen(),
    //     );
    //   },
    // ),
  ],
);
