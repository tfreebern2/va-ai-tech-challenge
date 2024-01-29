import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:semperMade/config/locator.dart';
import 'package:semperMade/config/router.dart';
import 'package:semperMade/services/snackbar_service.dart';
import 'package:semperMade/theme/color_themes.dart';
import 'package:semperMade/theme/text_themes.dart';
import 'package:semperMade/upload/cubit/upload_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'firebaseApiKey',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? 'firebaseAppId',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'firebaseMessagingSenderId',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'firebaseProjectId',
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'firebaseAuthDomain',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'firebaseStorageBucket',
    ),
  );

  setupLocator();

  runApp(const App());
}

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
      scaffoldMessengerKey: locator<SnackBarService>().scaffoldMessengerKey,
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
