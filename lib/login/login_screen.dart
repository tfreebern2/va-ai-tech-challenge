import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:semperMade/config/locator.dart';
import 'package:semperMade/config/router.dart';
import 'package:semperMade/services/snackbar_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _snackBarService = locator<SnackBarService>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authSubscription;

  var _isLoading = false;
  var _passwordHidden = true;

  @override
  void initState() {
    super.initState();
    var haveNavigated = false;
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && !haveNavigated) {
        haveNavigated = true;
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await supabase.auth.signInWithPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on AuthException catch (error) {
        _snackBarService.showErrorSnackBar(
          error.message,
          stackTrace: StackTrace.current,
        );
        setState(() => _isLoading = false);
      } catch (_) {
        _snackBarService.showErrorSnackBar(
          'Error occurred during sign in',
          stackTrace: StackTrace.current,
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).largerThan(MOBILE)) {
      return Scaffold(
        appBar: AppBar(title: const Text('ZCRIPT AI')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const Gap(100),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: _emailFormField(),
                  ),
                  const Gap(10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: _passwordFormField(),
                  ),
                  const Gap(20),
                  _loginButton(),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('ZCRIPT AI')),
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _emailFormField(),
                  _passwordFormField(),
                  const Gap(20),
                  _loginButton(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  TextFormField _emailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter your email';
        }
        if (!EmailValidator.validate(val)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  TextFormField _passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _passwordHidden,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordHidden = !_passwordHidden;
            });
          },
          icon: const Icon(Icons.remove_red_eye),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  ElevatedButton _loginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signIn,
      child: const Text('Login'),
    );
  }
}
