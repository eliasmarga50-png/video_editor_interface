import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme.dart';
import 'presentation/router/app_router.dart';

class CineAIApp extends ConsumerWidget {
  const CineAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'CineAI',
      debugShowCheckedModeBanner: false,
      theme: CineAITheme.dark,
      darkTheme: CineAITheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
    );
  }
}