// Routes
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semperMade/components/menu_scaffold.dart';
import 'package:semperMade/components/splash_screen.dart';
import 'package:semperMade/home/ui/home.dart';
import 'package:semperMade/login/login_screen.dart';
import 'package:semperMade/record/ui/record_screen.dart';
import 'package:semperMade/upload/ui/upload_screen.dart';

class AppRoutes {
  static const index = '/';
  static const login = '/login';
  static const home = '/home';
  static const record = '/record';
  static const upload = '/upload';

  static const List<String> routes = [home, record, upload];
}

final router = GoRouter(
  initialLocation: AppRoutes.index,
  // auth protected routes
  redirect: (BuildContext context, GoRouterState state) async {
    if (state.path != AppRoutes.login) {
      // check Firebase user session
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return AppRoutes.login;
      }
      return null;
    }
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.index,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const MenuScaffold(
          routeNames: AppRoutes.routes,
          child: HomeScreen(),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.record.substring(1),
          builder: (BuildContext context, GoRouterState state) {
            return const MenuScaffold(
              routeNames: AppRoutes.routes,
              child: RecordScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.upload.substring(1),
          builder: (BuildContext context, GoRouterState state) {
            return const MenuScaffold(
              routeNames: AppRoutes.routes,
              child: UploadScreen(),
            );
          },
        ),
      ],
    ),
  ],
);
