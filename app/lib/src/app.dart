import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.black),
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p14),
            textStyle: const TextStyle(fontSize: 16.0),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontWeight: FontWeight.w400),
        ),
        useMaterial3: true,
      ),
      routerConfig: goRouter,
    );
  }
}
