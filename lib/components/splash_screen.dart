import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semperMade/config/locator.dart';
import 'package:semperMade/config/router.dart';
import 'package:semperMade/services/snackbar_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _snackBarService = locator<SnackBarService>();

  @override
  void initState() {
    super.initState();
    _getInitialSession();
  }

  Future<void> _getInitialSession() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    try {
      final session = supabase.auth.currentSession;
      if (context.mounted) {
        session == null
            ? context.go(AppRoutes.login)
            : context.go(AppRoutes.home);
      }
    } catch (_) {
      _snackBarService.showErrorSnackBar(
        'Error occurred during session refresh',
        stackTrace: StackTrace.current,
      );
      if (mounted) context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
