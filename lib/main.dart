import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:semperMade/config/router.dart';
import 'package:semperMade/theme/color_themes.dart';
import 'package:semperMade/theme/text_themes.dart';
import 'package:semperMade/upload/cubit/upload_cubit.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadCubit>(
          create: (context) => UploadCubit(),
        ),
      ],
      child: const SemperMadeApp(),
    );
  }
}

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
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: textTheme,
      ),
      builder: (context, widget) => ResponsiveBreakpoints.builder(
        child: BouncingScrollWrapper.builder(context, widget!),
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
