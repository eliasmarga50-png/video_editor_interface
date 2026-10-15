import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/auth_providers.dart';
import '../screens/home_screen.dart';
import '../screens/project_setup_screen.dart';
import '../screens/analysis_progress_screen.dart';
import '../screens/editor_timeline_screen.dart';
import '../screens/ai_explain_screen.dart';
import '../screens/ai_lab_settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

const Set<String> _publicRoutes = {'/login', '/signup'};

final routerProvider = Provider<GoRouter>((ref) {
  // Re-run the redirect whenever the auth status changes.
  final ValueNotifier<int> authChanged = ValueNotifier<int>(0);

  ref.listen<AuthState>(authControllerProvider, (previous, next) {
    if (previous?.status != next.status) authChanged.value++;
  });

  final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: authChanged,
    redirect: (context, state) {
      final AuthStatus status = ref.read(authControllerProvider).status;
      final String location = state.matchedLocation;
      final bool onPublic = _publicRoutes.contains(location);

      switch (status) {
        case AuthStatus.unknown:
          return location == '/splash' ? null : '/splash';
        case AuthStatus.unauthenticated:
          return onPublic ? null : '/login';
        case AuthStatus.authenticated:
          return (onPublic || location == '/splash') ? '/' : null;
      }
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/setup', builder: (context, state) => const ProjectSetupScreen()),
      GoRoute(path: '/analyzing', builder: (context, state) => const AnalysisProgressScreen()),
      GoRoute(path: '/editor', builder: (context, state) => const EditorTimelineScreen()),
      GoRoute(path: '/explain', builder: (context, state) => const AIExplainScreen()),
      GoRoute(path: '/lab', builder: (context, state) => const AILabSettingsScreen()),
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    authChanged.dispose();
  });

  return router;
});