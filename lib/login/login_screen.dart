import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:semperMade/config/locator.dart';
import 'package:semperMade/config/router.dart';
import 'package:semperMade/services/snackbar_service.dart';

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

  late final StreamSubscription<User?> _authSubscription;

  var _isLoading = false;
  var _passwordHidden = true;

  @override
  void initState() {
    super.initState();
    var haveNavigated = false;
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null && !haveNavigated) {
        context.go(AppRoutes.login);
      } else {
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
        await firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on FirebaseAuthException catch (error) {
        _snackBarService.showErrorSnackBar(
          error.message ?? 'Error occurred during sign in',
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
                    child: TextFormField(
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
                    ),
                  ),
                  const Gap(10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
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
                    ),
                  ),
                  const Gap(20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('ZCRIPT AI')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const Gap(20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
