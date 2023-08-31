
import 'package:flutter/material.dart';
import 'package:semperMade/theme/color_themes.dart';
import 'package:semperMade/theme/text_themes.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'config/router.dart';

void main() => runApp(const SemperMadeApp());

/// The main app.
class SemperMadeApp extends StatelessWidget {
  /// Constructs a [SemperMadeApp]
  const SemperMadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SemperMade Demo',
      routerConfig: router,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: textTheme),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          textTheme: textTheme),
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget!),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.autoScale(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
        ],
        background: Container(color: Colors.white),
      ),
    );
  }
}
