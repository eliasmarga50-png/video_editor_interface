
import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'presentation/router/app_router.dart';

class CineAIApp extends StatelessWidget {
  const CineAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineAI',
      debugShowCheckedModeBanner: false,
      theme: CineAITheme.dark,
      routerConfig: appRouter,
    );
  }
}
