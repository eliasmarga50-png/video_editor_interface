import 'package:flutter/material.dart';
import 'presentation/router/app_router.dart';

class CineAIApp extends StatelessWidget {
  const CineAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
        primaryColor: const Color(0xFF8B5CF6),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}