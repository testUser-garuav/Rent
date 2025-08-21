import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'navigation/app_router.dart';
import 'providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables if present (.env file)
  await dotenv.load(fileName: ".env", isOptional: true);

  runApp(const ProviderScope(child: RentalApp()));
}

class RentalApp extends ConsumerWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Rental App',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: authState.when(
        data: (user) => user != null ? AppRouter.homeRoute : AppRouter.loginRoute,
        loading: () => AppRouter.splashRoute,
        error: (_, __) => AppRouter.loginRoute,
      ),
    );
  }
}
