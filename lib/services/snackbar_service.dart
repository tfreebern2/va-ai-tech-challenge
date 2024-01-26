import 'dart:developer';

import 'package:flutter/material.dart';

class SnackBarService {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  void showSnackBar({
    required String message,
    Color? backgroundColor,
  }) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar(String message, {StackTrace? stackTrace}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
    log(message, stackTrace: stackTrace ?? StackTrace.current);
  }
}
